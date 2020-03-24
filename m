Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445151903F9
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgCXDxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:53:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXDxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 23:53:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 749B7154936E2;
        Mon, 23 Mar 2020 20:53:35 -0700 (PDT)
Date:   Mon, 23 Mar 2020 20:53:34 -0700 (PDT)
Message-Id: <20200323.205334.1556861946836251963.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next] net: mptcp: don't hang in mptcp_sendmsg()
 after TCP fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
References: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 20:53:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 19 Mar 2020 22:45:37 +0100

> it's still possible for packetdrill to hang in mptcp_sendmsg(), when the
> MPTCP socket falls back to regular TCP (e.g. after receiving unsupported
> flags/version during the three-way handshake). Adjust MPTCP socket state
> earlier, to ensure correct functionality of mptcp_sendmsg() even in case
> of TCP fallback.
> 
> Fixes: 767d3ded5fb8 ("net: mptcp: don't hang before sending 'MP capable with data'")
> Fixes: 1954b86016cf ("mptcp: Check connection state before attempting send")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

APplied.
