Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE79198258
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgC3R1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:27:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgC3R1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:27:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 726D115C0D3DF;
        Mon, 30 Mar 2020 10:27:53 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:27:52 -0700 (PDT)
Message-Id: <20200330.102752.2020625896267237076.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH net-next 1/1] selftests:mptcp: fix failure due to
 whitespace damage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330142354.563259-2-matthieu.baerts@tessares.net>
References: <20200330142354.563259-1-matthieu.baerts@tessares.net>
        <20200330142354.563259-2-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:27:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Mon, 30 Mar 2020 16:23:54 +0200

> 'pm_nl_ctl' was adding a trailing whitespace after having printed the
> IP. But at the end, the IP element is currently always the last one.
> 
> The bash script launching 'pm_nl_ctl' had trailing whitespaces in the
> expected result on purpose. But these whitespaces have been removed when
> the patch has been applied upstream. To avoid trailing whitespaces in
> the bash code, 'pm_nl_ctl' and expected results have now been adapted.
> 
> The MPTCP PM selftest can now pass again.
> 
> Fixes: eedbc685321b (selftests: add PM netlink functional tests)
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks.
