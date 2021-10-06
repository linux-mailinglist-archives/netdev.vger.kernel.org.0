Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6868B423AE7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhJFJxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhJFJxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:53:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C002961058;
        Wed,  6 Oct 2021 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513900;
        bh=BK4+H5AuaYkDTKievNXx2DnwC4TlYK1hujS8y6R2LEI=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=qoJqaijODlXyZPZYWet3mGR02KzJLgR2oqrDeMDb+RrIhLKMRhDBFyOzJcOUV1ueH
         sAl7vTwYPDFln9W+jA9VJ3bOEysMiidenxLtU3ulwXyRX12xIpLGZPg/ytgZO6lbQ1
         x7RXNcUWG3UL0daS7NxYfSHuim7IzGQrLG0knLLlH6Xq8ZF5Id6m5vy/yQ5OBavmjv
         O0KIuF2kiThxPrFH9U9+SSlVIqR5NS0KovQefT+JAHdI96cQ8I2GlF3Bb3Qvs/v56G
         eBgJ2JVvSVd/n2R8EeiZ6QZNhyEJOPhdPIGEw6rXsDcoXniKoLFFHrfA+LAPmQIQoP
         nvo3jGFPidvVQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211006094455.138504-1-atenart@kernel.org>
References: <20211006094455.138504-1-atenart@kernel.org>
Subject: Re: [PATCH iproute2-next 1/3] man: devlink-port: fix the devlink port add synopsis
From:   Antoine Tenart <atenart@kernel.org>
Cc:     netdev@vger.kernel.org
To:     dsahern@gmail.com, jiri@nvidia.com, stephen@networkplumber.org
Message-ID: <163351389733.4226.277758285167624511@kwain>
Date:   Wed, 06 Oct 2021 11:51:37 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-10-06 11:44:53)
> When configuring a devlink PCI SF port, the sfnumber can be specified
> using 'sfnum' and not 'pcisf' as stated in the man page. Fix this.

A similar issue should be fixed for 'pcipf' which should be 'pfnum'. I
forgot to include it here, I'll fix it in a separate patch.

Antoine

> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  man/man8/devlink-port.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
> index 147c8e271d79..4d2ff5d87144 100644
> --- a/man/man8/devlink-port.8
> +++ b/man/man8/devlink-port.8
> @@ -53,7 +53,7 @@ devlink-port \- devlink port configuration
>  .RB "[ " pcipf
>  .IR PFNUMBER " ]"
>  .br
> -.RB "{ " pcisf
> +.RB "{ " sfnum
>  .IR SFNUMBER " }"
>  .br
>  .RB "[ " controller
> --=20
> 2.31.1
>=20
