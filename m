Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15699118366
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLJJTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfLJJTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 04:19:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D576F2073B;
        Tue, 10 Dec 2019 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575969547;
        bh=viR6aQSK+CgMvXKVb+9R042jToM9N6CtV3XYKFxogeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPT2fOupSrrWNlAManYtIUKMrNgPHN2ZR1NwfbQ+ys94H6NkTOq46FMutmaPMyH54
         SbhVzBbTYtraEBy1zMuSvvcQGdh893DskolaLHA82JIpMH7F8KJ0n6d9QttJRT6kdf
         tSGN1nKB0s9N2U/UkW3h+yRuaXT1LJTd69upJcbc=
Date:   Tue, 10 Dec 2019 10:19:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     devel@driverdev.osuosl.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        isdn4linux@listserv.isdn4linux.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] staging: remove isdn capi drivers
Message-ID: <20191210091905.GA3547805@kroah.com>
References: <20191209151114.2410762-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209151114.2410762-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 04:11:13PM +0100, Arnd Bergmann wrote:
> As described in drivers/staging/isdn/TODO, the drivers are all
> assumed to be unmaintained and unused now, with gigaset being the
> last one to stop being maintained after Paul Bolle lost access
> to an ISDN network.
> 
> The CAPI subsystem remains for now, as it is still required by
> bluetooth/cmtp.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  Documentation/ioctl/ioctl-number.rst        |    1 -

This file is not in 5.5-rc1, what tree did you make this against?

thanks,

greg k-h
