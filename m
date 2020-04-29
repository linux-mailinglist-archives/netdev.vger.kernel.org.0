Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D51BE247
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgD2PM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD2PMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:12:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B90C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:12:24 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so1838072ejd.8
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVEvWp5ihvuTDnEkLWjZwcc/dvwRyj5KIWpsklj/gPA=;
        b=Qnsry3WpIbN4WREFcIfEj2K5J/+oIlH1BRQ+gN5Y3N5bD/gGapWssXfrsFrMsuriOr
         Sk92c0uZ+kMrmmASb4NoHisQ1ZInR6x/O3EEuxeTJj5DGboywxoUM5/RsOFfhqba9g1k
         fuKqMKa5dqINBtXncDfXG3Defc4HVQef8aVOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVEvWp5ihvuTDnEkLWjZwcc/dvwRyj5KIWpsklj/gPA=;
        b=Wc4syyXD4lfUdNgnsKh/ri8LpOGZv3auN6VY2rhDuo8818o5DB/kvwMPgliSwh7zg4
         DShyIlJJiIXvbD3kYmusDwpA5FfJqygPemOQySbWZpZGbhBDbLqeH5bQfs+cQ595ILfd
         aQpP/6B1sPRVcFpA1v3BosrN/CqG39yGKBYIXhwHGD2Rel7ir5FXDVhcoUE0BsKFoGJe
         C5ivCRu4f7hj1ckJ+zDAgAU5VVzAZCOF4POnZ4FSszwUdXu4W5YQ31j5j11mdde0Ag6S
         bdp8nye1shgcfOWNbtjBU67Hr/NtTZACdX3ku5o3zgnBsy0Ub0suyzn2GSJcLMVJztFQ
         R09g==
X-Gm-Message-State: AGi0PuZB0LghEH3xqDGBq4zM+kemRqaVkDdgBV1UyJZHakqUvswA85rX
        0asql06xlsFxISev3dH3lN7Swg1YoOKmmiF7QmZBrQ==
X-Google-Smtp-Source: APiQypILe93ylzOW2okuKyeOc+1Jnpjm0WpL0eZDn2RdVS7ehRhFAU/eCE/AwpdQbvF/hDyYRGagrJPj0utEI/LVYO4=
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr3179132ejm.102.1588173142934;
 Wed, 29 Apr 2020 08:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com> <20200427235051.250058-2-bpoirier@cumulusnetworks.com>
In-Reply-To: <20200427235051.250058-2-bpoirier@cumulusnetworks.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 29 Apr 2020 08:12:14 -0700
Message-ID: <CAJieiUh0c1LCud2ZNuD5MygrBO=Yb1OgqHawxjgkX1j+6NHMrQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/7] bridge: Use the same flag names in input and output
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 4:51 PM Benjamin Poirier
<bpoirier@cumulusnetworks.com> wrote:
>
> Output the same names for vlan flags as the ones accepted in command input.
>
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
> ---

Benjamin, It's a good change,  but this will break existing users ?.


>  bridge/vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/bridge/vlan.c b/bridge/vlan.c
> index 205851e4..08b19897 100644
> --- a/bridge/vlan.c
> +++ b/bridge/vlan.c
> @@ -398,10 +398,10 @@ static void print_vlan_flags(__u16 flags)
>
>         open_json_array(PRINT_JSON, "flags");
>         if (flags & BRIDGE_VLAN_INFO_PVID)
> -               print_string(PRINT_ANY, NULL, " %s", "PVID");
> +               print_string(PRINT_ANY, NULL, " %s", "pvid");
>
>         if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
> -               print_string(PRINT_ANY, NULL, " %s", "Egress Untagged");
> +               print_string(PRINT_ANY, NULL, " %s", "untagged");
>         close_json_array(PRINT_JSON, NULL);
>  }
>
> --
> 2.26.0
>
