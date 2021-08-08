Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31783E3B00
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhHHPKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:10:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54839 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhHHPKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 11:10:40 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 450A85C0138;
        Sun,  8 Aug 2021 11:10:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 08 Aug 2021 11:10:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A3McFW
        /Tsb3OKh9FbJRLMsHA77wmBtDHnBMwu04wS+w=; b=BJl/M+dHJkzc75VMwsib6Z
        e18G3STF4xDt/qL349ZOuAMmdhdYziD9YmpVBmeVCj1q/pTfIHFas3Gx6DY9P/Ys
        9gEerLfodgs/SRo0ZyuLPO635l5k9kitFWo/ckrOPtH9wrkJANYT8RrvwVU/5byn
        6ucwk8Xb2ir0C07K3MqqMMeTnJ2hKYRS3xmyDiZSQQCJMEBLByRE5RgvrZZTMykG
        jsWnaiI8dSQyzFhN0icYPkjtdlUyyqEAQDpNN76WpJlj6gnXb8M3a5/kWoS8Yn7m
        wC1MOodVLUpH78uiCmhEznJbJpzDuMpQtvz+T7LQYVX9sWqX/Zwx9NEY9AkKCIeQ
        ==
X-ME-Sender: <xms:3PMPYWOH0vDVWBtqN6a5SIiuDkTld8hawa1HrW4NI1kIo91QFG1Q8w>
    <xme:3PMPYU-zgKDanZ4tzX_GZaxWRlzouxZKXmFYSSUHGfnc2aAM7ONpbFI6V2hm_TJ5r
    LMNCQq_dV0YzQA>
X-ME-Received: <xmr:3PMPYdSqGb6rrObUTocOmeHdR_PVxCTRWNp96sX3A6Z4yLKQj1sulj8mA7GdZxCNwqJJ0VdspKDLHdPpEQknLCgvZu-W9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeehgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3PMPYWugu5hhF3tGFPvjhtWVsiKBr1pGA5u7oDMdgT6itmQX9VuV3g>
    <xmx:3PMPYecz64JAhiaxrY4KeMzlevJIQF8kMn0qTz7P3YAKwxzRj_In_w>
    <xmx:3PMPYa0_obrkevXcGe_2M2PHf2x1Bvgfvj5JeQGN61CH0WWnhfqv9w>
    <xmx:3fMPYd5hGNRXDvPn7gRd8bOMxDs97FwDyMSN8YsN6BXc-1T0XqPb_g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Aug 2021 11:10:19 -0400 (EDT)
Date:   Sun, 8 Aug 2021 18:10:16 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, vladbu@nvidia.com,
        netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH RESEND net-next] net_sched: refactor TC action init API
Message-ID: <YQ/z2CV+Xh000uCZ@shredder>
References: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
 <YQ/wWkRmmKh5/bVA@shredder>
 <bf87ea8b-5650-6b4d-1968-0eec83b7185d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf87ea8b-5650-6b4d-1968-0eec83b7185d@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 06:00:51PM +0300, Mark Bloch wrote:
> We hit the same issue, I have the bellow patch and it solved the issue for us:

OK, looks good. Replaced my patch with yours. Will let you know tomorrow
if I still see the issue (unlikely).

Thanks
