Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949D6288992
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 15:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbgJINHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 09:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388153AbgJINHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 09:07:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C96222D5;
        Fri,  9 Oct 2020 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602248840;
        bh=DLW/fxigT2xRQfbWFNe6kK2CQv1s4kgP4SpfF5Jrl2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p87qFBxBO61mfs69YrAFXMDbBbCz+bitmrzHxhCFfbqMrr7EVDIfCJNqtkaKH0WIx
         UpYwW1+FeOqcFzdMaISaH/fn9p6WsGAiuHjZk6UtzS3RJMJ2uQVaLisMa2g2u0fu69
         eetFFCTr/YbCCpGzKerTaKi/PLbnwsEeJUHfqO2o=
Date:   Fri, 9 Oct 2020 15:08:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: usbnet: remove driver version
Message-ID: <20201009130805.GB537013@kroah.com>
References: <bb7c95e6-30a5-dbd9-f335-51553e48d628@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb7c95e6-30a5-dbd9-f335-51553e48d628@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 02:10:57PM +0200, Heiner Kallweit wrote:
> Obviously this driver version doesn't make sense. Go with the default
> and let ethtool display the kernel version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
