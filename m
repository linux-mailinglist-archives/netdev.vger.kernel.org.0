Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FDE9C64A
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfHYVfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 17:35:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbfHYVfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 17:35:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7632D14E7C123;
        Sun, 25 Aug 2019 14:35:23 -0700 (PDT)
Date:   Sun, 25 Aug 2019 14:35:22 -0700 (PDT)
Message-Id: <20190825.143522.409239878215119714.davem@davemloft.net>
To:     alexey.kodanev@oracle.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: mpls: fix mpls_xmit for iptunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
References: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 14:35:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Kodanev <alexey.kodanev@oracle.com>
Date: Fri, 23 Aug 2019 20:51:43 +0300

> When using mpls over gre/gre6 setup, rt->rt_gw4 address is not set, the
> same for rt->rt_gw_family.  Therefore, when rt->rt_gw_family is checked
> in mpls_xmit(), neigh_xmit() call is skipped. As a result, such setup
> doesn't work anymore.
> 
> This issue was found with LTP mpls03 tests.
> 
> Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>

Applied and queued up for v5.2 -stable.

Thanks.
