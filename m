Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FF630EA38
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhBDCc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233452AbhBDCcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:32:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDFF64F53;
        Thu,  4 Feb 2021 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612405901;
        bh=/69d/cguuk4LpqCu70P338F1k9S9b28U2Rkk4TZ7C/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KIuzXPFge2hL/kI0jjZzNqL3BEN0+gzvWZYAlHlqqpVGB99GOroPwN1PBb0//UEPn
         gDup9z0tsf1eBfi/5BcyerKzvnTkcdWE5hQpSACFHA6uXgeUOp34rVLMHkprHxu6qh
         lxxrjwhZpDZEGesRVV66aPorKkSP99HuNXjKk2Ju/wWC7gPIlcc9UeAZQAlTC4+6BS
         9mxi9qZAapvQKAxvPKoKDGz6v+B5I7znuila+Y6jS+h+Bi7jJT6EgjN8Pug30tXONA
         fVUwXW6g94DmwWCQghobBZhDesvEOJMEdQt4ywbkJazci8jgXKCYlWLyLuPG7EzUN6
         veLeHLkX5Xmew==
Date:   Wed, 3 Feb 2021 18:31:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] chelsio: improve PCI VPD handling
Message-ID: <20210203183140.7d6e0fc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 21:34:49 +0100 Heiner Kallweit wrote:
> Working on PCI VPD core code I came across the Chelsio drivers.
> Let's improve the way how they handle PCI VPD.
> 
> This series touches only device-specific quirks in the core code,
> therefore I think it should go via the netdev tree.

Raju, please take a look.
