Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E67387D80
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243786AbhERQbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237653AbhERQbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 12:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C07610E9;
        Tue, 18 May 2021 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621355428;
        bh=4ZBRrXcWPCCVuVPJ6n2VmLfCXKEO/hfmErEmuYLiqYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rhI4WS+UO/sZkToGAtj/hM5uQPgOBn3jhrRhSDN3AVke6J8j2xrDIxDcSqLplA9/c
         /4xLttZwGMYmz3e7/EL9hJ1YVycfGjoyLpv9x0wyJobFj6KLTyk02E3yqAS6ClYLCY
         +ouIuKf4PX5xh1alLeVA8H0ej9gHuGuLNYcKq48Y=
Date:   Tue, 18 May 2021 18:30:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] b43legacy: don't save dentries for debugfs
Message-ID: <YKPrognSduymsPBC@kroah.com>
References: <20210518162805.3700405-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518162805.3700405-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 06:28:05PM +0200, Greg Kroah-Hartman wrote:
> There is no need to keep around the dentry pointers for the debugfs
> files as they will all be automatically removed when the subdir is
> removed.  So save the space and logic involved in keeping them around by
> just getting rid of them entirely.
> 
> By doing this change, we remove one of the last in-kernel user that was
> storing the result of debugfs_create_bool(), so that api can be cleaned
> up.
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  .../net/wireless/broadcom/b43legacy/debugfs.c | 29 ++++---------------
>  .../net/wireless/broadcom/b43legacy/debugfs.h |  3 --
>  2 files changed, 5 insertions(+), 27 deletions(-)

Got the subject wrong, will resend...
