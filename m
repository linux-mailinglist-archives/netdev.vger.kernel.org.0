Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115FE1138DD
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfLEAdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:33:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfLEAdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:33:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C69314F1AC3B;
        Wed,  4 Dec 2019 16:33:49 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:33:48 -0800 (PST)
Message-Id: <20191204.163348.259023660348933654.davem@davemloft.net>
To:     aconole@redhat.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, mleitner@redhat.com,
        paulb@mellanox.com, roid@mellanox.com, nicolas.dichtel@6wind.com
Subject: Re: [PATCH 2/2] act_ct: support asymmetric conntrack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203213414.24109-2-aconole@redhat.com>
References: <20191203213414.24109-1-aconole@redhat.com>
        <20191203213414.24109-2-aconole@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:33:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaron Conole <aconole@redhat.com>
Date: Tue,  3 Dec 2019 16:34:14 -0500

> The act_ct TC module shares a common conntrack and NAT infrastructure
> exposed via netfilter.  It's possible that a packet needs both SNAT and
> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> this because it runs through the NAT table twice - once on ingress and
> again after egress.  The act_ct action doesn't have such capability.
> 
> Like netfilter hook infrastructure, we should run through NAT twice to
> keep the symmetry.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> 
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> NOTE: this is a repost to see if the email client issues go away.

Applied and queued up for -stable.

Next time, please:

1) Provide an introductory posting ala "[PATCH net 0/N] ..." describing
   what the patch series does on a high level, how it is doing it, and
   why it is doing it that way.

   This allows people to understand what they are about to read, and it
   gives me a single mail to respon to when I apply your entire series.

2) Always clearly indicate the target GIT tree in your Subject line,
   in these cases it should have been "[PATCH net N/M]"

Thank you.
