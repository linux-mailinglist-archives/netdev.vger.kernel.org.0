Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516022EEB76
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbhAHCrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAHCrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5559D235FF;
        Fri,  8 Jan 2021 02:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610073984;
        bh=3RaZpfkytPE7ruxLsbXw7CzXUGBF2D93MgTgnLLXcJk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XquMGtJnfBMyL2uvMR4sLntoX1NTr9c8c1+bmKn/EQdBrspsGO7OF6VBo9dMnKLFK
         89LoClvfWhv0eyDPOlbbarR10Q2dLwRM1lNr2k9vFn2+M1R4wFEp1XUkGunEHHYQBF
         bSUuVE8ir/9t+kSac9dgzJmjjQBl0Ky+bitGVfjhnvxncrIO4FlEqoO0BGVUh3PNT2
         ckL0oJoEWOUQS/ubhkzdptvDVwnOCN02qsiqK9D1hLXHfonkxV2BWG1qkvicj9u9a2
         7/7z10hor7NXfFBsrTR/5jt1uPlWmdkVZRvV8i2GinXlWbmz6zlLsF/TQ4w+xeIerX
         STcMWL/uV9wvA==
Date:   Thu, 7 Jan 2021 18:46:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        aleksander@aleksander.es, andrewlassalle@chromium.org,
        Alex Elder <elder@kernel.org>
Subject: Re: [PATCH net] net: ipa: modem: add missing SET_NETDEV_DEV() for
 proper sysfs links
Message-ID: <20210107184623.297798ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106100755.56800-1-stephan@gerhold.net>
References: <20210106100755.56800-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 11:07:55 +0100 Stephan Gerhold wrote:
> At the moment it is quite hard to identify the network interface
> provided by IPA in userspace components: The network interface is
> created as virtual device, without any link to the IPA device.
> The interface name ("rmnet_ipa%d") is the only indication that the
> network interface belongs to IPA, but this is not very reliable.
> 
> Add SET_NETDEV_DEV() to associate the network interface with the
> IPA parent device. This allows userspace services like ModemManager
> to properly identify that this network interface is provided by IPA
> and belongs to the modem.
> 
> Cc: Alex Elder <elder@kernel.org>
> Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>

Alex, can we get an ack?
