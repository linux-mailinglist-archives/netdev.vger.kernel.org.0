Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A8F8E255
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 03:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfHOBZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 21:25:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfHOBZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 21:25:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 032B01551DD81;
        Wed, 14 Aug 2019 18:25:27 -0700 (PDT)
Date:   Wed, 14 Aug 2019 21:25:25 -0400 (EDT)
Message-Id: <20190814.212525.326606319186601317.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, dledford@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1c6d1f04-96d5-94e5-3140-d3da194e14f3@oracle.com>
References: <53a6feaf-b48e-aadf-1bd7-4c82ddc36d1e@oracle.com>
        <20190814.143141.178107876214573923.davem@davemloft.net>
        <1c6d1f04-96d5-94e5-3140-d3da194e14f3@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 18:25:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Wed, 14 Aug 2019 14:45:21 -0700

> a) It is utterly inappropriate to have Oracle applications
>    rely on a /proc/sys API that was kept out of Upstream-Linux
>    for this long

Yes.

> 
> b) It is utterly inappropriate to include such a /proc/sys API
>    that Oracle applications have depended on this late

Also yes.
