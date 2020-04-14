Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA021A8F31
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392173AbgDNXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731539AbgDNXdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:33:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D28C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:33:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 380151280C7AC;
        Tue, 14 Apr 2020 16:33:52 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:33:51 -0700 (PDT)
Message-Id: <20200414.163351.1279633330783638818.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net v2 0/2] mv88e6xxx fixed link fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414003439.606724-1-andrew@lunn.ch>
References: <20200414003439.606724-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:33:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 14 Apr 2020 02:34:37 +0200

> Recent changes for how the MAC is configured broke fixed links, as
> used by CPU/DSA ports, and for SFPs when phylink cannot be used. The
> first fix is unchanged from v1. The second fix takes a different
> solution than v1. If a CPU or DSA port is known to have a PHYLINK
> instance, configure the port down before instantiating the PHYLINK, so
> it is in the down state as expected by PHYLINK.

Series applied with Sergei's grammar fixes to the commit message of
patch #2.

Thanks!
