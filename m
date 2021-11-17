Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB7454099
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhKQGHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:07:09 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54168 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232363AbhKQGHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:07:09 -0500
X-UUID: e078f548793348a1979d7570e5abb280-20211117
X-UUID: e078f548793348a1979d7570e5abb280-20211117
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 575398198; Wed, 17 Nov 2021 14:04:09 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 17 Nov 2021 14:04:08 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Nov 2021 14:04:07 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <Rocco.Yue@gmail.com>,
        <chao.song@mediatek.com>, <yanjie.jiang@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        <lorenzo@google.com>, <maze@google.com>, <markzzzsmith@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random or privacy mode
Date:   Wed, 17 Nov 2021 13:59:30 +0800
Message-ID: <20211117055930.6810-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
Reply-To: <20211116193456.54436652@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-17 at 11:34 +0800, Jakub Kicinski wrote:
> On Tue, 16 Nov 2021 13:21:12 -0700 David Ahern wrote:
>> Reviewed-by: David Ahern <dsahern@kernel.org>
>>
>> you should add tests under tools/testing/selftests/net.
>
> Please keep David's review tag and repost with a selftest.

Hi David and Jakub,

Thanks for your review. :-)

I heard about selftest for the first time, and I am thinking
about how to write a selftest for this patch, and I will
repost thses patches again when finished.

Thanks,

Rocco

