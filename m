Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6035201BB1
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390827AbgFSTz2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jun 2020 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387750AbgFSTz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:55:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC77C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:55:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDF321284C687;
        Fri, 19 Jun 2020 12:55:27 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:55:27 -0700 (PDT)
Message-Id: <20200619.125527.1150681649296406722.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-06-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
References: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 12:55:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 18 Jun 2020 23:22:06 -0700

> This series contains fixes to ixgbe, i40e and ice driver.
> 
> Ciara fixes up the ixgbe, i40e and ice drivers to protect access when
> allocating and freeing the rings.  In addition, made use of READ_ONCE
> when reading the rings prior to accessing the statistics pointer.
> 
> Björn fixes a crash where the receive descriptor ring allocation was
> moved to a different function, which broke the ethtool set_ringparam()
> hook.
> 
> The following are changes since commit 0ad6f6e767ec2f613418cbc7ebe5ec4c35af540c:
>   net: increment xmit_recursion level in dev_direct_xmit()
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Pulled, thanks Jeff.
