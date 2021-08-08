Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F83E3AEF
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhHHOzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:55:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45973 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhHHOzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 10:55:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3AB145C00DE;
        Sun,  8 Aug 2021 10:55:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 08 Aug 2021 10:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qg4AKo
        K3MbqS/QBQ3Yz9jWg17RtvwK79hMMQw9QscLg=; b=FQIfl6GBHZZd/0JPnYacd8
        pD8dr8KtdtaB3iTKEaEjYkOkmMJTLEXhRJgyOoKZMMmmxDV6ciGesQnOAl56rbqi
        FW71+3Rg3lTVHRT4dudgKSqA8q0LEuZMOAgO7UtiCvDWwMw0Pf4/APxgImwS7UWX
        KhwxrPFjCudyeR1//R6g9XuKYu5UqNX8EpVhl1gaRNBGGSr9u6QU39dnrQOfxqa7
        LWOzFh9eXZ5TH5+fzx8WWbOaDp4kH1H6yF4xYI9BjZn0B56LRNiIz3J+/ZcChADc
        6P7hHoBLe8qxygJWu0Cd/BLgWEQR9DAN7v/36vVogpzg+aS+vP4dsuM84GOkZMUA
        ==
X-ME-Sender: <xms:X_APYW2sDl78EGYR8ymMblhMhpSf0nVEWjntl66A0jRhVL2j0tWWcw>
    <xme:X_APYZF0m_2DpgXhijSZzRnZWKoYTWYOTEUQA0DBGDIUDxGL-faxKm9zslfi12Tzs
    JqoxvQmc240t-Y>
X-ME-Received: <xmr:X_APYe4_99BTFO6biOxfJpWjIFRG7JG19guGa3lEdjVfSLrZmPXKn73-s-w3EQWEMSrRa8HBZr3BFc89towHBnZmeG90gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeehgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:X_APYX14AbW-4NMm0PF44ZYtK4X-eGNyhuxZE3iUmqHDgkoRP6JlbA>
    <xmx:X_APYZFfYBnyjv2biAO9bkrWrWzgrn-IAQhcuEV8YAIQLWDAli93_w>
    <xmx:X_APYQ-Td7zSuyJLchSIcF4U4J0lMTETICLNdBcJ86BRC5wErt2vwg>
    <xmx:YPAPYZCrkwc9O5JDXF3748NfjX8y15lSGHNJVVybW7C1L3ficsdBoA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Aug 2021 10:55:26 -0400 (EDT)
Date:   Sun, 8 Aug 2021 17:55:22 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH RESEND net-next] net_sched: refactor TC action init API
Message-ID: <YQ/wWkRmmKh5/bVA@shredder>
References: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 04:12:14PM -0700, Cong Wang wrote:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 7be5b9d2aead..69185e311422 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1949,6 +1949,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	int err;
>  	int tp_created;
>  	bool rtnl_held = false;
> +	u32 flags = 0;
>  
>  	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
>  		return -EPERM;
> @@ -2112,9 +2113,12 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  		goto errout;
>  	}
>  
> +	if (!(n->nlmsg_flags & NLM_F_CREATE))
> +		flags |= TCA_ACT_FLAGS_REPLACE;
> +	if (!rtnl_held)
> +		flags |= TCA_ACT_FLAGS_NO_RTNL;

Cong, Vlad,

I'm getting deadlocks [1] after rebasing on net-next and I believe this
is the problematic part.

It is possible that during the first iteration RTNL mutex is not taken
and 'TCA_ACT_FLAGS_NO_RTNL' is set. However, in the second iteration
(after jumping to the 'replay' label) 'rtnl_held' is true, the mutex is
taken, but the flag is not cleared.

Will submit the following patch after I finish testing it unless you
have a better idea.

Thanks

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 69185e311422..af9ac2f4a84b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2117,6 +2117,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
                flags |= TCA_ACT_FLAGS_REPLACE;
        if (!rtnl_held)
                flags |= TCA_ACT_FLAGS_NO_RTNL;
+       else
+               flags &= ~TCA_ACT_FLAGS_NO_RTNL;
        err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
                              flags, extack);
        if (err == 0) {

[1]
============================================
WARNING: possible recursive locking detected
5.14.0-rc3-custom-49011-g3d2bbb4f104d #447 Not tainted
--------------------------------------------
tc/37605 is trying to acquire lock:
ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_setup_cb_add+0x14b/0x4d0

but task is already holding lock:
ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0

other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(rtnl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***
 May be due to missing lock nesting notation
1 lock held by tc/37605:
 #0: ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0

stack backtrace:
CPU: 0 PID: 37605 Comm: tc Not tainted 5.14.0-rc3-custom-49011-g3d2bbb4f104d #447
Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
Call Trace:
 dump_stack_lvl+0x8b/0xb3
 __lock_acquire.cold+0x175/0x3cb
 lock_acquire+0x1a4/0x4f0
 __mutex_lock+0x136/0x10d0
 fl_hw_replace_filter+0x458/0x630 [cls_flower]
 fl_change+0x25f2/0x4a64 [cls_flower]
 tc_new_tfilter+0xa65/0x22e0
 rtnetlink_rcv_msg+0x86c/0xc60
 netlink_rcv_skb+0x14d/0x430
 netlink_unicast+0x539/0x7e0
 netlink_sendmsg+0x84d/0xd80
 ____sys_sendmsg+0x7ff/0x970
 ___sys_sendmsg+0xf8/0x170
 __sys_sendmsg+0xea/0x1b0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7b93b6c0a7
Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48>
RSP: 002b:00007ffe365b3818 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b93b6c0a7
RDX: 0000000000000000 RSI: 00007ffe365b3880 RDI: 0000000000000003
RBP: 00000000610a75f6 R08: 0000000000000001 R09: 0000000000000000
R10: fffffffffffff3a9 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007ffe365b7b58 R15: 00000000004822c0
