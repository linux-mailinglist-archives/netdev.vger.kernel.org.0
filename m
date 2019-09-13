Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7341B2170
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390315AbfIMNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:53:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388813AbfIMNxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:53:09 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C04DD14C664FF;
        Fri, 13 Sep 2019 06:53:07 -0700 (PDT)
Date:   Fri, 13 Sep 2019 14:53:06 +0100 (WEST)
Message-Id: <20190913.145306.2183002667534995204.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, snelson@pensando.io,
        jonathan@reliablehosting.com
Subject: Re: [net] ixgbevf: Fix secpath usage for IPsec Tx offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912190734.10560-1-jeffrey.t.kirsher@intel.com>
References: <20190912190734.10560-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 06:53:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 12 Sep 2019 12:07:34 -0700

> Port the same fix for ixgbe to ixgbevf.
> 
> The ixgbevf driver currently does IPsec Tx offloading
> based on an existing secpath. However, the secpath
> can also come from the Rx side, in this case it is
> misinterpreted for Tx offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for Tx offload.
> 
> CC: Shannon Nelson <snelson@pensando.io>
> Fixes: 7f68d4306701 ("ixgbevf: enable VF IPsec offload operations")
> Reported-by: Jonathan Tooker <jonathan@reliablehosting.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied, and like the ixgbe version of this fix I queued it up for -stable.

Thanks.
