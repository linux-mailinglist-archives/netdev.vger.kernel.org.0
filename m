Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B3234ECA
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgGaX7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaX7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:59:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9890AC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 16:59:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F05EB11E58FA7;
        Fri, 31 Jul 2020 16:42:47 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:59:32 -0700 (PDT)
Message-Id: <20200731.165932.1651376227889370766.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net-next 00/12][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
References: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:42:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Thu, 30 Jul 2020 13:37:08 -0700

> This series contains updates to e100, e1000, e1000e, igb, igbvf, ixgbe,
> ixgbevf, iavf, and driver documentation.
> 
> Vaibhav Gupta converts legacy .suspend() and .resume() to generic PM
> callbacks for e100, igbvf, ixgbe, ixgbevf, and iavf.
> 
> Suraj Upadhyay replaces 1 byte memsets with assignments for e1000,
> e1000e, igb, and ixgbe.
> 
> Alexander Klimov replaces http links with https.
> 
> Miaohe Lin replaces uses of memset to clear MAC addresses with
> eth_zero_addr().
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Tony.
