Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424CAEC791
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfKARdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:33:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfKARdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:33:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C88991512A251;
        Fri,  1 Nov 2019 10:33:03 -0700 (PDT)
Date:   Fri, 01 Nov 2019 10:33:02 -0700 (PDT)
Message-Id: <20191101.103302.244767657227182634.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/3] net: bridge: minor followup
 optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
References: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 10:33:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Fri,  1 Nov 2019 14:46:36 +0200

> After the converted flags to bitops we can take advantage of the flags
> assignment and remove one test and three atomic bitops from the learning
> paths (patch 01 and patch 02), patch 03 restores the unlikely() when taking
> over HW learned entries.
> 
> v2: a clean export of the latest set version

Series applied, thanks Nikolay.
