Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4F13D546D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 09:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhGZG4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 02:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231926AbhGZG4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 02:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44E3E600D1;
        Mon, 26 Jul 2021 07:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627285020;
        bh=OK1qGOdZ06FvvljRmyZTOK8i9RQOvJ0QRhK84upPMQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vstfUjvf9d2aO0m59l6dVsuWh/prrBBEm/QIypMEJVUlhBg5+UCRrj7N3MJVm70yU
         +KZYRPwLLqFDRf9NOQN4ST74dZHNLhpyz38QNZd70oeYJ9xiJmyo9WMgXNeINIfQ/T
         Lab0ZCOTsMWjmf9WZlROe5ZjQZ6Q68uASMjSVPeA=
Date:   Mon, 26 Jul 2021 09:36:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into
 r8152_main.c and r8152_fw.c
Message-ID: <YP5mFKeJsGezjdve@kroah.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
 <1394712342-15778-373-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-373-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 12:01:09PM +0800, Hayes Wang wrote:
> Rename r8152.c with r8152_main.c. Move some basic definitions from
> r8152_main.c to r8152_basic.h. Move the relative code of firmware
> from r8152_main.c to r8152_fw.c. Rename the definition of "EFUSE"
> with "USB_EFUSE".

That is a lot of different things all happening in one commit, why?

Please break this up into "one patch per change" and submit it that way.

But the real question is why break this file up in the first place?
What is wrong with the way it is today?  What future changes require
this file to be in smaller pieces?  If none, why make this?  If there
are future changes, then please submit this change when you submit
those, as that would show a real need.

thanks,

greg k-h
