Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097BAE4205
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404022AbfJYDRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfJYDRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 23:17:53 -0400
Received: from localhost (unknown [38.98.37.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B4E2166E;
        Fri, 25 Oct 2019 03:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571973472;
        bh=QuOpuTEqghbYbDPXBE0/lyFy+emlMYI74JUhK1F3hPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZYuuaJcMIZ5wXZd8dRwccdFHUfkYYxyC3E8cKNjjyDRG9kywRVxGAjiUp/4oUgEy
         DuYo+JNscpJ5ueO5X+GjXcjVp5hFaD/2T/iBAJWY4u1wGPNY5uLYZU95kX386Wu/6D
         WfsW4X044JCqufauc4LP2vJzftBYMKUW/Kw8Go2Q=
Date:   Thu, 24 Oct 2019 23:17:01 -0400
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuil Ivanov <samuil.ivanovbg@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Staging: qlge: Rename of function prefix ql_ to qlge_
Message-ID: <20191025031701.GA535333@kroah.com>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 12:29:38AM +0300, Samuil Ivanov wrote:
> In terms of namespace, the driver uses either qlge_, ql_ (used by
> other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
> clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
> prefix.
> 
> So I renamed three functions to the prefered namespace "qlge",
> and updated the occurrences in the driver.
> 
> Samuil Ivanov (3):
>   Staging: qlge: Rename prefix of a function to qlge
>   Staging: qlge: Rename prefix of a function to qlge
>   Staging: qlge: Rename prefix of a function to qlge

You sent 3 patches that do different things, yet have the same identical
subject line :(

Please fix up and resend the series.

thanks,

greg k-h
