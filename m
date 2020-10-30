Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFE12A0542
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgJ3MWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgJ3MVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 08:21:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D106620724;
        Fri, 30 Oct 2020 12:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604060503;
        bh=m9aAan61vlcDdnDbhusjQF3ETzB6r62fgrZG5iISkk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eh163Oq7SIjoYigOds291SjeR9/hCHRwWPukPxKGESfboY3skrDbDkOZLf9jt8Uwd
         DE212MqmBOEGPSA+x5xg8/FbBL0jFdWVOLJB8k397peV3VBmv7yn6EyeWtTccGwN4B
         jWDbxVd+/l0VdTFZCQR+hIN53y7xpXRVfK8xDyxE=
Date:   Fri, 30 Oct 2020 13:22:31 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [GIT PULL, staging, net-next] wimax: move to staging
Message-ID: <20201030122231.GA2522837@kroah.com>
References: <CAK8P3a2zy2X9rivWcGaOB=c8SQ8Gcc8tm_6DMOmcQVKFift+Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2zy2X9rivWcGaOB=c8SQ8Gcc8tm_6DMOmcQVKFift+Tg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:06:14PM +0100, Arnd Bergmann wrote:
> The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:
> 
>   Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git
> tags/wimax-staging

Line wrapping makes this hard :(

Anyway, pulled into the staging-next branch now, so it's fine if this
also gets pulled into the networking branch/tree as well, and then all
should be fine.

thanks,

greg k-h
