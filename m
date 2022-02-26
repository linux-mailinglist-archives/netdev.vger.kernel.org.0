Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA234C5490
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiBZIIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiBZIIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:08:01 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61963C2;
        Sat, 26 Feb 2022 00:07:22 -0800 (PST)
X-UUID: c8a4257f3d23460d8d237fed17394a60-20220226
X-UUID: c8a4257f3d23460d8d237fed17394a60-20220226
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 16057302; Sat, 26 Feb 2022 16:07:15 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 26 Feb 2022 16:07:14 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 26 Feb 2022 16:07:13 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lina Wang <lina.wang@mediatek.com>
Subject: Re: [PATCH v2] xfrm: fix tunnel model fragmentation behavior
Date:   Sat, 26 Feb 2022 16:00:51 +0800
Message-ID: <20220226080050.16818-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220224102309.GN1223722@gauss3.secunet.de>
References: <20220224102309.GN1223722@gauss3.secunet.de>
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

On Thu, 2022-02-24 at 11:23 +0100, Steffen Klassert wrote:
> On Thu, Feb 24, 2022 at 02:09:31PM +0800, Lina Wang wrote:
> > In tunnel mode, if outer interface(ipv4) is less, it is easily to
> Your patch does not apply, it is not in plain text format.
> 
Do u mean I used base64 encoding? I already updated v3 as 8bit.
>
> While at it, this is not an ESP speciffic function. Please rename to
> xfrm_noneed_fragment.
>
Yes, change it to xfrm6_noneed_fragment

Thanks!

