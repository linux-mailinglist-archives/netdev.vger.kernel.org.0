Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F77813C194
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAOMrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:47:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgAOMrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:47:20 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5ACF159E783A;
        Wed, 15 Jan 2020 04:47:18 -0800 (PST)
Date:   Wed, 15 Jan 2020 04:40:41 -0800 (PST)
Message-Id: <20200115.044041.1319118760472344597.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH net-next] sfc: move MCDI filtering code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eb9a792f-8af3-a78e-8f5d-fd2397a83ad7@solarflare.com>
References: <eb9a792f-8af3-a78e-8f5d-fd2397a83ad7@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 04:47:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Tue, 14 Jan 2020 12:27:56 +0000

> Packet filter management is implemented by this code.
> Everything moved was also renamed.
> 
> Many style fixes included.
> 
> Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>

Several problesm with this:

1) Moving code and making style fixes are two separate changes.

2) The renames are a separate change as welll.

3) This patch gives warnings from git when applying:

Applying: sfc: move MCDI filtering code
.git/rebase-apply/patch:5071: space before tab in indent.
			 	  enum efx_filter_priority priority);
.git/rebase-apply/patch:5086: space before tab in indent.
				 	struct efx_rss_context *ctx,
warning: 2 lines add whitespace errors.
