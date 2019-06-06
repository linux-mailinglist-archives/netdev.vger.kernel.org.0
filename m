Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491E637F35
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfFFVDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:03:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfFFVDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:03:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 890C414E119E7;
        Thu,  6 Jun 2019 14:03:51 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:03:51 -0700 (PDT)
Message-Id: <20190606.140351.938284015995890762.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v4 00/20] Xilinx axienet driver updates (v4)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:03:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Wed,  5 Jun 2019 14:42:13 -0600

> This is a series of enhancements and bug fixes in order to get the mainline
> version of this driver into a more generally usable state, including on
> x86 or ARM platforms. It also converts the driver to use the phylink API
> in order to provide support for SFP modules.
> 
> Changes since v3:
> -Added patch to document mdio child node
> -Removed goto in backward-compatibility clock rate determination code in
>  "net: axienet: Use clock framework to get device clock rate"
> -Added previous Reviewed-by: tags where patches have not been modified
>  since review

I'm going to ask for one more respin to fix up some local variable
ordering.  Otherwise looks good.

See individual patch replies.

Thanks.
