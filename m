Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9313287F2
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 18:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhCARay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 12:30:54 -0500
Received: from smtp-31-i2.italiaonline.it ([213.209.12.31]:56295 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237360AbhCARWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 12:22:38 -0500
Received: from oxapps-30-132.iol.local ([10.101.8.178])
        by smtp-31.iol.local with ESMTPA
        id GmEolCaigVpAbGmEolVksZ; Mon, 01 Mar 2021 18:21:43 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614619304; bh=ELHHirX/rHrzCr8RdE/L9KdYRZbNnQKFFnNxXi1w8EU=;
        h=From;
        b=KwaFNDQUVgU9gM6pxpH76TBUQp8noyQ/Eh7w092d/TTi+bc3SmvKkSjaGfWQOwLjb
         KptPGEZv7hpzpLPHeo6po+7xervW5W/uvk2vswCft6vzs5tCzji40IrNZDYWiW+mZi
         2IYCvK9122UJqXAELPcWNI0wbW09GBTv7et1QrbqMjogvj1PF8jYnYFriQqRN+puil
         ha8doJmsEfsTeaIBcJK2ZCt7mAHdeV5884hzuM+A55F6hEFpILbMe4zHSvCmNkU6FB
         IRtsX4B0NB/SO7Yh5f13QYgTbsWbbAk05gVHbRTEg4TB8gM5LP/PPAWV/pCJhh0jh3
         8GgDRGGQQu2Iw==
X-CNFS-Analysis: v=2.4 cv=WMS64lgR c=1 sm=1 tr=0 ts=603d22a8 cx=a_exe
 a=iUxb6lXnTT1s429i9ALYXg==:117 a=UPWQtH3J-JgA:10 a=IkcTkHD0fZMA:10
 a=_gZzKa99_6AA:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Mon, 1 Mar 2021 18:21:42 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1037673059.602534.1614619302914@mail1.libero.it>
In-Reply-To: <20210301113805.jylhc373sip7zmed@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210301113805.jylhc373sip7zmed@pengutronix.de>
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 87.20.116.197
X-Originating-Client: open-xchange-appsuite
x-libjamsun: BbLCwLDUl8yEj6k34kETrEsxm0xv+7N3
x-libjamv: SzWzyhp462U=
X-CMAE-Envelope: MS4xfBJxX6+FRTbJIR+f3u0MrRX5DYxea0av406W91FF3BXLet5O/Db3PK5csHSd4CDbiUyirNi3JI9H4yA2V24KsJSB82i8fgeEN8T0nbJEU11oCrHoMvNI
 9GtzGH8wsnJnbgAV8O0ffyXV6/3sd9I3QnugSr+62lJ7SPSTJOlz6FNeAB50odDwBZ5wwQzS+JkWdz+LM+Se25wo3U/h66oQ9R+9xHt8LExJ8EqhmW2LeOAt
 c9Bk3PDthzG6uzRrygPJwWMRG2VPkUC8HjP9ET+wdcVfDDWbN2bEdWwk1Dx9ZDVWa3XfoqUDRkwWXfHd00xeeRn/TMNxPon6o6U7pf4E5D+dfUQlgtijP6L/
 ifXdF7kL0Gjv7qsZ2ZmjmsLSqosNxsQLvTD2mRHa+d65QZLfVpNQC6w35ItpxshHj8rxV1bga0hBJ08yieDaZ69FnjyjYuttf7Ykjxa/cHc1Kf/NEWlzep97
 L7YR2lHtC1Ix1LGGbJpF0VI5QjrdtKgiw0cGHW+Ju56Pugxk6sEVzllDEfDFXRkEIGHJFtIC7iIDw2UrtCWVWj17ZSrbuO/eLFSTQX8oYQt2pExvLzC6cXMt
 eT/ROli/IUzoZ/GzVqH5Lmw9Pm1Qofxw9mUHQY4k3TsioQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 01/03/2021 12:38 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 28.02.2021 11:38:54, Dario Binacchi wrote:
> [...]
> 
> > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	while ((idx = ffs(pend))) {
> >  		idx--;
> >  		pend &= ~(1 << idx);
> > -		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > +		obj = idx + priv->msg_obj_tx_first;
> >  		c_can_inval_tx_object(dev, IF_TX, obj);
> >  		can_get_echo_skb(dev, idx, NULL);
> >  		bytes += priv->dlc[idx];
> > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	/* Clear the bits in the tx_active mask */
> >  	atomic_sub(clr, &priv->tx_active);
> >  
> > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
> 
> Do we need 1UL here, too?

Do you agree if I use the BIT macro ?

Thanks and regards
Dario

> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
