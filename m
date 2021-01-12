Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2442F37EC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391806AbhALSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbhALSHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 13:07:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2FF22DFA;
        Tue, 12 Jan 2021 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610474794;
        bh=uKhPLnbC+PeDc8Z7Zwu4S4vR4329ghC6x/Ev/h/7MLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpsdRLxZBhtDcucRn2w+diitXRhuttkBUj+BZ6Zenv21seFYl/qROmoz6gFwvwxuz
         jUCJs5dh4vxGBRMrNKk6H67uikOUPRlEv29ajafTdNEF5mf1iX/Zrptt8RHffyuCdU
         d4pq6QhKcwcEkbRZv6ggWtg4lOSro0JB5zpkzO/kSUDLUGhDecgzmGTiSYvmKy8sMC
         VOnGWhGZzEKPz90He8ssEdCvCDEvehdAGBdMlsiDKr4IRQAn1jI3r/phpLOW4njqbs
         F9ibOFBsautYYIZGxWHdzkscyRyoPCpp+dfmarMx5IFW1Ifu08wGbG+kgMHndV5eae
         UHJmAxpV2jrEw==
Date:   Tue, 12 Jan 2021 19:06:29 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112190629.5a118385@kernel.org>
In-Reply-To: <20210112162909.GD1551@shell.armlinux.org.uk>
References: <20210111012156.27799-1-kabel@kernel.org>
        <20210111012156.27799-6-kabel@kernel.org>
        <20210112111139.hp56x5nzgadqlthw@skbuf>
        <20210112170226.3f2009bd@kernel.org>
        <20210112162909.GD1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 16:29:09 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> I'm seriously thinking about changing the phylink_validate() interface
> such that the question of which link _modes_ are supported no longer
> comes up with MAC drivers, but instead MAC drivers say what interface
> modes, speeds for each interface mode, duplexes for each speed are
> supported.

BTW this would also solve the situation where DSA needs to know which
interface modes are supported on a particular port to know which modes
we can try on SFP connected to a DSA port.
