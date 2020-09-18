Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE82707EE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgIRVOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRVOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:14:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA81C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:14:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C5CC159D1582;
        Fri, 18 Sep 2020 13:57:32 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:14:18 -0700 (PDT)
Message-Id: <20200918.141418.944685857426836519.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mahesh@bandewar.net,
        rdunlap@infradead.org, lkp@intel.com
Subject: Re: [PATCH next] net: fix build without CONFIG_SYSCTL definition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918050832.1556691-1-maheshb@google.com>
References: <20200918050832.1556691-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:57:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Thu, 17 Sep 2020 22:08:32 -0700

> Earlier commit 316cdaa1158a ("net: add option to not create fall-back
> tunnels in root-ns as well") removed the CONFIG_SYSCTL to enable the
> kernel-commandline to work. However, this variable gets defined only
> when CONFIG_SYSCTL option is selected.
> 
> With this change the behavior would default to creating fall-back
> tunnels in all namespaces when CONFIG_SYSCTL is not selected and
> the kernel commandline option will be ignored.
> 
> Fixes: 316cdaa1158a ("net: add option to not create fall-back tunnels in root-ns as well")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>

Applied.
