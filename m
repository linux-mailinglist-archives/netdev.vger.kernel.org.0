Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945EF48086A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 11:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhL1K1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 05:27:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhL1K1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 05:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qn3jYiRAdmuDhV0PpSCkqk8vjJO40M/de8RbTgfqBVg=; b=59hKyGGOVfOGmVMJc/FlPfIAnp
        GAgBk6DA0jClgr5Xz2kC7+EiaxcMF0p9+W/wOE4/4Oi4KiTvMDAt+X+w04x4gTEXwmZucbee5V5mt
        TqEsQ3B+0tVFLLrFsX6g357pnSGoAbj/GtG715LW/aZLAmmOn96H8n2cJLxWQYO66cac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n29hu-0001vK-T0; Tue, 28 Dec 2021 11:27:50 +0100
Date:   Tue, 28 Dec 2021 11:27:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: Re: [PATCH net-next v2 1/1] qed: add prints if request_firmware()
 failed
Message-ID: <YcrmpvMAD5zKHqTE@lunn.ch>
References: <20211227175656.267184-1-vbhavaraju@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227175656.267184-1-vbhavaraju@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 09:56:56AM -0800, Venkata Sudheer Kumar Bhavaraju wrote:
> If driver load failed due to request_firmware() not finding the device
> firmware file, add prints that help remedy the situation.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
> ---
> Changes in v2:
>  - Rename QED_FW_REPO to FW_REPO
>  - Move FW_REPO macro to qed_if.h

Hi Venkata

When you decide to do something different to what has been requested,
it is a good idea to say why. There might be a very good reason for
this, but unless you explain it, i have no idea what it is.

   Andrew
