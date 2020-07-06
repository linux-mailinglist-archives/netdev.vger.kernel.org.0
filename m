Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A8B215F9F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgGFTrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgGFTrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:47:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17798C061755;
        Mon,  6 Jul 2020 12:47:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 073CE127EF29F;
        Mon,  6 Jul 2020 12:47:46 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:47:46 -0700 (PDT)
Message-Id: <20200706.124746.191843852351699222.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, cpaasch@apple.com,
        mathew.j.martineau@linux.intel.com, kuba@kernel.org,
        shuah@kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: mptcp: capture pcap on both sides
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706124408.3118005-1-matthieu.baerts@tessares.net>
References: <20200706124408.3118005-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:47:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Mon,  6 Jul 2020 14:44:08 +0200

> When investigating performance issues that involve latency / loss /
> reordering it is useful to have the pcap from the sender-side as it
> allows to easier infer the state of the sender's congestion-control,
> loss-recovery, etc.
> 
> Allow the selftests to capture a pcap on both sender and receiver so
> that this information is not lost when reproducing.
> 
> This patch also improves the file names. Instead of:
> 
>   ns4-5ee79a56-X4O6gS-ns3-5ee79a56-X4O6gS-MPTCP-MPTCP-10.0.3.1.pcap
> 
> We now have something like for the same test:
> 
>   5ee79a56-X4O6gS-ns3-ns4-MPTCP-MPTCP-10.0.3.1-10030-connector.pcap
>   5ee79a56-X4O6gS-ns3-ns4-MPTCP-MPTCP-10.0.3.1-10030-listener.pcap
> 
> It was a connection from ns3 to ns4, better to start with ns3 then. The
> port is also added, easier to find the trace we want.
> 
> Co-developed-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thank you.
