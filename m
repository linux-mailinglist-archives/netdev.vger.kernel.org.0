Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D94485747
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242319AbiAERan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:30:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231302AbiAERaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 12:30:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=weZW5ha8Io4bV/JGQXKfpLDExlsC54g0Nr3oYlVeLK8=; b=NRcxcFXKgPiG0fHh3+Wmkl/m2T
        pXLpFxclmcwlrRLQWYTrKciPiWvXC/Tv5YYWdR8qZZ88dT9bp1VmtXbi5uAGDwvbiqP09R6mGyvuO
        Dz9bAS7jjIaGK7KVDiBljXcLqSXzuGpcEE5cnR19rkbtQUzhpUSqBg7YMeGTFzPajN3w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5A6y-000a2g-P6; Wed, 05 Jan 2022 18:30:08 +0100
Date:   Wed, 5 Jan 2022 18:30:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YdXVoNFB/Asq6bc/@lunn.ch>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
> 
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.

I do have to wonder why you are doing this in the kernel, and not
using a udev rule? This seems to be policy, and policy does not belong
in the kernel.

   Andrew
