Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465BA9C0F0
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfHXXRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:17:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXXRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:17:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 517731525DED0;
        Sat, 24 Aug 2019 16:17:01 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:15:22 -0700 (PDT)
Message-Id: <20190824.161522.2104135467992379374.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Add phylink keyword to
 SFF/SFP/SFP+ MODULE SUPPORT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190824223454.15932-1-andrew@lunn.ch>
References: <20190824223454.15932-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:17:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 25 Aug 2019 00:34:54 +0200

> Russell king maintains phylink, as part of the SFP module support.
> However, much of the review work is about drivers swapping from phylib
> to phylink. Such changes don't make changes to the phylink core, and
> so the F: rules in MAINTAINERS don't match. Add a K:, keywork rule,
> which hopefully get_maintainers will match against for patches to MAC
> drivers swapping to phylink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied to 'net', as I like to keep MAINTAINERS as uptodate as widely
as possible.

Thanks.
