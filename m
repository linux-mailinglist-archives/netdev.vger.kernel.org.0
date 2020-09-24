Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3CB277399
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgIXOIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgIXOIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 10:08:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE121212CC;
        Thu, 24 Sep 2020 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600956485;
        bh=ZTaUIST6GpAfWCETtC1UaCXf9xNz/KEcUPSyTSP+apw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jFbb7roVQwX9zyyahSCr6PWGroxuxv/7tO01CHJg+o8CP/jknP7pAOfD9cBgxHV1o
         CCJNnD2bAQW4QT3yK8iRVnFJM4TbWmJdwvTN7cUhqqxwYhSdIacXW3QS9WlRcZXN3P
         0z2eLUOgkmK7dE1ny3eEbKUUjj1aGyJTYHC4gT2Y=
Date:   Thu, 24 Sep 2020 16:08:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Subject: Re: commit 37bd22420f85 ("af_key: pfkey_dump needs parameter
 validation") to stable
Message-ID: <20200924140822.GA737653@kroah.com>
References: <75492c42-5081-d988-5a9b-8dc269661e8c@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75492c42-5081-d988-5a9b-8dc269661e8c@android.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 06:58:24AM -0700, Mark Salyzyn wrote:
> Please consider
> 
> commit 37bd22420f856fcd976989f1d4f1f7ad28e1fcac ("af_key: pfkey_dump needs
> parameter validation")
> 
> for merge into all the maintained stable trees.
> 
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>

Now queued up, thanks!

greg k-h
