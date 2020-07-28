Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C45230F2F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgG1Q1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731192AbgG1Q1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCDF2070B;
        Tue, 28 Jul 2020 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595953631;
        bh=9xus2yIdszk+coE+DRMZ2jhV+rHoza96AugF3s+DF7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cth0vJ2xb3yGYFAkdVIREQ4fFXg73ntiUy1i16+c4CONwDzfGg8ukDg8oOh9Y48kF
         X4xkugUehzZ/onpwt7YZgb8exBt48CllvCOCPelRSf98MHFL3AdWmW/9nmqt26sMJy
         xEwW5DqJMNeRvn7IWh9CQlLb9VmBG+Gr+pLyoWXg=
Date:   Tue, 28 Jul 2020 18:27:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 19/21] mlx5e: add the netgpu driver functions
Message-ID: <20200728162704.GB4181352@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-20-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727224444.2987641-20-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:44:42PM -0700, Jonathan Lemon wrote:
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
> @@ -0,0 +1,340 @@
> +#include "en.h"
> +#include "en/xdp.h"
> +#include "en/params.h"
> +#include "en/netgpu/setup.h"

<snip>

Always run scripts/checkpatch.pl on your patches do you do not get
grumpy driver maintainers telling you to run scripts/checkpatch.pl on
your patches.

greg k-h
