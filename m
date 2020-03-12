Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D11182949
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbgCLGq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:46:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbgCLGq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:46:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9503214DD5D2F;
        Wed, 11 Mar 2020 23:46:58 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:46:58 -0700 (PDT)
Message-Id: <20200311.234658.1725769251569186165.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        rmk+kernel@arm.linux.org.uk, ioana.ciornei@nxp.com,
        olteanv@gmail.com
Subject: Re: [PATCH net] net: dsa: Don't instantiate phylink for CPU/DSA
 ports unless needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311152424.18067-1-andrew@lunn.ch>
References: <20200311152424.18067-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:46:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 11 Mar 2020 16:24:24 +0100

> By default, DSA drivers should configure CPU and DSA ports to their
> maximum speed. In many configurations this is sufficient to make the
> link work.
> 
> In some cases it is necessary to configure the link to run slower,
> e.g. because of limitations of the SoC it is connected to. Or back to
> back PHYs are used and the PHY needs to be driven in order to
> establish link. In this case, phylink is used.
> 
> Only instantiate phylink if it is required. If there is no PHY, or no
> fixed link properties, phylink can upset a link which works in the
> default configuration.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied and queued up for -stable, thanks.
