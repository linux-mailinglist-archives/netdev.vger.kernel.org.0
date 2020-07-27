Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB93022FBD3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgG0WFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:05:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF1420672;
        Mon, 27 Jul 2020 22:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595887536;
        bh=iHl7rHB5pzCbXRX1DOb/cbEnbmrR62/bjTwYFTZhJjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IMn+32u6+CzeGSwbmHFhQHg1FPS7G9t6IyAGpHKa9H6x5OmkdKKhOk2+fobTCQw54
         6T/9dKcy4V+UANQ88a0AYnhSeHk4iDkeAahtu5ITuuNdqVEyshrEE7aO36BsoGCI6T
         rcDboaFDEKDDgF6i01G2Zq9hTsIfQ0hhSWV00SqU=
Date:   Mon, 27 Jul 2020 15:05:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Message-ID: <20200727150534.749dac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200727204731.1705418-1-andrew@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 22:47:28 +0200 Andrew Lunn wrote:
> RFC Because it needs 0-day build testing

Looks like allmodconfig falls over on patches 2 and 3.

make[6]: *** No rule to make target 'drivers/net/phy/phy/mscc/mscc_ptp.o', needed by 'drivers/net/phy/phy/mscc/mscc.o'.  Stop.
