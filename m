Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728BC26E974
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQX0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQX0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:26:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31263C06174A;
        Thu, 17 Sep 2020 16:26:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 785791365D75F;
        Thu, 17 Sep 2020 16:09:49 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:26:35 -0700 (PDT)
Message-Id: <20200917.162635.1949227267966227941.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     mathew.j.martineau@linux.intel.com, kuba@kernel.org,
        shuah@kernel.org, pabeni@redhat.com, dcaratti@redhat.com,
        fw@strlen.de, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: mptcp: interpret \n as a new line
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916131352.3072764-1-matthieu.baerts@tessares.net>
References: <20200916131352.3072764-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:09:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Wed, 16 Sep 2020 15:13:51 +0200

> In case of errors, this message was printed:
> 
>   (...)
>   # read: Resource temporarily unavailable
>   #  client exit code 0, server 3
>   # \nnetns ns1-0-BJlt5D socket stat for 10003:
>   (...)
> 
> Obviously, the idea was to add a new line before the socket stat and not
> print "\nnetns".
> 
> Fixes: b08fbf241064 ("selftests: add test-cases for MPTCP MP_JOIN")
> Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied.
