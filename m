Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9D2D5182
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgLJDj2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Dec 2020 22:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgLJDj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:39:28 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540EEC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 19:38:48 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 756B14D259C21;
        Wed,  9 Dec 2020 19:38:47 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:38:47 -0800 (PST)
Message-Id: <20201209.193847.1853316342833410585.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, pali@kernel.org
Subject: Re: [PATCH RESEND net-next 0/2] Add support for VSOL
 V2801F/CarlitoxxPro CPGOS03 GPON module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209112152.GT1551@shell.armlinux.org.uk>
References: <20201209112152.GT1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:38:47 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 9 Dec 2020 11:21:52 +0000

> Hi,
> 
> This patch set adds support for the V2801F / CarlitoxxPro module. This
> requires two changes:
> 
> 1) the module only supports single byte reads to the ID EEPROM,
>    while we need to still permit sequential reads to the diagnostics
>    EEPROM for atomicity reasons.
> 
> 2) we need to relax the encoding check when we have no reported
>    capabilities to allow 1000base-X based on the module bitrate.
> 
> Thanks to Pali Rohár for responsive testing over the last two days.
> 
> (Resending, dropping the utf-8 characters in Pali's name so the patches
>  get through vger. Added Andrew's r-b tags.)
Series applied, thanks.
