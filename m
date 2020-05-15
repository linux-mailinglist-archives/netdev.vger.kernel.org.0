Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3051D5807
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgEOReQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEOReP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:34:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1506C061A0C;
        Fri, 15 May 2020 10:34:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE44014DB847F;
        Fri, 15 May 2020 10:34:14 -0700 (PDT)
Date:   Fri, 15 May 2020 10:34:14 -0700 (PDT)
Message-Id: <20200515.103414.148979892967430448.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, shuah@kernel.org, pabeni@redhat.com,
        mptcp@lists.01.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests:mptcp:pm: rm the right tmp file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515155442.1910397-1-matthieu.baerts@tessares.net>
References: <20200515155442.1910397-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:34:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Fri, 15 May 2020 17:54:41 +0200

> "$err" is a variable pointing to a temp file. "$out" is not: only used
> as a local variable in "check()" and representing the output of a
> command line.
> 
> Fixes: eedbc685321b (selftests: add PM netlink functional tests)
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks.
