Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EFB3CA0C5
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhGOOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:38:16 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57648 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229624AbhGOOiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:38:15 -0400
X-UUID: 8149c731000b4e7ca39b0bdf136ff0ca-20210715
X-UUID: 8149c731000b4e7ca39b0bdf136ff0ca-20210715
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 367406245; Thu, 15 Jul 2021 22:35:19 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 15 Jul 2021 22:35:18 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 15 Jul 2021 22:35:17 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH v2] net: ipv6: remove unused local variable
Date:   Thu, 15 Jul 2021 22:19:37 +0800
Message-ID: <20210715141937.5356-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20986885-73a5-8e58-0eb9-54b0723467e4@gmail.com>
References: <20986885-73a5-8e58-0eb9-54b0723467e4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-15 at 08:16 -0600, David Ahern wrote:
> On 7/14/21 10:20 PM, Rocco Yue wrote:
>> The local variable "struct net *net" in the two functions of
>> inet6_rtm_getaddr() and inet6_dump_addr() are actually useless,
>> so remove them.
>> 
>> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
>> ---
>>  net/ipv6/addrconf.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>> 
> 
> a v2 with no changelog. From what I can tell the only difference is
> "net: " in the Subject line which is not what I said in the last email.
> 
> Let me try again: There are 2 trees - net for bug fixes and net-next for
> development (anything that is not a bug fix). Each patch should specify
> which tree the patch is for by putting 'net' or 'net-next' in the
> brackets ([]). This is a cleanup not a bug fix, so this patch should be:
> 
> [PATCH net-next] ipv6: remove unused local variable
> 
> and really that should be
> 
> [PATCH net-next] ipv6: remove unnecessary local variable
> 
> If you send more versions of a patch always put a changelog - a summary
> of what is different in the current patch versus the previous ones.
> 
> No need to send another version of this patch unless you get a comment
> requesting change, or the maintainers ask for a re-send.
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Hi David,

Thanks for your detailed explanation,
I am appreciated that you shared these valureable advices for me.
They are important for my furture upstream work.
I will re-send it :)

Sincerely,
Rocco

