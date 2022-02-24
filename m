Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59C4C23FF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 07:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiBXGVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 01:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiBXGVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 01:21:43 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E634F268366;
        Wed, 23 Feb 2022 22:21:13 -0800 (PST)
X-UUID: dcd70dd49b674ab7bd012978e998bbc7-20220224
X-UUID: dcd70dd49b674ab7bd012978e998bbc7-20220224
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 906860201; Thu, 24 Feb 2022 14:21:11 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 24 Feb 2022 14:21:09 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:08 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Lina Wang" <lina.wang@mediatek.com>
Subject: Re: [PATCH] xfrm: fix tunnel model fragmentation behavior
Date:   Thu, 24 Feb 2022 14:15:07 +0800
Message-ID: <20220224061507.30495-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220223083155.GM17351@gauss3.secunet.de>
References: <20220223083155.GM17351@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-23 at 09:31 +0100, Steffen Klassert wrote:
> On Mon, Feb 21, 2022 at 01:16:48PM +0800, Lina Wang wrote:
>Can you please add a 'Fixes' tag?
>
Sure

+	fh = (struct frag_hdr *)(skb->data + sizeof(struct ipv6hdr));
> > +	if (fh->nexthdr == NEXTHDR_ESP)
> > +		return 1;
> 
> Shouldn't this problem exist for NEXTHDR_AUTH too?

Thanks for reminding! V2 has modified and submitted!

Thanks! 
