Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D0820FDA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgF3U15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgF3U15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:27:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D419C061755;
        Tue, 30 Jun 2020 13:27:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57BE912778958;
        Tue, 30 Jun 2020 13:27:54 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:27:53 -0700 (PDT)
Message-Id: <20200630.132753.950744279782703849.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org
Subject: LPC 2020 Networking and BPF Track CFP
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:27:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is a call for proposals for the networking and bpf track at the
Linux Plumbers Conference on the wider internet, which will be
happening on August 24th-28th, 2020.

This year the technical committee is comprised of:

David S. Miller <davem@davemloft.net>
Alexei Starovoitov <ast@kernel.org>
Daniel Borkmann <daniel@iogearbox.net>
Jakub Sitnicki <jakub@cloudflare.com>
Paolo Abeni <pabeni@redhat.com>
Jakub Kicinski <kuba@kernel.org>
Michal Kubecek <mkubecek@suse.cz>
Sabrina Dubroca <sd@queasysnail.net>

We are seeking talks of 40 minutes in length (including Q & A),
optionally accompanied by papers of 2 to 10 pages in length.  The
papers, while not required, are very strongly encouraged by the
committee.  The submitters intention to provide a paper will be taken
into consideration as a criteria when deciding which proposals to
accept.

Any kind of advanced networking and/or bpf related topic will be
considered.

Please submit your proposals on the LPC website at:

	https://www.linuxplumbersconf.org/event/7/abstracts/#submit-abstract

And be sure to select "Networking & BPF Summit" in the Track
pulldown menu.

Proposals must be submitted by August 2nd, and submitters will be
notified of acceptance by August 9th.

Final slides and papers (as PDF) are due on August 24th, the first day of
the conference.
