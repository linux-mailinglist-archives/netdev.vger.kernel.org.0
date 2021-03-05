Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CAC32E714
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 12:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCELO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 06:14:26 -0500
Received: from smtp-36-i2.italiaonline.it ([213.209.12.36]:56726 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhCELOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 06:14:06 -0500
Received: from oxapps-13-074.iol.local ([10.101.8.84])
        by smtp-36.iol.local with ESMTPA
        id I8PBl75iAQTiRI8PBlPJK0; Fri, 05 Mar 2021 12:14:02 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614942842; bh=4maFXkqmUJEe+BZawVLmBuDMX/eeiEMfOBoo2O0CFY8=;
        h=From;
        b=Y1ePpeNj0trBZ4cBLnI7ILTOoaPYW/XFv49RyL2VJNSZGVpPh3hH+fv7usnU0lXyO
         BYldguTb+J6wPC5ul+Pjlq9YZrtmos2HoCYgGstGY85p7E20HAlNphv75/vtOa4e8Z
         aGEiSA+5XEpdIQx+JzdnK+P7cTF6XhHCZeM6xLW+hAv+T6W4zlb5BPpcKHqHdtqaTn
         0SQgy0hJuTCh6EzLM7aDzg8B0knuXlXHWocnf1jQD1iqhNQ8VsZ/PPukcIwo/4XMbw
         bgXrYvXvqVExz7S6gXcjvUQ7kbdi1W8oEonznwSJSWiDLGWpA6i9xjIAhcg4XChccB
         9809inXdsWP3Q==
X-CNFS-Analysis: v=2.4 cv=TeVTCTch c=1 sm=1 tr=0 ts=6042127a cx=a_exe
 a=+htklNqd2nUvwHGxo3khsw==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9
 a=NricJypb2XC9C9Ua:21 a=rXGFr5rhA7SVz9Jy:21 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22 a=BPzZvq435JnGatEyYwdK:22
Date:   Fri, 5 Mar 2021 12:14:01 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1019942000.124735.1614942841458@mail1.libero.it>
In-Reply-To: <20210304152618.rqajqmzcqqhszfem@pengutronix.de>
References: <20210302215435.18286-1-dariobin@libero.it>
 <20210302215435.18286-6-dariobin@libero.it>
 <20210304152618.rqajqmzcqqhszfem@pengutronix.de>
Subject: Re: [PATCH v4 5/6] can: c_can: prepare to up the message objects
 number
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 185.33.57.41
X-Originating-Client: open-xchange-appsuite
x-libjamsun: mKklKnrX9uHytB2kgDfilAUFtfRItPJM
x-libjamv: AJ6qckmO+SE=
X-CMAE-Envelope: MS4xfDADRsJMSmw6ha1DJdHMGkYMuRcnyKWlNKxgNQIG0yEV9tVUH6dmOc7CPSrUwSVcmUZ8F022fVRHTXsLFSNJowBOYrdux/TCjDk7HVNAjQXRWRn8jvl6
 F4mbJrZ8VrmKcNsghRV2gG5L4XFWWq/susSjvjWW+SoJYb0/KORjXZs7pml2cfIf2GxvnLQK1N1lIOqp7AvDQtHau4ThiWmDOQ1KaWJn9yP71b3C0uiqJ5Bq
 NBi4Lz9Op9meGZEXyiubzpoZLTus+ccMsqAjLhcj7Ab7KfTExp+RGI8I9sKr4lvKXyQCZgrB/PglHd7g97DO/57HH9Esz6gGBvuzyE6GfCsbxcmjHCz9uRVb
 cWp1bYspGczFRNCmiShlzbOWRsHVgQdMjqb9hw7K3ssDHrw3oafFO/fzRgpSDnq7ZksRXk8awuKdG5LUtgSk/l9ffTM0myX2YxUefG0wLhEWtdQWZS/TbNXF
 Hy2h71RwKQDNDAf4GIUBUigWwfTud1xDRqvshCBvgB9OW9EWALB6QVZvljqCPuJhgbA2tuikDvPKgtb2G67l0+2f6FX6XPtmsp3YPy1Vmlz+ppOcLOGqv1Df
 3wPud6zdAtyat9ZAz+zbCUBxdzNP08SdTVoBFTj59nhQYA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Il 04/03/2021 16:26 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 02.03.2021 22:54:34, Dario Binacchi wrote:
> > diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> > index 77b9aee56154..0052ba5197e0 100644
> > --- a/drivers/net/can/c_can/c_can.c
> > +++ b/drivers/net/can/c_can/c_can.c
> [...]
> > -struct net_device *alloc_c_can_dev(void)
> > +struct net_device *alloc_c_can_dev(int msg_obj_num)
> >  {
> >  	struct net_device *dev;
> >  	struct c_can_priv *priv;
> > +	int msg_obj_tx_num = msg_obj_num / 2;
> >  
> > -	dev = alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> > +	dev = alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> > +			   msg_obj_tx_num);
> 
> I've converted this to make use of the struct_size() macro:
> 
> +       dev = alloc_candev(struct_size(priv, dlc, msg_obj_tx_num),
> +                          msg_obj_tx_num);
> 

Nice!
I learned a new thing.

Thanks and regards,
Dario

> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
