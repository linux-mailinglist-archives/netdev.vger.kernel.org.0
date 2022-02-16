Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DBD4B884E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiBPM7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:59:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBPM7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:59:08 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C55C24CCF8;
        Wed, 16 Feb 2022 04:58:51 -0800 (PST)
X-UUID: 2d36106f0fa64d11946d669e4a8cd427-20220216
X-UUID: 2d36106f0fa64d11946d669e4a8cd427-20220216
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1698583263; Wed, 16 Feb 2022 20:58:48 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 16 Feb 2022 20:58:47 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Feb
 2022 20:58:41 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Feb 2022 20:58:40 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <maze@google.com>, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: fix wrong network header length
Date:   Wed, 16 Feb 2022 20:52:48 +0800
Message-ID: <20220216125248.24851-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
References: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-10 at 17:02 +0100, Paolo Abeni wrote:
> On Wed, 2022-02-09 at 18:25 +0800, lina.wang wrote:
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 75dfbde8d2e6..f15bbb7449ce 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3682,6 +3682,7 @@ struct sk_buff *skb_segment_list(struct
> > sk_buff *skb,
> >  	struct sk_buff *tail = NULL;
> >  	struct sk_buff *nskb, *tmp;
> >  	int err;
> > +	unsigned int len_diff = 0;
> 
> Mintor nit: please respect the reverse x-mas tree order.
> 

v3 has updated, please give some advice!

> >  
> Paolo
> 

Thanks!
