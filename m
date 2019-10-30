Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED27BE947B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 02:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJ3BOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 21:14:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ3BOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 21:14:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F232914522EF5;
        Tue, 29 Oct 2019 18:14:31 -0700 (PDT)
Date:   Tue, 29 Oct 2019 18:14:31 -0700 (PDT)
Message-Id: <20191029.181431.141763391125677117.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] net: rtnetlink: fix a typo fbd -> fdb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029115932.399-1-nikolay@cumulusnetworks.com>
References: <20191029115932.399-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 18:14:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 29 Oct 2019 13:59:32 +0200

> A simple typo fix in the nl error message (fbd -> fdb).
> 
> CC: David Ahern <dsahern@gmail.com>
> Fixes: 8c6e137fbc7f ("rtnetlink: Update rtnl_fdb_dump for strict data checking")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thanks.
