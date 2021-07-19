Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2503CF000
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbhGSWyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:54:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358758AbhGSUAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 16:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3uMQuJOgf5MFoPor7VfqjPUtgvpU4f5Y4dz2GCFHWjQ=; b=MJazRqVCXZePvwNekzwqSU/RU/
        wckzbfJRrTA317GpBvEggX8DtufkFrYa9Jn/VwiJSrufnkcVgsor/Be4V57uJWWqV7U4bBOJhiP5k
        MBThcbwBuizESEzZhWAjX2gbwDh249ivFupTP93JG77iI3Ip3gECqLzuuR8dlYP5yG0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5a4F-00DxeT-TD; Mon, 19 Jul 2021 22:40:47 +0200
Date:   Mon, 19 Jul 2021 22:40:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v6 1/2] net: phy: add API to read 802.3-c45 IDs
Message-ID: <YPXjT11U+O0LzOse@lunn.ch>
References: <20210719053212.11244-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719053212.11244-1-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 01:32:11PM +0800, Xu Liang wrote:
> Add API to read 802.3-c45 IDs so that C22/C45 mixed device can use
> C45 APIs without failing ID checks.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
