Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCB3AB9DC
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFQQrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:47:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhFQQrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 12:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dXcYfiya4h6hzen3NHgKH/vKmD247J5vk58tr5CWxgk=; b=FJH4ZZ6rga6YkmP/4q/XCtXfId
        4ikEIRWAXvbsk7ilxqThK2DCAzrF1/mUN4ntnBbZEae5qHxlj+arG7iCydUMVJ9MJvKkRz/XEMTJ4
        zIMLQ5Px+IBmJN9jPgnmlqJ04D1hE6s+H9Q2woRaLizXjvcjKgTy+SlI1P1XXzmgyT9g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltv8k-009wGZ-5X; Thu, 17 Jun 2021 18:45:14 +0200
Date:   Thu, 17 Jun 2021 18:45:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <YMt8GvxSen6gB7y+@lunn.ch>
References: <20210617154206.GA17555@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617154206.GA17555@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 06:42:06PM +0300, Vadym Kochan wrote:
> The following changes since commit 0f66b74b6267fce66395316308d88b0535aa3df2:
> 
>   cypress: update firmware for cyw54591 pcie (2021-06-09 07:12:02 -0400)
> 
> are available in the Git repository at:
> 
>   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> 
> for you to fetch changes up to a43d95a48b8e8167e21fb72429d860c7961c2e32:
> 
>   mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support (2021-06-17 18:22:57 +0300)
> 
> ----------------------------------------------------------------
> Vadym Kochan (1):
>       mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support
> 
>  mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 13721584 -> 13721676 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)

Hi Vadym

You keep the version the same, but add new features? So what does the
version number actually mean? How does the driver know if should not
use the policer if it cannot tell old version 3.0 from new version
3.0?  How is a user supposed to know if they have old version 3.0
rather than new 3.0, when policer fails?

    Andrew
