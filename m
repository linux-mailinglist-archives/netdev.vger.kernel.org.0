Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F6722A07C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVUGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVUGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:06:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC34C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:06:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E84D411FFCC40;
        Wed, 22 Jul 2020 12:49:35 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:06:20 -0700 (PDT)
Message-Id: <20200722.130620.1593427660005982219.davem@davemloft.net>
To:     vikas.singh@puresoftware.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuldip.dwivedi@puresoftware.com, calvin.johnson@oss.nxp.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case
 of ACPI probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595416934-18709-1-git-send-email-vikas.singh@puresoftware.com>
References: <1595416934-18709-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 12:49:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vikas Singh <vikas.singh@puresoftware.com>
Date: Wed, 22 Jul 2020 16:52:14 +0530

> *Disclaimer* -The information transmitted is intended solely for the 
> individual
> or entity to which it is addressed and may contain confidential 
> and/or
> privileged material. Any review, re-transmission, dissemination or 
> other use of
> or taking action in reliance upon this information by persons 
> or entities other
> than the intended recipient is prohibited. If you have 
> received this email in
> error please contact the sender and delete the 
> material from any computer. In
> such instances you are further prohibited 
> from reproducing, disclosing,
> distributing or taking any action in reliance 
> on it.As a recipient of this email,
> you are responsible for screening its 
> contents and the contents of any
> attachments for the presence of viruses. 
> No liability is accepted for any
> damages caused by any virus transmitted by 
> this email.

Postings with such disclaimers will be ignored.
