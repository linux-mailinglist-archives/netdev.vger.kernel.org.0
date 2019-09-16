Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9CB3CF0
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbfIPOyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:54:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388825AbfIPOyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:54:10 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A094153D0482;
        Mon, 16 Sep 2019 07:54:06 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:54:05 +0200 (CEST)
Message-Id: <20190916.165405.697062654750204318.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: clarify where phylink should be
 used
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1i94b6-0008TL-IR@rmk-PC.armlinux.org.uk>
References: <E1i94b6-0008TL-IR@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 07:54:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sat, 14 Sep 2019 10:44:04 +0100

> Update the phylink documentation to make it clear that phylink is
> designed to be used on the MAC facing side of the link, rather than
> between a SFP and PHY.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
