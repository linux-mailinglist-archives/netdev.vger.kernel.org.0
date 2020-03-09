Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA5317D8B7
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgCIFEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:04:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIFEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:04:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BED88158B684B;
        Sun,  8 Mar 2020 22:04:47 -0700 (PDT)
Date:   Sun, 08 Mar 2020 22:04:47 -0700 (PDT)
Message-Id: <20200308.220447.1610295462041711848.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 22:04:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Thu, 5 Mar 2020 12:41:39 +0000

> Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> does not automatically update the switch MACs with the link parameters.
> Currently, the DSA code implements a work-around for this.
> 
> This series improves the Serdes integration, making use of the recent
> phylink changes to support split MAC/PCS setups.  One noticable
> improvement for userspace is that ethtool can now report the link
> partner's advertisement.

It looks like Andrew's regression has to be sorted out, so I'm deferring
this.
