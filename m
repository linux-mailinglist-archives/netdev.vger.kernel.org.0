Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96704160833
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgBQCcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:32:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:32:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60ACE1538019A;
        Sun, 16 Feb 2020 18:32:09 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:32:08 -0800 (PST)
Message-Id: <20200216.183208.2094995024213878147.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, petrm@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH net] selftests: forwarding: use proto icmp for
 {gretap,ip6gretap}_mac testing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211073256.32652-1-liuhangbin@gmail.com>
References: <20200211073256.32652-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:32:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 11 Feb 2020 15:32:56 +0800

> For tc ip_proto filter, when we extract the flow via __skb_flow_dissect()
> without flag FLOW_DISSECTOR_F_STOP_AT_ENCAP, we will continue extract to
> the inner proto.
> 
> So for GRE + ICMP messages, we should not track GRE proto, but inner ICMP
> proto.
> 
> For test mirror_gre.sh, it may make user confused if we capture ICMP
> message on $h3(since the flow is GRE message). So I move the capture
> dev to h3-gt{4,6}, and only capture ICMP message.
 ...
> Fixes: ba8d39871a10 ("selftests: forwarding: Add test for mirror to gretap")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thank you.
