Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072161FC22C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFPXQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:16:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2380C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:16:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C398F128E92C9;
        Tue, 16 Jun 2020 16:16:42 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:16:38 -0700 (PDT)
Message-Id: <20200616.161638.798265001747755367.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/3][pull request] Intel Wired LAN Driver Updates
 2020-06-16
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
References: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 16:16:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 16 Jun 2020 15:53:51 -0700

> This series contains fixes to e1000 and e1000e.
> 
> Chen fixes an e1000e issue where systems could be waken via WoL, even
> though the user has disabled the wakeup bit via sysfs.
> 
> Vaibhav Gupta updates the e1000 driver to clean up the legacy Power
> Management hooks.
> 
> Arnd Bergmann cleans up the inconsistent use CONFIG_PM_SLEEP
> preprocessor tags, which also resolves the compiler warnings about the
> possibility of unused structure.
> 
> The following are changes since commit b8ad540dd4e40566c520dff491fc06c71ae6b989:
>   mptcp: fix memory leak in mptcp_subflow_create_socket()
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 1GbE

Pulled, thanks Jeff.
