Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8E234EBB
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGaXwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:52:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E199C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 16:52:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8677311E58FA8;
        Fri, 31 Jul 2020 16:35:30 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:52:15 -0700 (PDT)
Message-Id: <20200731.165215.1896999111700327326.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net 0/2][pull request] Intel Wired LAN Driver Updates
 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
References: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:35:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Thu, 30 Jul 2020 10:09:36 -0700

> This series contains updates to the e1000e and igb drivers.
> 
> Aaron Ma allows PHY initialization to continue if ULP disable failed for
> e1000e.
> 
> Francesco Ruggeri fixes race conditions in igb reset that could cause panics. 
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 1GbE

Pulled, thank you.
