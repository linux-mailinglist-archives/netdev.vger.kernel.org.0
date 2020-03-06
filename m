Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0517B675
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 06:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgCFFiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 00:38:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFFiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 00:38:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E07A515ADB685;
        Thu,  5 Mar 2020 21:38:15 -0800 (PST)
Date:   Thu, 05 Mar 2020 21:38:15 -0800 (PST)
Message-Id: <20200305.213815.971340263047646245.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] tun: debug messages cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 21:38:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed,  4 Mar 2020 17:23:54 +0100 (CET)

> While testing ethtool output for "strange" devices, I noticed confusing and
> obviously incorrect message level information for a tun device and sent
> a quick fix. The result of the upstream discussion was that tun driver
> would rather deserve a more complex cleanup of the way it handles debug
> messages.
> 
> The main problem is that all debugging statements and setting of message
> level are controlled by TUN_DEBUG macro which is only defined if one edits
> the source and rebuilds the module, otherwise all DBG1() and tun_debug()
> statements do nothing.
> 
> This series drops the TUN_DEBUG switch and replaces custom tun_debug()
> macro with standard netif_info() so that message level (mask) set and
> displayed using ethtool works as expected. Some debugging messages are
> dropped as they only notify about entering a function which can be done
> easily using ftrace or kprobe.
> 
> Patch 1 is a trivial fix for compilation warning with W=1.

Series applied, thanks.
