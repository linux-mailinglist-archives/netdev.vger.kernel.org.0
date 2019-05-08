Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8453717E29
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfEHQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:35:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfEHQfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:35:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB8501401512F;
        Wed,  8 May 2019 09:35:44 -0700 (PDT)
Date:   Wed, 08 May 2019 09:35:41 -0700 (PDT)
Message-Id: <20190508.093541.1274244477886053907.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, mateusz.bajorski@nokia.com,
        dsa@cumulusnetworks.com
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same
 rule exists when NLM_F_EXCL not supplied
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190507091118.24324-1-liuhangbin@gmail.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:35:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue,  7 May 2019 17:11:18 +0800

> With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
> fib_nl_newrule") we now able to check if a rule already exists. But this
> only works with iproute2. For other tools like libnl, NetworkManager,
> it still could add duplicate rules with only NLM_F_CREATE flag, like
> 
> [localhost ~ ]# ip rule
> 0:      from all lookup local
> 32766:  from all lookup main
> 32767:  from all lookup default
> 100000: from 192.168.7.5 lookup 5
> 100000: from 192.168.7.5 lookup 5
> 
> As it doesn't make sense to create two duplicate rules, let's just return
> 0 if the rule exists.
> 
> Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> Reported-by: Thomas Haller <thaller@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable, thanks.
