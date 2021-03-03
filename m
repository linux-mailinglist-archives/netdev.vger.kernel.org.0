Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45F32C414
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354770AbhCDAK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:56 -0500
Received: from smtp-33-i2.italiaonline.it ([213.209.12.33]:47399 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240681AbhCCKbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:31:53 -0500
Received: from oxapps-11-061.iol.local ([10.101.8.71])
        by smtp-33.iol.local with ESMTPA
        id HOmcl0ssMR8VAHOmclqOk0; Wed, 03 Mar 2021 11:31:10 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614767471; bh=iWeKOBQjPDMP70PIy6g/lv11yegMli1iUbTvPIab9Hw=;
        h=From;
        b=Sc7Dy2wN0gP1XRVMgTMpMxmI1D3l5ClDP3toihoaqHPAuKMnmh496S9X8HYkW8lPC
         3pVaJ6bUFXHKfLbox8LgOm7/9m3N7Nr4o6fiTnOG8XVGtIvHAlvVCJ9g/nBn7I6Aea
         ZSaovdx1MChmi1TtZ3w7XE11luWaWuL8Txskv28NSC6yKHyuBypzJAX9PF2/STLe8G
         hZgW8MEP1KG4GC+a5sICYeOPkBsgKvmlJ89cX/L+33rRtHgO0zpiaXr1xF7HhZq6nx
         WG4H825ttXbFc+K0FEDw9apRECHaXvYw7lu0DKinCqnXythIAj2SNRwI/i3ACxUSIT
         ingFK3U8FV5EQ==
X-CNFS-Analysis: v=2.4 cv=OapdsjfY c=1 sm=1 tr=0 ts=603f656f cx=a_exe
 a=EdAe90YrY4QbXR8+o2XJeA==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=P-IC7800AAAA:8 a=bGNZPXyTAAAA:8 a=lneh_w3DiUngg6D-LXoA:9
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=yL4RfsBhuEsimFDS2qtJ:22
 a=BPzZvq435JnGatEyYwdK:22
Date:   Wed, 3 Mar 2021 11:31:10 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-kernel@vger.kernel.org,
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
Message-ID: <1871630605.34606.1614767470294@mail1.libero.it>
In-Reply-To: <20210303090036.aocqk6gp3vqnzaku@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210302184901.GD26930@x1.vandijck-laurijssen.be>
 <91394876.26757.1614759793793@mail1.libero.it>
 <20210303090036.aocqk6gp3vqnzaku@pengutronix.de>
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
x-libjamsun: e/8xLbhvGv4RhpAuB15ddAfaBZ6f60R7
x-libjamv: H528txnWAb8=
X-CMAE-Envelope: MS4xfLp0UZWodVO6sdmB8YeH3dE4jHsE98HGVnRNZs/1QONJC62Zhmsfok8ovMiiQfnz5IfFhwVkyLDNajUMbWKCKr/2yGMm2tylZMMzbNGQnx5ZnLLgxPH8
 oH3lLxRdyOxpT0f44rzgqaDq1PXpP9JjJcl/DmCiombR+3kfDGzsPK4SiCo/6yKRHY/WjuT9dShZZ9xvZtwXHjFPW9rqj1X7El7ZEhuUpU2oAq4TZ2c/tt5k
 iIzsU8plzv59qefSv7NykZF5OqAYunEEDQwumMIIBbezNw2S4L4WDFA4NKHWkUfv9YJXyYlIthyRJa36U89csRhFnRtLMnCY47afkTEx/x6OJoP/9DLtB04K
 yCTBgfetHXI8JKCbJEpy3dl7aioFyuCsKgQnlQmoAZTkhM1WvA19b+qjKTuF5NqR/PWHhG2C3zOY4O4Vq8zmjNoBqZUb88WK3roxmivQryM9V1DlTSN1RE/U
 nr1JatGzu7SIiIzyy8nXB9dTsaVxYd5q4qHlsQZ3tJ5i7wl1xrgYfjTUpjdyRErcQ8ld18c8KJYW8gW95zXso7bQ23zFoI5VbMpaeSadDXYNc8wj4An5Zlek
 r425X09xKMur4csD1xdjAxpoo/xqoFDBT62JAVoR0oxZVXGWysNpi65UsY6BpZNVetKbuRkR3pgkafKN+1OsFjAw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 03/03/2021 10:00 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 03.03.2021 09:23:13, Dario Binacchi wrote:
> [...]
> > > > @@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -struct net_device *alloc_c_can_dev(void)
> > > > +struct net_device *alloc_c_can_dev(int msg_obj_num)
> > > >  {
> > > >  	struct net_device *dev;
> > > >  	struct c_can_priv *priv;
> > > > +	int msg_obj_tx_num = msg_obj_num / 2;
> > > 
> > > IMO, a bigger tx queue is not usefull.
> > > A bigger rx queue however is.
> > 
> > This would not be good for my application. I think it really depends
> > on the type of application. We can probably say that being able to
> > size rx/tx queue would be a useful feature.
> 
> Ok. There is an ethtool interface to configure the size of the RX and TX
> queues. In ethtool it's called the RX/TX "ring" size and you can get it
> via the -g parameter, e.g. here for by Ethernet interface:
> 
> | $ ethtool -g enp0s25
> | Ring parameters for enp0s25:
> | Pre-set maximums:
> | RX:		4096
> | RX Mini:	n/a
> | RX Jumbo:	n/a
> | TX:		4096
> | Current hardware settings:
> | RX:		256
> | RX Mini:	n/a
> | RX Jumbo:	n/a
> | TX:		256
> 
> If I understand correctly patch 6 has some assumptions that RX and TX
> are max 32. To support up to 64 RX objects, you have to convert:
> - u32 -> u64
> - BIT() -> BIT_ULL()
> - GENMASK() -> GENMASK_ULL()
> 
> The register access has to be converted, too. For performance reasons
> you want to do as least as possible. Which is probably the most
> complicated.
> 
> In the flexcan driver I have a similar problem. The driver keeps masks,
> which mailboxes are RX and which TX and I added wrapper functions to
> minimize IO access:
> 
> https://elixir.bootlin.com/linux/v5.11/source/drivers/net/can/flexcan.c#L904
> 
> This should to IMHO into patch 6.
> 
> Adding the ethtool support and making the rings configurable would be a
> separate patch.
> 

I think these features need to be developed in a later series. 
I would stay with the extension to 64 messages equally divided 
between reception and transmission.

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
