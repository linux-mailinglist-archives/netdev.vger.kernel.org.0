Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C961328A42A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388953AbgJJWyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731367AbgJJTM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:12:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EF62246B;
        Sat, 10 Oct 2020 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602351837;
        bh=FUxvZW8qseqLImkWEVbDqiMAcUyT7ih9B7xfIOIhTyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mIsM2iI1yh5yHk66D1V9RjqUo34TvQzymncGxDC4hOi3sFDjFbr8qpZzn0fC1VvND
         0+emEoUquzrOnuENdzzX732Gbn4m/A4l6zsbIh1HIIBbJtri5aYEDNZ0XWfvS+zi5O
         cWYtKOimCgqaqaNRhieBmHUYtnkvLUflxQJGwqts=
Date:   Sat, 10 Oct 2020 10:43:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        David Miller <davem@davemloft.net>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: usbnet: remove driver version
Message-ID: <20201010104355.36ef60d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bb7c95e6-30a5-dbd9-f335-51553e48d628@gmail.com>
References: <bb7c95e6-30a5-dbd9-f335-51553e48d628@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 14:10:57 +0200 Heiner Kallweit wrote:
> Obviously this driver version doesn't make sense. Go with the default
> and let ethtool display the kernel version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thank you!
