Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8024502E
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 01:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHNXmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 19:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgHNXmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 19:42:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22080C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 16:42:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA8561277D408;
        Fri, 14 Aug 2020 16:25:57 -0700 (PDT)
Date:   Fri, 14 Aug 2020 16:42:38 -0700 (PDT)
Message-Id: <20200814.164238.59198060580551883.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net v2 0/3][pull request] Intel Wired LAN Driver Updates
 2020-08-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
References: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 16:25:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Fri, 14 Aug 2020 15:17:42 -0700

> This series contains updates to i40e and igc drivers.
> 
> Vinicius fixes an issue with PTP spinlock being accessed before
> initialization.
> 
> Przemyslaw fixes an issue with trusted VFs seeing additional traffic.
> 
> Grzegorz adds a wait for pending resets on driver removal to prevent
> null pointer dereference.
> 
> v2: Fix function parameter for hw/aq in patch 2. Fix fixes tag in patch
> 3.

Pulled, thanks Tony.
