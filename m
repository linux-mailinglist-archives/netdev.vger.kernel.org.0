Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB182156BCB
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 18:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBIRX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 12:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbgBIRX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 12:23:57 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 761D020714;
        Sun,  9 Feb 2020 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581269036;
        bh=VH1+k2f2mvkNfA69pVn+Yuny3CTUnbGfABHhMx66A28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIzoZnHDgS46rLY7ZUH8T813mS/Frt24SPlAaV1omFZT7+Q9v/S+1y1+iWoPRGI3o
         jpwSlH63RD4weqi1jVNRXz2fL0t4EO7MaR8k4/VaQxWhi064nIQBkWLYwYku5uGne7
         bQRSpIXQimXTYyyCbvHEIZ+/1KHHxB994MM9hDpQ=
Date:   Sun, 9 Feb 2020 18:23:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mohana Datta Yelugoti <ymdatta.work@gmail.com>
Cc:     devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: remove spaces at the start of a line
Message-ID: <20200209172302.GA20244@kroah.com>
References: <ymdatta.work@gmail.com>
 <20200209171431.19907-1-ymdatta.work@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209171431.19907-1-ymdatta.work@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 09, 2020 at 10:44:30PM +0530, Mohana Datta Yelugoti wrote:
> This patch fixes "WARNING: please, no spaces at the start of a
> line" by checkpatch.pl by replacing spaces with the tab.
> 
> Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

What changed from v1?  Always put that below the --- line as documented.
Please try again with a v3.

thanks,

greg k-h
