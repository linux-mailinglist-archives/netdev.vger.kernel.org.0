Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2DB5B75
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfIRF5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfIRF5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 01:57:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8207214AF;
        Wed, 18 Sep 2019 05:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568786267;
        bh=KIOTFHahegG0J33lyBSjGF2HsEMYmMKADeN/A2GZsdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpT5yJrvuct7UQk9sGP0z/IslXA5oP29VnvStyZacsto6YRMh746KI0rvk+Xt9QBW
         5kM136KqRl4NiXfk1+EDb171LXZzSGSd6CiJswnEEJL7p5hHr/SDF7FI1DA4Tuxr5H
         1+40PkVaPOXL5EYtMBGTfdZ979AvbtUpmLrd7BfM=
Date:   Wed, 18 Sep 2019 07:57:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ionic: Remove unnecessary ternary operator in
 ionic_debugfs_add_ident
Message-ID: <20190918055745.GB1830901@kroah.com>
References: <20190917232616.125261-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917232616.125261-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 04:26:16PM -0700, Nathan Chancellor wrote:
> clang warns:
> 
> ../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: warning:
> expression result unused [-Wunused-value]
>                             ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
>                                                          ^~~~~~~~~~~
> 1 warning generated.
> 
> The return value of debugfs_create_file does not need to be checked [1]
> and the function returns void so get rid of the ternary operator, it is
> unnecessary.
> 
> [1]: https://lore.kernel.org/linux-mm/20150815160730.GB25186@kroah.com/
> 
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Link: https://github.com/ClangBuiltLinux/linux/issues/658
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
