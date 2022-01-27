Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBCA49D754
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiA0BNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:13:21 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:53416 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229699AbiA0BNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:13:20 -0500
X-UUID: 10bf234b2fd24b158e55d7fb15b378c1-20220127
X-UUID: 10bf234b2fd24b158e55d7fb15b378c1-20220127
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 4121814; Thu, 27 Jan 2022 09:13:15 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 09:13:14 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 09:13:13 +0800
Message-ID: <07089392136a4a0790dd1fe73443db7e47700077.camel@mediatek.com>
Subject: Re: [PATCH net-next v1 4/9] dt-bindings: net: mtk-star-emac: add
 support for MT8365
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
Date:   Thu, 27 Jan 2022 09:13:13 +0800
In-Reply-To: <CAMRc=MdVKdXcK0gdBSpaaSm5fx1o5Sy_0-JJBPK0=Xp7UmQnqQ@mail.gmail.com>
References: <20220120070226.1492-1-biao.huang@mediatek.com>
         <20220120070226.1492-5-biao.huang@mediatek.com>
         <CAMRc=MdVKdXcK0gdBSpaaSm5fx1o5Sy_0-JJBPK0=Xp7UmQnqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Bartosz,
	Thanks for your comments~

On Tue, 2022-01-25 at 11:23 +0100, Bartosz Golaszewski wrote:
> On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com>
> wrote:
> > 
> > Add binding document for Ethernet on MT8365.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >  Documentation/devicetree/bindings/net/mediatek,star-emac.yaml | 1
> > +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mediatek,star-
> > emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-
> > emac.yaml
> > index e6a5ff208253..87a8b25b03a6 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> > +++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> > @@ -23,6 +23,7 @@ properties:
> >        - mediatek,mt8516-eth
> >        - mediatek,mt8518-eth
> >        - mediatek,mt8175-eth
> > +      - mediatek,mt8365-eth
> > 
> >    reg:
> >      maxItems: 1
> > --
> > 2.25.1
> > 
> 
> Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
I'll add revieed-by in next send.

