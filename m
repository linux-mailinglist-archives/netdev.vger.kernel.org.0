Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4331EF93
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhBRTSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233761AbhBRTHU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 690CC64EBD;
        Thu, 18 Feb 2021 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613675198;
        bh=wVKkrTY7KS80a7NSWjKKLPNVHJjWasugN0VRtHyxZRg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uq17m3Xdi/ek8s6gRM9rV5WMb9nplOA4xiUqYT6IXZUXbx6ssggx4midpomtZkUqT
         TYxU0e/7q/NA7jcLvQUmrP+JqF5wy5yRZvVfDsfhcw4Su45vRmmTQaT0P1eB7IAM9D
         TXWnn7tdndMKEGY80Im65/uUu1Z8UsuvkXwYo/YRGsLN/na5nIqqL8M13bRVxz5mLy
         DpxwycnBLsKrIBTGrY1cp4A/5yI08cSFrKr8/QjVmigNbek63/gSsjqo7iWK5Z47/F
         larR5sZJEtOfujaL29TovmDRyNgcvQh9wL7dQ3z1/FhPCmdzyg0T665x1hnbE/8GYz
         BIMx0HDPbCBMg==
Date:   Thu, 18 Feb 2021 11:06:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, grundler@chromium.org, andrew@lunn.ch,
        davem@devemloft.org, hayeswang@realtek.com,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCHv3 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
Message-ID: <20210218110636.0ff08c64@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218102038.2996-2-oneukum@suse.com>
References: <20210218102038.2996-1-oneukum@suse.com>
        <20210218102038.2996-2-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 11:20:36 +0100 Oliver Neukum wrote:
> The old generic functions assume that the devices includes
> an MDIO interface. This is true only for genuine ethernet.
> Devices with a higher level of abstraction or based on different
> technologies do not have it. So in preparation for
> supporting that, we rename the old functions to something specific.
> 
> v2: rebased on changed upstream
> v3: changed names to clearly say that this does NOT use phylib
> 
> Signed-off-by : Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>

This one does not build.
