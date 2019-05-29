Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753632E759
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE2VVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:21:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2VVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:21:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55AC8136DF6FB;
        Wed, 29 May 2019 14:21:36 -0700 (PDT)
Date:   Wed, 29 May 2019 14:21:35 -0700 (PDT)
Message-Id: <20190529.142135.742041800728767747.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net: phylink: support for link gpio
 interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528100249.bpm4gieiatziqwqd@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
        <E1hVYrD-0005Z1-L0@rmk-PC.armlinux.org.uk>
        <20190528100249.bpm4gieiatziqwqd@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 14:21:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 28 May 2019 11:02:49 +0100

> I was intending to add a note to this patch indicating that it
> depends on "net: phylink: ensure consistent phy interface mode" but
> failed to do before sending it out - sorry!  If you'd prefer a patch
> that doesn't depend on that, please ask.  The only difference is the
> first two lines of context of the first hunk.

Ok, I just applied that dependency to 'net' and then I'll make sure
I apply this net-next series after my next net --> net-next merge
which should be either later tonight or tomorrow.

Thanks for the heads up.
