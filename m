Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942731E9364
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 21:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgE3Tbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 15:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3Tbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 15:31:43 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C96FC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:31:42 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w3so5489350qkb.6
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SmUUEbeXDLF+iafwInpzGXImR8+zVNEz76FidJ/RYZk=;
        b=Tel2fqGIWsX9YlcpkDfHYaoRrV+rN5bppS65bOIUmmMpjIVj/MDqx0c0AnBZ/mBGE/
         v5gKJcNpzcurcAHmyJ6gCXYMYCJVnlWjl0Lj0VZZ+jl2W9JzU9973iQyw0MjtK4BWTd3
         vSEOA+xtfe4ZcmYCamq4IBcvAZp6jQPOV05eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SmUUEbeXDLF+iafwInpzGXImR8+zVNEz76FidJ/RYZk=;
        b=T/WxJ0hxeERarIa7mT0Bj9aBw/3XlemWebaNad03Syug1+OogxMhlPPliURufTGmLu
         tChth34dGMScSIiUFKbKglHHLbDvKc0NDigY5oCnD13XGK7kA1q3dkXVexMDQ17pNbz+
         YpSPI2cyWSQLrrAUKyuhAGbEgTkVh248qEy173pkttjRYK3/iqCvUhJRsy9/pc7vOgSj
         mXzEYSz5EKgRHtkLClrROieHToglBJ9JauMkoBLh1TKEE14mDF1dDvgIcP2H7rXWmvxw
         Jo9ejdFFqvUHf234w9PP2H97Nc16UWLANrtcoy9wQttTsrB2PeiVB/PwOPfwK8y12VV/
         WhTA==
X-Gm-Message-State: AOAM5323U0QUnqp1atTJLX2VSMPmsXF2uPoNSzFB+yaY0n9N65H6PE0e
        gGN5XG2Fqh/y0r7WvYC8VrrPiehCzNMQCuny2nxX7w==
X-Google-Smtp-Source: ABdhPJyBpy3bfd2u4SJR+kuxRKwHGO4uPeJo7tzkRGxshfycqDmvThaYq/JHUtFGxtfLCL6yUGTzTQZjBR53xZRl9Xk=
X-Received: by 2002:a37:4e83:: with SMTP id c125mr4909035qkb.347.1590867101676;
 Sat, 30 May 2020 12:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200530121637.1233527-1-sharpd@cumulusnetworks.com>
In-Reply-To: <20200530121637.1233527-1-sharpd@cumulusnetworks.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 30 May 2020 12:31:36 -0700
Message-ID: <CAJieiUgLrZbnzr-jjmhTwqkuSNu5G1s9OcJZkYEkTC9904gfYQ@mail.gmail.com>
Subject: Re: [PATCH] nexthop: Fix Deletion display
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 5:16 AM Donald Sharp <sharpd@cumulusnetworks.com> wrote:
>
> Actually display that deletions are happening
> when monitoring nexthops.
>
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

This can go to iproute2 net

Thanks Donald.



>  ip/ipnexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 99f89630..c33cef0c 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -224,7 +224,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
>
>         open_json_object(NULL);
>
> -       if (n->nlmsg_type == RTM_DELROUTE)
> +       if (n->nlmsg_type == RTM_DELNEXTHOP)
>                 print_bool(PRINT_ANY, "deleted", "Deleted ", true);
>
>         if (tb[NHA_ID])
> --
> 2.26.2
>
