Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EB4440D52
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 07:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhJaGWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 02:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhJaGWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 02:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026CB60E54;
        Sun, 31 Oct 2021 06:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635661199;
        bh=1EoD2t08e6Btk6wFEB+fntJQ9Qa8lN/iyNCE2pScLhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q0qDTTYTWKsUZNpfzB8dFhUKq9R9RfTHs18zRBN9kLi5438dbKqJjpCiDvuYsA6D5
         39CJQeTY+GVGWELv+Ljw2EqPKilz7jIB++GocVfwV2HQj4lE2sCBaaD68DBuIXBT+F
         qX5eKBYi1rErpLHAOSK1U+N+F2Qi1YXGB0EGXjgJ2u6WwrWU672LchYS/4GIua2hDE
         AbxS9qyyWLLQ4XeV6Pii01DuLldVxbC/roZ6aOllXXKxmsg6oY5SFTKYVpVW1Kd2XA
         0hpnrv0k0XhIUI/Kc8MSrpDJtI+YNwOOdgy6gvhdeLJOpHXlD2RRxaCrhfWg9SwIQQ
         X2c/uxvKACYqg==
Date:   Sun, 31 Oct 2021 08:19:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 1/4] ethtool: push the rtnl_lock into
 dev_ethtool()
Message-ID: <YX41iyJNkcNvxNRN@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
 <20211030171851.1822583-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030171851.1822583-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 10:18:48AM -0700, Jakub Kicinski wrote:
> Don't take the lock in net/core/dev_ioctl.c,
> we'll have things to do outside rtnl_lock soon.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev_ioctl.c |  2 --
>  net/ethtool/ioctl.c  | 14 +++++++++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
