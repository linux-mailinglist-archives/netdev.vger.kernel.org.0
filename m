Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55533A37B
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 09:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhCNISF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 04:18:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33219 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229539AbhCNIRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 04:17:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 05FA45C00C5;
        Sun, 14 Mar 2021 04:17:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 04:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3hGme+
        evcoN+7Yi8WSWjsZtATUgfpsevUakuxIXjriU=; b=ID9xlZDlGs3/gLNvKBa0c0
        /pQk0B9N7Im1zoW9UK15ITJJsM9ChbBLc+mT3kqj705ezkbfmagYAgdHyXgChcmF
        fH+CmTyGXHEnEdatM/DdiyEybVQI9wh9QqL0cRC4u4gtapAHPQsi6XS3zsAH/92g
        ix+cgTvWGkpn8GQxs7MvtR5fJPel6tpiAVR8oB/38yBJ9kkdY5/fQViQXTF97fcJ
        T1wEsiqy/liWZzubYKCnH7XjW8igLdVtV/KKombFa/ztpurmvHKdOsMW1KU+rFCk
        qtZVna75pXxM5+eAAkIkNJxvo9Wql1alHd6HDdoxClhFefvq9VmltqGN/5sDWGNQ
        ==
X-ME-Sender: <xms:psZNYIVRLfzs0-HpEdsYS9Q4nxUnRRhqS98C56XzP-tqnENhqVN8Lw>
    <xme:psZNYMlPG9v7hViUkdRNWqBaa8wKzQw4nxBg0BNhOLdipNDumB0rG3FHqlobKZT05
    AZ04x39dFfUhto>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvhedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:psZNYMbm-6bkvp-78CxHLOV6zou_MEsXlmy--vBOGR4Ijdn-PFVaQA>
    <xmx:psZNYHWSAiLWmovmU5_cY4qf_aKLs7zbYlH0B5SFK1sWN4TCiraSlw>
    <xmx:psZNYCk-zYBPMMQtTxXqahYQMUylCQGT9RLXg_tf0acaADzk3aQEOw>
    <xmx:p8ZNYDB7CkVpoCjnMfM4pRD4PvgQWYxrcUu2fk5eAQq1x0ejMlUvEg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9728924005B;
        Sun, 14 Mar 2021 04:17:41 -0400 (EDT)
Date:   Sun, 14 Mar 2021 10:17:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <YE3GofZN1jAeOyFV@shredder.lan>
References: <20210312140831.23346-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
> This series enhances the TC policer action implementation to allow a
> policer action instance to enforce a rate-limit based on
> packets-per-second, configurable using a packet-per-second rate and burst
> parameters.
> 
> In the hope of aiding review this is broken up into three patches.
> 
> * [PATCH 1/3] flow_offload: add support for packet-per-second policing
> 
>   Add support for this feature to the flow_offload API that is used to allow
>   programming flows, including TC rules and their actions, into hardware.
> 
> * [PATCH 2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers
> 
>   Teach all exiting users of the flow_offload API that allow offload of
>   policer action instances to reject offload if packet-per-second rate
>   limiting is configured: none support it at this time
> 
> * [PATCH 3/3] net/sched: act_police: add support for packet-per-second policing
> 
>   With the above ground-work in place add the new feature to the TC policer
>   action itself
> 
> With the above in place the feature may be used.
> 
> As follow-ups we plan to provide:
> * Corresponding updates to iproute2
> * Corresponding self tests (which depend on the iproute2 changes)

I was about to ask :)

FYI, there is this selftest:
tools/testing/selftests/net/forwarding/tc_police.sh

Which can be extended to also test packet rate policing

> * Hardware offload support for the NFP driver
> 
> Key changes since v2:
> * Added patches 1 and 2, which makes adding patch 3 safe for existing
>   hardware offload of the policer action
> * Re-worked patch 3 so that a TC policer action instance may be configured
>   for packet-per-second or byte-per-second rate limiting, but not both.
> * Corrected kdoc usage

Thanks!
