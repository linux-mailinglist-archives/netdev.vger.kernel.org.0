Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0139165CBC
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBTL0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgBTL0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:26:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D08206ED;
        Thu, 20 Feb 2020 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197963;
        bh=HR0qKuPrHJ/+xe6GveLRXBZj2g/jNUTs/LCaVzCyEF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YqyBdR1cD2nPYZwTvI4os4MsqeYKpws9jk0vCIxBD1RBzx23hV/c8VVK+x6aXOry2
         XybEUyMD6AvH0AtJjg7d7bPp9F3RkvtxSUyfBiPNRoEe5SeLAFoOCTeoKwi9/5dERZ
         ThsGzs5ojeB3IrHUPf/bnsOB6hmZp7oB2enMyeX8=
Date:   Thu, 20 Feb 2020 12:26:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     christian.brauner@ubuntu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/9] net: fix sysfs permssions when device
 changes network
Message-ID: <20200220112601.GI3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200219.162416.1910523123736311797.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219.162416.1910523123736311797.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 04:24:16PM -0800, David Miller wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> Date: Tue, 18 Feb 2020 17:29:34 +0100
> 
> > This is v3 with explicit uid and gid parameters added to functions that
> > change sysfs object ownership as Greg requested.
> 
> Greg, please review.

Give me a chance :)

It's looking better, still needs a little bit of work before I'm happy
with the driver core and sysfs bits, see my review comments so far.

thanks,

greg k-h
