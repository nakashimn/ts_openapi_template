import express, { Request, Response, NextFunction } from "express";
import { initialize } from "express-openapi";
import path from "path";

const port: number = 3000;

const app: express.Express = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.listen(port, ()=>{
    console.log(`Start on port ${port}`);
})

initialize({
    app: app,
    apiDoc: path.resolve(__dirname, "openapi/root.yaml"),
    validateApiDoc: true,

    // describe API functions
    operations: {
        hello: [
            function (req: Request, res: Response, next: NextFunction) {
                next();
            },
            function (req: Request, res: Response) {
                res.send({
                    response: "hello"
                });
            }
        ],
        call: [
            function (req: Request, res:Response, next: NextFunction) {
                next();
            },
            function (req: Request, res:Response) {
                res.send({response: "test"});
            }
        ]
    }
})
