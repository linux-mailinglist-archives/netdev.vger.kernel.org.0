Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475011B6765
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgDWXCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 19:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWXCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 19:02:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243CDC09B042;
        Thu, 23 Apr 2020 16:02:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56A5D127EB5BE;
        Thu, 23 Apr 2020 16:02:53 -0700 (PDT)
Date:   Thu, 23 Apr 2020 16:02:51 -0700 (PDT)
Message-Id: <20200423.160251.1999549860904665142.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: correct per TX/RX ring statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587681857-19734-1-git-send-email-opendmb@gmail.com>
References: <1587681857-19734-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 16:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Thu, 23 Apr 2020 15:44:17 -0700

> The change to track net_device_stats per ring to better support SMP
> missed updating the rx_dropped member.
> 
> The ndo_get_stats method is also needed to combine the results for
> ethtool statistics (-S) before filling in the ethtool structure.
> 
> Fixes: 37a30b435b92 ("net: bcmgenet: Track per TX/RX rings statistics")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Applied and queued up for -stable, thanks.
