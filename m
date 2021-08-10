Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C13E5482
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhHJHmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:42:04 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52567 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236673AbhHJHmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:42:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 76FE55C00DE;
        Tue, 10 Aug 2021 03:41:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 10 Aug 2021 03:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ryfUFJ
        8xGMP5jeGmnWIsAmzwu4B1shpQA2kdVca51uI=; b=qDc1KvDMgVgovomGI6E7Bm
        AwP5QOnXXuFH7Z1WjrZNb76zl0Iwu9HldPF4rxyHwL2tVjQAaZBcvMzw+0RQSPJ6
        y540o01VcHH7qKCwExt52IFoneLWEb0C5ttPhz8qc6WlIqAlfA/ULBMLQiPu2Gkt
        vpzYeCot5pyVBVUgR3aatjfx0taai58iieHJ9+yKxI48VWXlpNNBWmoY1f4hmSm1
        oovS8jd4zJI/PLo7hJ7IBLK4GCWTGwiSwWN2tK3Yfl/aonfwIRYalbArpKu++y90
        JfV4VB70/o35w9PuGyQOqxqwqjP9rK5y6u8M4954wOovlLDFlVZQalY4gmDEWhEg
        ==
X-ME-Sender: <xms:sy0SYTlduxDjuXRpiUd98hiqL_qIg3BRGpq95b85ntAaCOfhJ5_nIw>
    <xme:sy0SYW0DChxEUkAWHRo12gIL_ga5b8dLNpVEHDrpQRJ-9BmNjoC15sImfvg7aguZA
    B_p_K1xut-K_OM>
X-ME-Received: <xmr:sy0SYZq7M5Xm6AgtRySJ8Kb6Ienh924YHv26lENXJ4xHX3EiRfexIrEsafkhMshRN004PO8b_IXIxW8VlTmXdu4FGaLKgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeekgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sy0SYbmobsScdCgbDMFPO2be245vWIsR4-GU6I3uAY1-MWQpQdn3pQ>
    <xmx:sy0SYR3Rg0MtoPuirRW9rW-4dZv8-cN0Uk0icTzRp7oMADCWxm_BsQ>
    <xmx:sy0SYauzopqaIxxT0WNsvX7mMlf5S3A7FG-TWxNhJ3JXVnHqfOu2GQ>
    <xmx:tC0SYcR3Bimjo2aS9CYTixtemo9MKN4PT6vE1TEFbs7SIGeBX1qBzA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 03:41:38 -0400 (EDT)
Date:   Tue, 10 Aug 2021 10:41:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        vladbu@nvidia.com, cong.wang@bytedance.com, jhs@mojatatu.com,
        jiri@resnulli.us
Subject: Re: [net-next PATCH v2] net/sched: cls_api, reset flags on replay
Message-ID: <YRItrkt3capthkUE@shredder>
References: <20210810034305.63997-1-mbloch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810034305.63997-1-mbloch@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 03:43:05AM +0000, Mark Bloch wrote:
> tc_new_tfilter() can replay a request if it got EAGAIN. The cited commit
> didn't account for this when it converted TC action ->init() API
> to use flags instead of parameters. This can lead to passing stale flags
> down the call chain which results in trying to lock rtnl when it's
> already locked, deadlocking the entire system.
> 
> Fix by making sure to reset flags on each replay.

[...]

> Fixes: 695176bfe5de ("net_sched: refactor TC action init API")
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
