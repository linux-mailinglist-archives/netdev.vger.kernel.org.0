Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B042EFD1D
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbhAICVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbhAICVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 21:21:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3AB2238EC;
        Sat,  9 Jan 2021 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610158831;
        bh=uocowzg7s48gfkBOz3hrazFeCcd9+Q3pza9jR5nUc2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BOtY/W+h4VUX8rA/9vynD/4FMXJvKerxQ1LQ878ZPZbZ98EsESb4BIyH2jZWOOWJy
         OjUu49G/FwRU0POHp8FF6qOx+Rd61XQ/tlGnBKOr4v9weRduPxhFmPAYMBVaRoFPm7
         nrL9DOZqeGdY+pwF6QbUqob8zdkM3vIVUMnTmZ9ve9iYPke90xpw1st+q5VVsl/Y5R
         W3g9xKeAAHYJAdJLMwEYpBI0j5KmofdPYTvT9T9EpuosLdXf1KegtsjxqXGPlfC0mF
         sIZT/z8uM+szmbYgRYn9BMnC2nn4g+z7xI/7pi8YRd3g//gtRMPzjKoawnipIe6Ov+
         GGI5qM/Xkr4jg==
Date:   Fri, 8 Jan 2021 18:20:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Schuermann <leon@is.currently.online>
Cc:     oliver@neukum.org, davem@davemloft.net, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] r8152: Add Lenovo Powered USB-C Travel Hub
Message-ID: <20210108182030.77839d11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108202727.11728-2-leon@is.currently.online>
References: <20210108202727.11728-1-leon@is.currently.online>
        <20210108202727.11728-2-leon@is.currently.online>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 21:27:27 +0100 Leon Schuermann wrote:
> This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
> work with the cdc_ether driver.

When you say "used to work" do you mean there was a regression where
the older kernels would work fine and newer don't? Or just "it works
most of the time"?

> However, using this driver, with the
> system suspended the device sends pause-frames as soon as the receive
> buffer fills up. This produced substantial network load, up to the
> point where some Ethernet switches stopped processing packets
> altogether.
> 
> Using the Realtek driver (r8152) fixes this issue. Pause frames are no
> longer sent while the host system is suspended.
> 
> Signed-off-by: Leon Schuermann <leon@is.currently.online>
> Tested-by: Leon Schuermann <leon@is.currently.online>
