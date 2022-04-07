Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246DB4F7C0C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 11:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiDGJrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 05:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbiDGJrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 05:47:10 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8D6A56C8;
        Thu,  7 Apr 2022 02:45:05 -0700 (PDT)
X-UUID: 61c9946def454a469c0e0d14e0bb14ef-20220407
X-UUID: 61c9946def454a469c0e0d14e0bb14ef-20220407
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1950370865; Thu, 07 Apr 2022 17:45:00 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 7 Apr 2022 17:44:59 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Apr 2022 17:44:58 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH v3] net: fix wrong network header length
Date:   Thu, 7 Apr 2022 17:38:43 +0800
Message-ID: <20220407093843.10538-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAADnVQJEXOOH6--uA7BvFUPmXY42zeOQVweHmaMqkbj_g5TLqA@mail.gmail.com>
References: <CAADnVQJEXOOH6--uA7BvFUPmXY42zeOQVweHmaMqkbj_g5TLqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 12:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Thu, 2022-02-17 at 15:01 +0800, Lina Wang wrote:

> So that bpf helper has to be somehow involved, but iperf udp test
> says nothing about it.
> Please craft a _complete_ selftest.

Finally, I have wrote selftest, please check 
https://lore.kernel.org/bpf/20220407084727.10241-1-lina.wang@mediatek.com/
https://lore.kernel.org/bpf/20220407084727.10241-2-lina.wang@mediatek.com/
https://lore.kernel.org/bpf/20220407084727.10241-3-lina.wang@mediatek.com/ 

Thanks
