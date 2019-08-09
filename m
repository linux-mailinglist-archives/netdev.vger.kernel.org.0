Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA26F88437
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfHIUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:42:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37894 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfHIUmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:42:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6822145E7446;
        Fri,  9 Aug 2019 13:42:38 -0700 (PDT)
Date:   Fri, 09 Aug 2019 13:42:38 -0700 (PDT)
Message-Id: <20190809.134238.370705461293465028.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     netdev@vger.kernel.org, haiyangz@microsoft.com,
        sthemmin@microsoft.com, jakub.kicinski@netronome.com,
        sashal@kernel.org, kys@microsoft.com, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        vkuznets@redhat.com, marcelo.cerri@canonical.com
Subject: Re: [PATCH net v2] hv_netvsc: Fix a warning of suspicious RCU usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <PU1P153MB0169A6492DCBB490FE7FE52CBFD60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169A6492DCBB490FE7FE52CBFD60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 13:42:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Fri, 9 Aug 2019 01:58:08 +0000

> This fixes a warning of "suspicious rcu_dereference_check() usage"
> when nload runs.
> 
> Fixes: 776e726bfb34 ("netvsc: fix RCU warning in get_stats")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied.
