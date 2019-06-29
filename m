Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC805ACD3
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF2SPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:15:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:15:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2381E14B9554D;
        Sat, 29 Jun 2019 11:15:32 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:15:31 -0700 (PDT)
Message-Id: <20190629.111531.1769109022679074180.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com
Subject: Re: [PATCH net-next v3 0/4] em_ipt: add support for addrtype
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 11:15:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Thu, 27 Jun 2019 11:10:43 +0300

> We would like to be able to use the addrtype from tc for ACL rules and
> em_ipt seems the best place to add support for the already existing xt
> match. The biggest issue is that addrtype revision 1 (with ipv6 support)
> is NFPROTO_UNSPEC and currently em_ipt can't differentiate between v4/v6
> if such xt match is used because it passes the match's family instead of
> the packet one. The first 3 patches make em_ipt match only on IP
> traffic (currently both policy and addrtype recognize such traffic
> only) and make it pass the actual packet's protocol instead of the xt
> match family when it's unspecified. They also add support for NFPROTO_UNSPEC
> xt matches. The last patch allows to add addrtype rules via em_ipt.
> We need to keep the user-specified nfproto for dumping in order to be
> compatible with libxtables, we cannot dump NFPROTO_UNSPEC as the nfproto
> or we'll get an error from libxtables, thus the nfproto is limited to
> ipv4/ipv6 in patch 03 and is recorded.
> 
> v3: don't use the user nfproto for matching, only for dumping, more
>     information is available in the commit message in patch 03
> v2: change patch 02 to set the nfproto only when unspecified and drop
>     patch 04 from v1 (Eyal Birger)

Series applied, thanks Nikolay.
