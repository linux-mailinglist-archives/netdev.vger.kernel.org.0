Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60F7328802
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 18:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbhCARb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 12:31:56 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:42467 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238361AbhCARZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 12:25:31 -0500
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-17.iol.local with ESMTPA
        id GmHXls9QElChfGmHXl1BAu; Mon, 01 Mar 2021 18:24:31 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614619471; bh=bG1rlOxsdCDfq+llbqJGLJDe2PcVuPpWg8L2GLXFwMM=;
        h=From;
        b=fRnCcuNuO7jQmQ7SVQafADhz1tAnZ1wEPxE6BItB/6g9l80VhZWCNPrMjS3eSUNts
         hOb7kajuUnd20XCC6zgetNIL4QPwcfStEjb6DfnXJ+cm/fxzPUV+YrxwenMdYa6Nxn
         aLDM4/SPC4BPpWlL23wQ+Lof69ckqEGXpxzf0iIxCG3bBcpUhPGbSBNXgYpAVVTezg
         M+neEHnrCW0pP59u2+43O6qY4C5312oC8oQeuY7WOM7GsJVGdARJJDa4/TxM7fWlRf
         e1TGSzyBP5SUqk/qAKs3Ji0Uliwnfcftpp5fR9cywq4oTQ1/oR4yuFGyL/ozL9Be9R
         eHtt+2+/SHt7Q==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603d234f cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=UPWQtH3J-JgA:10 a=IkcTkHD0fZMA:10
 a=_gZzKa99_6AA:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Mon, 1 Mar 2021 18:24:31 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <198393892.577352.1614619471062@mail1.libero.it>
In-Reply-To: <20210301130845.3s45ujmhkazscm6x@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210301113805.jylhc373sip7zmed@pengutronix.de>
 <20210301130845.3s45ujmhkazscm6x@pengutronix.de>
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
x-libjamsun: Su6GbuglkQm7DL0+yrReHMwEkhjVUa8k
x-libjamv: oGyG3dN93IQ=
X-CMAE-Envelope: MS4xfLxOOFKC4Y9fSYBSqzo4qq615MhwxnKZ8YvoMT7gDPE9jDW7BwHzkmfF3fAoNILXn4Ek2mx3x1NRuflten3u32PeeDNiw+l8rH23rsP4HwKnSDtENmRi
 o0CNHRTKh9/BUpF8hmIL8OoHywRRyoyI6KFyAuPywyK/09gJNQngT41eRVepN3p+Ezmc6CJShycfU8gKJGIVuw0QJIdSZiU4xld9NKtVCnSm876AaXa5Os4v
 sY8NDwIktH8V//EpkOEUFvbvmwtQIkzSt2i320Y9B2c3wVcxVZPCXmBKvdbfAFsmELVB5ocGp5xeJI4JjNEoWv33vUMxoFVU4W1hLIFjp5Hs1Z6Oh9UjbI86
 tom1/NqXYUbLk6KirbcP2Hx5IhBgFpeXI0JioDRR2IEpyK+YfNF/SMUdLep9Rtw7zOfVe1jTeMmokXMQBhvhBKB96hwT6F2lAIc4GiftW9LkppRPowLzAekr
 rjy7qpVSirGFTVsk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 01/03/2021 14:08 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 01.03.2021 12:38:05, Marc Kleine-Budde wrote:
> > On 28.02.2021 11:38:54, Dario Binacchi wrote:
> > [...]
> > 
> > > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> > >  	while ((idx = ffs(pend))) {
> > >  		idx--;
> > >  		pend &= ~(1 << idx);
> > > -		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > > +		obj = idx + priv->msg_obj_tx_first;
> > >  		c_can_inval_tx_object(dev, IF_TX, obj);
> > >  		can_get_echo_skb(dev, idx, NULL);
> > >  		bytes += priv->dlc[idx];
> > > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> > >  	/* Clear the bits in the tx_active mask */
> > >  	atomic_sub(clr, &priv->tx_active);
> > >  
> > > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
> > 
> > Do we need 1UL here, too?
> 
> There are several more "1 <<" in the driver. As the right side of the
> sift operation can be up to 32, I think you should replace all "1 <<"
> with "1UL <<".

Do you agree if I use the BIT macro for all these shift operations?

Thanks and regards
Dario

> 
> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
