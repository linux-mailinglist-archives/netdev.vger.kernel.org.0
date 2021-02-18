Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D0B31EF96
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhBRTSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233766AbhBRTHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F038964EB9;
        Thu, 18 Feb 2021 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613675207;
        bh=FrHHV3E6N+1AA2Nqu17cNwWkvNIKfXElU/udCGk6iX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mn1J7I34VaWuP5RDoOT6JSbByTtl0FztH/YwRu8f4eySR0o5PCI6zkZ+LxrCf5vH8
         RPhRhAqvHEp6KyY46+fQ9FQ3M4sPmodWkLTsxV2Hs79djoJcVMGZaADi7+gQ9ULgB6
         vRgjcFHnCLRfw8IIvPhZTsFJG/2mswLsF0fleq26iMi6TTnrdHUN2zQkG2sN+bQb5Y
         myIqQXMsg2VALXJRh+9HOq6XBUDqv3Sb7XtyCIkCWD6/njtkx4D3w/AmF/ym0fNvz2
         RyErDqGIAB6gcrAgb/rHAPWfIHrZiA0aNhwMKSYo0QnhGBuUKcyjWc4B3ZNsDjo9SB
         Lt7tmwsqtvG5Q==
Date:   Thu, 18 Feb 2021 11:06:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, grundler@chromium.org, andrew@lunn.ch,
        davem@devemloft.org, hayeswang@realtek.com,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCHv3 2/3] usbnet: add method for reporting speed without
 MDIO
Message-ID: <20210218110645.1375cfbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218102038.2996-3-oneukum@suse.com>
References: <20210218102038.2996-1-oneukum@suse.com>
        <20210218102038.2996-3-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 11:20:37 +0100 Oliver Neukum wrote:
> The old method for reporting network speed upwards
> assumed that a device uses MDIO and uses the generic phy
> functions based on that.
> Add a a primitive internal version not making the assumption
> reporting back directly what the status operations record.
> 
> v2: rebased on upstream
> v3: changed names and made clear which units are used
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>

ERROR: trailing whitespace
#48: FILE: drivers/net/usb/usbnet.c:1690:
+^Idev->tx_speed = SPEED_UNSET; $
