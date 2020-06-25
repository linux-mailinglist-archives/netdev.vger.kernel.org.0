Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD92098A2
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 04:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389532AbgFYCxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 22:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389357AbgFYCxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 22:53:41 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62FCC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 19:53:40 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so4398106ejg.12
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 19:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+LsFkYO5OH/kHFNJKFRU9I1jYS8QdAqmB63ashjM0+M=;
        b=fWhSd3c9XwXW8xxg7UNW17tldXszjCr90u99OVutHEAa0QnOCfSgf/ZhCRC+RjNAER
         xByqIBGCvq8WTgMEULTvlhqiLc2ODggEd1Va3451pSWd7OOGHdqS4YSw4KiTqC1Qt5fL
         e4zrgN/mWFsRmvM9bLZ2JMOvyyUJDCnuflCbIm4o6/ASUqR+bJUc8Zi9e9VF1/RUTa51
         94nA10gk6poLycpuSiVukpJdgrOQyy2LtCDc1FsUif8CSNG5zn7YjpsmZut7CN789jU7
         fVSeXotxkWKlQjXW+M3xnh8E9NKLZ0FpSLKR6uMGHqIndJbqOIuuObECAhF0N9jLtLAE
         J89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+LsFkYO5OH/kHFNJKFRU9I1jYS8QdAqmB63ashjM0+M=;
        b=DijJEuKUKSRKPBooNIGhGiPXRfrh4h2KSjlOffmXwQWZlCEHbIWOR+uuXm2grozNhi
         7/VZ+Xb7wQKOA09AT93WxcDWLKbmYKwkbVadfwjcspeRtf+m3/FfDEEROzoghQs8qkkO
         Nqexkn5c8VsAsjR3zldD9fNMuDiFdH94mzxX31TQsusYnTmFsQpNtU2xunxlKrbkfdB+
         Lm91ybket+c/VgErx38kpJXPNSTH8HWHu6gUlEWBbQtZcyETt1XtiiPj/JK2oTr0d8kx
         AHdrJ6CuIgrrnnLSvX39+8a93wu1Ct5o+ru18dO7/LHhTr14wx4FZJqvsLWWCyYwSLF3
         RX8w==
X-Gm-Message-State: AOAM532RaYINUVxYaQyU0nr+BgVdt+Hk0vGMKFLQ5j0QlmZOLH4bHAYk
        GjhRPVch2KRC6uUhYSXqLCujITVLpBxJQeGX7PMBq3fd
X-Google-Smtp-Source: ABdhPJwFWVc3x0KMEjcxnwMJug+gOLO5LFNdEAsOqEi+z7KuRJGFRXwRRdAGfupK5TTsvcmFskJVdMn52VKIuFOBjlk=
X-Received: by 2002:a17:907:6fc:: with SMTP id yh28mr17324589ejb.267.1593053619481;
 Wed, 24 Jun 2020 19:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-6-justin.iurman@uliege.be>
In-Reply-To: <20200624192310.16923-6-justin.iurman@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Wed, 24 Jun 2020 19:53:28 -0700
Message-ID: <CALx6S37UFbABwHs4t_f5w1vT6HtFURRWkOD5Ci9f-LH083QVmA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] ipv6: ioam: Documentation for new IOAM sysctls
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 12:33 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> Add documentation for new IOAM sysctls:
>  - ioam6_id: a namespace sysctl
>  - ioam6_enabled and ioam6_id: two per-interface sysctls
>
Are you planning add a more detailed description of the feature and
how to use it (would be nice I think :-) )

> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  Documentation/networking/ioam6-sysctl.rst | 20 ++++++++++++++++++++
>  Documentation/networking/ip-sysctl.rst    |  5 +++++
>  2 files changed, 25 insertions(+)
>  create mode 100644 Documentation/networking/ioam6-sysctl.rst
>
> diff --git a/Documentation/networking/ioam6-sysctl.rst b/Documentation/networking/ioam6-sysctl.rst
> new file mode 100644
> index 000000000000..bad6c64907bc
> --- /dev/null
> +++ b/Documentation/networking/ioam6-sysctl.rst
> @@ -0,0 +1,20 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================
> +IOAM6 Sysfs variables
> +=====================
> +
> +
> +/proc/sys/net/conf/<iface>/ioam6_* variables:
> +============================================
> +
> +ioam6_enabled - BOOL
> +       Enable (accept) or disable (drop) IPv6 IOAM packets on this interface.
> +
> +       * 0 - disabled (default)
> +       * not 0 - enabled
> +
> +ioam6_id - INTEGER
> +       Define the IOAM id of this interface.
> +
> +       Default is 0.
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index b72f89d5694c..5ba11f2766bd 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1770,6 +1770,11 @@ nexthop_compat_mode - BOOLEAN
>         and extraneous notifications.
>         Default: true (backward compat mode)
>
> +ioam6_id - INTEGER
> +       Define the IOAM id of this node.
> +
> +       Default: 0
> +
>  IPv6 Fragmentation:
>
>  ip6frag_high_thresh - INTEGER
> --
> 2.17.1
>
