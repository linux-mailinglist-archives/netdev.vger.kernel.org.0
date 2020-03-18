Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039AF1896A8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgCRILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCRILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 675D61489E0B8;
        Wed, 18 Mar 2020 01:11:08 -0700 (PDT)
Date:   Tue, 17 Mar 2020 22:51:41 -0700 (PDT)
Message-Id: <20200317.225141.823903193683551749.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/4] net: add phylink support for PCS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317144906.GO25745@shell.armlinux.org.uk>
References: <20200317144906.GO25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 17 Mar 2020 14:49:06 +0000

> This series adds support for IEEE 802.3 register set compliant PCS
> for phylink.  In order to do this, we:
> 
> 1. convert BUG_ON() in existing accessors to WARN_ON_ONCE() and return
>    an error.
> 2. add accessors for modifying a MDIO device register, and use them in
>    phylib, rather than duplicating the code from phylib.
> 3. add support for decoding the advertisement from clause 22 compatible
>    register sets for clause 37 advertisements and SGMII advertisements.
> 4. add support for clause 45 register sets for 10GBASE-R PCS.
> 
> These have been tested on the LX2160A Clearfog-CX platform.
> 
> v2: eliminate use of BUG_ON() in the accessors.

Series applied, thanks.
