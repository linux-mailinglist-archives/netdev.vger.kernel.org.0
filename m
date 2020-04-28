Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43F11BCCBD
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgD1TvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728584AbgD1TvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 15:51:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884D3C03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 12:51:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 175AD1210A3EF;
        Tue, 28 Apr 2020 12:51:00 -0700 (PDT)
Date:   Tue, 28 Apr 2020 12:50:56 -0700 (PDT)
Message-Id: <20200428.125056.826064107395390963.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: Re: [PATCH net-next v4 0/3] New sysctl to turn off nexthop API
 compat mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 12:51:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Mon, 27 Apr 2020 13:56:44 -0700

> Currently route nexthop API maintains user space compatibility
> with old route API by default. Dumps and netlink notifications
> support both new and old API format. In systems which have
> moved to the new API, this compatibility mode cancels some
> of the performance benefits provided by the new nexthop API.
>     
> This patch adds new sysctl nexthop_compat_mode which is on
> by default but provides the ability to turn off compatibility
> mode allowing systems to run entirely with the new routing
> API if they wish to. Old route API behaviour and support is
> not modified by this sysctl
 ...

Series applied, thank you.
