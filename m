Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8783934D4B8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhC2QTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:19:11 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34823 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhC2QTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:19:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2FCE95C00F0;
        Mon, 29 Mar 2021 12:19:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 12:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=40nnT6
        E0o6622nzQa84DwVhgtn/DO68G9ykdgP/hcHw=; b=aafUBCi2FpUgULssYxHYvC
        lR7G52amZTDYrvxE0SNObz1GGKwzF0I6f7kTVfUPcn7dtFFsB+6Jpp/XoZM99Tum
        9oCSdjOuLmjIZ+UtKSw4UOzwr7eYOzx3s4eYjllYdqhiKX17CVG/ZcEan4B6etr8
        JPuWk0gJ0pegB1oS0PI5TAgALedBR/xqheSSrVjalrTWSG7BMCkLzbq4Z0C81TPd
        Ck1fChkFFPMhJGIlnW0IzW8+D/fhuc/+v9x5mUMDan4PfXo3s5xwT9pS8gTIylqV
        pjvoKBB6m+xkbRdhREZ8yDnWXP17I7JTy8yZZNN6iYxjOUx49UZy/Qx7Z9QUBihA
        ==
X-ME-Sender: <xms:9_1hYHU44adkoQ_NWF_KFVmPmBMafDQaTflT0BPNexmOITXmsoj91A>
    <xme:9_1hYKQAIHh25jfgKAOLR6ZZ2o4mlh6fdcYPwaVTkHQrTEYPbBhEIfrihDcxiUTkg
    y9sdZzIRKCb2d4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9_1hYKBQI8LyTmdwmNclRIwBBXlO9T-K9UhHmwozAvZJne7lJ9JM1w>
    <xmx:9_1hYNSvIRQZZpN-_a2h9oSwpEpijUgJOdSP5qJHjbdaOdZ-85jt7A>
    <xmx:9_1hYMR0XxBXQicraBd2pED1SDb86BDdhbi7Du8YaVxzB8LEB7XP6A>
    <xmx:-P1hYFdThxrGhGpdv14voYAqiVZcrYzTx_xdUrRb6CykDNe3wtKA0g>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60DD61080067;
        Mon, 29 Mar 2021 12:19:03 -0400 (EDT)
Date:   Mon, 29 Mar 2021 19:19:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] Documentation: net: Document resilient next-hop
 groups
Message-ID: <YGH99D/Cad3H7pv0@shredder.lan>
References: <1a164ec0cc63a0d9f5dd9a1df891b6302c8c2326.1617033033.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a164ec0cc63a0d9f5dd9a1df891b6302c8c2326.1617033033.git.petrm@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 05:57:31PM +0200, Petr Machata wrote:
> Add a document describing the principles behind resilient next-hop groups,
> and some notes about how to configure and offload them.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
