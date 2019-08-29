Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177C0A2B34
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfH2XyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:54:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH2XyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:54:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DB6B153C23DD;
        Thu, 29 Aug 2019 16:54:09 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:54:08 -0700 (PDT)
Message-Id: <20190829.165408.2126978792643558445.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v3 2/3] dpaa2-eth: Use stored link settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567001295-31801-2-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567001295-31801-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1567001295-31801-2-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 16:54:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Wed, 28 Aug 2019 17:08:14 +0300

> Whenever a link state change occurs, we get notified and save
> the new link settings in the device's private data. In ethtool
> get_link_ksettings, use the stored state instead of interrogating
> the firmware each time.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
