Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02D931517C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhBIOX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhBIOXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 09:23:43 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270ADC061788;
        Tue,  9 Feb 2021 06:23:02 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g6so9051386wrs.11;
        Tue, 09 Feb 2021 06:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29VTGtP+8SorCFNAH/KVluLy3VpynXCzlFHRh/jNUKY=;
        b=YxCuxpewM0CxC1oxGkXjfwIhaw3bRlqWHjrzN0lc+TIWWLMAdjcJ9Qbw9PCIeDNGhn
         2nkc8jIL1fp0hI9YTzKtlDwNh37j7nULhm50LyXoxVqU5t43gA6du5UTxfq567GOEji0
         7AfDl7MBd82Mr+z90NkDBqtADqJ2CvksMIyVGqmiYlIIfnD5J1lJhbqzsyNHbtd3bAOq
         t4XlAkWYGeTV0qkHxB/WW1AM/fdw+UXJ8UiUAY7k6hOa8e7Ov0zHo3y6t5pRjfdBHc22
         hxcX6tXRX7hjDexQGPPDwr19gjK1cZQ3hGJJyNbvLztnghM6V8aasvaKUV7Dr4aLjj31
         oitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29VTGtP+8SorCFNAH/KVluLy3VpynXCzlFHRh/jNUKY=;
        b=XqCyjLg19DxkPdwONBLr1iVaPmN8FXd4sh2VB7c6eXJ1+7rzFwzxUNmizs9M8AS0kD
         6JUf9eW4/mXZUBYhcC+r2WFqIIjumzEKf7QveDUcy2TG3d6s2nMAfMQlDazChx5pcGmD
         WI+9PEuhaGs1aJccmIZW3QiGCIITFjfthch5t4Fh/YDVvP/wuhOyq1aEfrIt3nC9GZdx
         y8S8qpWqdfIW2JiOI25lASz+EzGvU187a+iNy3BOiG3UkJYsDPy9n2eqbOCu9H0M3g/Z
         UMdOPxRAcYUgmSWeRov5+Xe8fwyvvWShnFMwBadg6BhPeoZQcWArCtBb83OtIFgeTeiG
         OSbA==
X-Gm-Message-State: AOAM531MkvHC0k2NVZniOl8Xp1WftEgYSF24c/GyLeQfihNBOw22OpvA
        2u7exv+H4eaIdqSLSBOZrNcVKME1phF1nRJIHMqYoLRUQsZ1eg==
X-Google-Smtp-Source: ABdhPJzIojL162t6P5SnRfBD8HdrIQM0Zg/75ocoQv2tmbiGQppHR31r1dVpnjNCmSxfGWDOLSwS0HZ6EDFuv64BQHU=
X-Received: by 2002:a5d:65cd:: with SMTP id e13mr25520253wrw.120.1612880580941;
 Tue, 09 Feb 2021 06:23:00 -0800 (PST)
MIME-Version: 1.0
References: <161287788114.579714.4927352060016972328.stgit@warthog.procyon.org.uk>
In-Reply-To: <161287788114.579714.4927352060016972328.stgit@warthog.procyon.org.uk>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 9 Feb 2021 22:22:44 +0800
Message-ID: <CADvbK_fSwjPdMbisWG8Ozt8oZ-nnk+UxaCotAUFV+ncPT7HMgA@mail.gmail.com>
Subject: Re: [RFC PATCH net] rxrpc: Fix missing dependency on NET_UDP_TUNNEL
To:     David Howells <dhowells@redhat.com>
Cc:     vfedorenko@novek.ru, kernel test robot <lkp@intel.com>,
        alaa@dev.mellanox.co.il, Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 9:38 PM David Howells <dhowells@redhat.com> wrote:
>
> The changes to make rxrpc create the udp socket missed a bit to add the
> Kconfig dependency on the udp tunnel code to do this.
>
> Fix this by adding making AF_RXRPC select NET_UDP_TUNNEL.
>
> Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Xin Long <lucien.xin@gmail.com>
> cc: alaa@dev.mellanox.co.il
> cc: Jakub Kicinski <kuba@kernel.org>
> ---
>
>  net/rxrpc/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
> index d706bb408365..0885b22e5c0e 100644
> --- a/net/rxrpc/Kconfig
> +++ b/net/rxrpc/Kconfig
> @@ -8,6 +8,7 @@ config AF_RXRPC
>         depends on INET
>         select CRYPTO
>         select KEYS
> +       select NET_UDP_TUNNEL
>         help
>           Say Y or M here to include support for RxRPC session sockets (just
>           the transport part, not the presentation part: (un)marshalling is
>
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>

Thanks.
