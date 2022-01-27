Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2A49D757
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiA0BOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:14:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:38806 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229699AbiA0BOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:14:00 -0500
X-UUID: eec619ee5bfd4d79896e11bd988cf653-20220127
X-UUID: eec619ee5bfd4d79896e11bd988cf653-20220127
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1852101207; Thu, 27 Jan 2022 09:13:57 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 09:13:56 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 09:13:55 +0800
Message-ID: <5ebfab5e96d957d671a055a342dc56e47c7c4d8a.camel@mediatek.com>
Subject: Re: [PATCH net-next v1 2/9] net: ethernet: mtk-star-emac: modify
 IRQ trigger flags
From:   Biao Huang <biao.huang@mediatek.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
CC:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felix Fietkau" <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Date:   Thu, 27 Jan 2022 09:13:55 +0800
In-Reply-To: <CAMRc=McZTped08HwbM+pr-xtsDyddTLjpsCc_f7ucoDM2DNXaw@mail.gmail.com>
References: <20220120070226.1492-1-biao.huang@mediatek.com>
         <20220120070226.1492-3-biao.huang@mediatek.com>
         <CAMRc=McZTped08HwbM+pr-xtsDyddTLjpsCc_f7ucoDM2DNXaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Bartosz,
	Thanks for your comments!

On Tue, 2022-01-25 at 11:22 +0100, Bartosz Golaszewski wrote:
> On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com>
> wrote:
> > 
> > If the flags in request_irq() is IRQF_TRIGGER_NONE, the trigger
> > method
> > is determined by "interrupt" property in dts.
> > So, modify the flag from IRQF_TRIGGER_FALLING to IRQF_TRIGGER_NONE.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > index 26f5020f2e9c..7c2af775d601 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > @@ -959,7 +959,7 @@ static int mtk_star_enable(struct net_device
> > *ndev)
> > 
> >         /* Request the interrupt */
> >         ret = request_irq(ndev->irq, mtk_star_handle_irq,
> > -                         IRQF_TRIGGER_FALLING, ndev->name, ndev);
> > +                         IRQF_TRIGGER_NONE, ndev->name, ndev);
> >         if (ret)
> >                 goto err_free_skbs;
> > 
> > --
> > 2.25.1
> > 
> 
> Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
I'll add reviewd-by in next send.

