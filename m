Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA732B375
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352547AbhCCD5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:57:07 -0500
Received: from smtp-34-i2.italiaonline.it ([213.209.12.34]:53014 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383212AbhCBKvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 05:51:52 -0500
Received: from oxapps-10-055.iol.local ([10.101.8.65])
        by smtp-34.iol.local with ESMTPA
        id H2c8l94sm5WrZH2c8l4zHI; Tue, 02 Mar 2021 11:50:53 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614682253; bh=C0Y4sFONm5SoSXiJY4aW33P4LBjyO5IeaOw3cbk+ueA=;
        h=From;
        b=TEOGE+yOsT2CVAVfBpT55ktP1Xt651fAY6ar2GbaDm7U/NUrpOsXk7aCYUIPjqRcp
         akYr+SmiXwSksRBJDhFC2hi1uxvziAA8XoniQtmhHzbqMIHQ/qOwArUjSfeS1zFu3o
         Nx2RwlYtv/19BWc8aEmntRDSyAu+MHSYhdLJOi92j7F7BIYiXkyOI3bCSn87qOwLRS
         M5RMklT6+BlO3c4mj2oLpkXMgw7wz7HW6yg//blJSA0GqZHNfiPYuxLpumcbPeR0ti
         xAxIsIHn0bD/ZQksrrx9+X01qO+9oi3fzctkrUxUum5gO8+qjPU8HKjsUP5wmKziEx
         U/hBlH/Kyr9gQ==
X-CNFS-Analysis: v=2.4 cv=W4/96Tak c=1 sm=1 tr=0 ts=603e188d cx=a_exe
 a=Xcto81xy1FNFSyA6Xjc/hA==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9
 a=XoIhxgry9z_zYQRl:21 a=C3h1kYaqPfvzLjQo:21 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Tue, 2 Mar 2021 11:50:52 +0100 (CET)
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
Message-ID: <1154674280.137227.1614682252245@mail1.libero.it>
In-Reply-To: <20210301194550.6zqmxzcwvzlgjzcj@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210301113805.jylhc373sip7zmed@pengutronix.de>
 <1037673059.602534.1614619302914@mail1.libero.it>
 <20210301194550.6zqmxzcwvzlgjzcj@pengutronix.de>
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 185.33.57.41
X-Originating-Client: open-xchange-appsuite
x-libjamsun: DN0WFxwHZZBmmj1Vh68r9MQebC1YSHja
x-libjamv: IMPIRE54ZRQ=
X-CMAE-Envelope: MS4xfKQeFdU7BSumWpmVQBKsGr4VpPRiCP/7k7PB9FLsRuqIaDY7Ona0hmUU6N/B5DIVWQvMQD8StjtZFr4F9LfVtSx2JHIkXb4XhnQE1/ixDLmB9cPB2aNH
 AjFs+/CkfS9ycR41Jq47Hao3dAG4VGpMfmC0SjmnozacTl23KKcZErms0ztaK/6ddui3KIoDOXy+K+SjyqVLMiCgPPtpITMqepbuOw599+VQ9pJFnU6GBel7
 MgFOf7pbgHUfiuTL4z/QpKYlJ/Zzrf1nDFfzBCRMEhvRVs1sXsjQHpevXITwSWtkwZAiVGON/1HIHa16rDRB7C0i575W86ivbCiI5x/A7e6xbKGBE8Lb2HLJ
 pFQxNe6/7QpT9aJJZJKISLy7tQQAx29RHjgZe+gFVo+59YRc4OstqEQHGVrRzPi966awYxNu29OQjQLeobMbQLsLyuohOqK81peK2219k4NS9mQ4YUit0ePN
 2DD/i+JPOCJAab6MUDkXMmdAHCy0jt+CfUm5jkiSYMqWy7sNJmMdHwKs795cyLaIZAUQhDc+gDpbiwSlRTl345kkgcYWXcycUxNSNQkb8VgdY8m84WsH7m/u
 9ePeV1wr0m0DY8XacuidtJynv7Ptiz2p2hGEUDf1mfVnJw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 01/03/2021 20:45 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 01.03.2021 18:21:42, Dario Binacchi wrote:
> > > > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> > > >  	while ((idx = ffs(pend))) {
> > > >  		idx--;
> > > >  		pend &= ~(1 << idx);
> > > > -		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > > > +		obj = idx + priv->msg_obj_tx_first;
> > > >  		c_can_inval_tx_object(dev, IF_TX, obj);
> > > >  		can_get_echo_skb(dev, idx, NULL);
> > > >  		bytes += priv->dlc[idx];
> > > > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> > > >  	/* Clear the bits in the tx_active mask */
> > > >  	atomic_sub(clr, &priv->tx_active);
> > > >  
> > > > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > > > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
> > > 
> > > Do we need 1UL here, too?
> > 
> > Do you agree if I use the BIT macro ?
> 
> No, please use GENMASK(priv->msg_obj_tx_num, 0) here.
> 

In case of 64 message objects, msg_obj_tx_num = 32, and 1 << (priv->msg_obj_tx_num - 1) = 0x80000000. 
GENMASK(priv->msg_obj_tx_num, 0) = 0. 
BIT(priv->msg_obj_tx_num - 1) = 0x80000000.

Thanks and regards,
Dario

> regrads,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
