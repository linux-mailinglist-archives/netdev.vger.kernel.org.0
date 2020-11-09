Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6552AC733
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgKIVYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIVYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 16:24:23 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F5A206CB;
        Mon,  9 Nov 2020 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604957063;
        bh=b/EOhYaevgoWYhd9zUWyOBpgXZZb8N7+yCYFBjUlEgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AXb2Qo3jP62qZXOFkkSEx2uOLFTDIsRL2OZta9/niqHncxmrueKtWcRzqEPad0VaM
         XPqXD3In89KuVDlmFUrGx/U8o13bs84LMlsiEp7Ttw2WZ7sa+wM5IgRh4zzxuMyDmD
         OGtVAaS2PJ+kuZTCryISs3pqK54yor1hB5OVriHk=
Date:   Mon, 9 Nov 2020 13:24:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
Message-ID: <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
References: <20201109193117.2017-1-TheSven73@gmail.com>
        <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 16:20:46 -0500 Sven Van Asbroeck wrote:
> Is this a bug? If so, what should its Fixes commit be? The spi commit
> upstream that enables SPI_CS_HIGH on my platform?

I'd put two fixes tags one for the spi commit and one for the commit
which introduced the assignment in the client driver.
