Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046794CD441
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbiCDM0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:26:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41992 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiCDM0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:26:42 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6057C841902D;
        Fri,  4 Mar 2022 04:25:52 -0800 (PST)
Date:   Fri, 04 Mar 2022 12:25:47 +0000 (GMT)
Message-Id: <20220304.122547.1342402483120688005.davem@davemloft.net>
To:     dongli.zhang@oracle.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 0/4] tun/tap: use kfree_skb_reason() to
 trace dropped skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220304063307.1388-1-dongli.zhang@oracle.com>
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 04 Mar 2022 04:25:56 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>
Date: Thu,  3 Mar 2022 22:33:03 -0800

> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
> introduced the kfree_skb_reason() to help track the reason.
> 
> The tun and tap are commonly used as virtio-net/vhost-net backend. This is to
> use kfree_skb_reason() to trace the dropped skb for those two drivers. 

This patch series does not apply cleanly against net-next, plewase respin.

Thank you.
