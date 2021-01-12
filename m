Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB92F24FD
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbhALAhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhALAhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3963A2253A;
        Tue, 12 Jan 2021 00:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610411814;
        bh=fuqMB3JvtvqmP24TXR4BHpkuOscD5gdquS0kiamxu8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BD1zMfkmomIeCKiSiONqmRmW05wSMJi/Yoa3fhKWlmqwt+A16wcI7LuvlSMWpdEAu
         qgupeHdehqzv9GEuvbnTEUKhyOEaH7qX8DDgAq4jb0tj+tIS1as5JFm9VnHkUd/8Vr
         glO3F0XWvLzhcQ1xcp2azCtn8jx0Y0OXS5g83nSvSzca9+qa4O6h1AFhBC+dr0m74X
         8qu0nqQ6QUyBqoznr1Fwyyt0uFXJFBdYaqBm2IpgppIJRMOSLMyEoNpAUJrFPUb5f7
         P6dP8qdrsI+dXp/ODQPK8ByspFmvUxovxTE9I+aKtNdp65DGzG4tgvkRlRIWwk53xQ
         wRutJeez7ygEQ==
Date:   Mon, 11 Jan 2021 16:36:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>
Subject: Re: [PATCH net ] net: mvpp2: Remove Pause and Asym_Pause support
Message-ID: <20210111163653.6483ae82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
References: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 21:23:02 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Packet Processor hardware not connected to MAC flow control unit and
> cannot support TX flow control.
> This patch disable flow control support.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

I'm probably missing something, but why not 4bb043262878 ("net: mvpp2:
phylink support")?
