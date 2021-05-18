Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D689387D7D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbhERQbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237653AbhERQbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 12:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3413361209;
        Tue, 18 May 2021 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621355417;
        bh=YckrPGCMRi5xRHYk9b2uFa4S/R3nnuBOYtdce+YJpLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FhpRVkefRVsMaeMd0RsIQoRZpoxPFvVemAQsUtk4iyBkbrrKFuJNjERhnzsgP94/g
         RjA1ob+YABMK9iXdCBaaEe9qwp9MJg4NuOwiYlVTnuFO1W+2+TFHL3kAh+3978LHQS
         /nivFU8z+Le3XLGN7BKBYT1o+VilFiKXzEH2yqBM=
Date:   Tue, 18 May 2021 18:30:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] b43: don't save dentries for debugfs
Message-ID: <YKPrl2NXL6EP7uJx@kroah.com>
References: <20210518162759.3700269-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518162759.3700269-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 06:27:59PM +0200, Greg Kroah-Hartman wrote:
> There is no need to keep around the dentry pointers for the debugfs
> files as they will all be automatically removed when the subdir is
> removed.  So save the space and logic involved in keeping them around by
> just getting rid of them entirely.
> 
> By doing this change, we remove one of the last in-kernel user that was
> storing the result of debugfs_create_bool(), so that api can be cleaned
> up.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Chao Yu <chao@kernel.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wireless/broadcom/b43/debugfs.c | 34 +++------------------
>  drivers/net/wireless/broadcom/b43/debugfs.h |  3 --
>  2 files changed, 5 insertions(+), 32 deletions(-)

Bah, got the subject wrong, will resend...
