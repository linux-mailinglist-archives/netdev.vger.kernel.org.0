Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43D248556B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiAEPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:06:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241223AbiAEPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:06:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D716B81BAB;
        Wed,  5 Jan 2022 15:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934F2C36AE3;
        Wed,  5 Jan 2022 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641395177;
        bh=UIMuHgAxGtmW/3NYX9jsHCAzjvSGeEibGzFXjWcp5U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tBWt6dijSGAkY3Y4euUFdC7AMhAxRKWpVum08lL61C74BxuWmpODIjLb26JkbrUX8
         q2JtteucOdf0A5owqkSgY1/PQuEv7SyQ+T8uAB+O3tO31vTAvm1/sX/BblW3oDWe3F
         7iQtihlTsep6l46OHL19lhm6FCQJLLK1zTk5C5Ao=
Date:   Wed, 5 Jan 2022 16:06:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Henning Schild <henning.schild@siemens.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 3/3] net: usb: r8152: remove unused definition
Message-ID: <YdWz5h3UmTuR9PHZ@kroah.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
 <20220105142351.8026-3-aaron.ma@canonical.com>
 <20220105155106.400e0285@md1za8fc.ad001.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105155106.400e0285@md1za8fc.ad001.siemens.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 03:51:06PM +0100, Henning Schild wrote:
> Am Wed,  5 Jan 2022 22:23:51 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> 
> Maybe add a 
> Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for more Lenovo Docks")

How can removing an unused #define fix anything?

