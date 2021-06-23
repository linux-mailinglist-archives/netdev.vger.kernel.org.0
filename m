Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595653B12F4
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 06:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWElJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 00:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFWElI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 00:41:08 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7FC061574;
        Tue, 22 Jun 2021 21:38:51 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a16so1143311ljq.3;
        Tue, 22 Jun 2021 21:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPuv7/XDNLOIz3d7x1JmiBp6RTIONbBpok1a+S97Lt0=;
        b=fHf2xIYrScTg78lnuABDz4l+ZnQBPhfJaira2fRrO/coAFn5UJU6O4TpOxlqQjkmaq
         Dod3TNBFDWco//EALKz8FQAK9OzSjYC5inTCn099HDPaVSvK+4hz5qw+2eVRhBejDGZD
         Zjk91DT/3JJn0zsj4zhRgFXA1xKDin+B2k5HofdwxNV0XpP9avRB8yXTYAFJx2N5fMIE
         MguHhkhuxV2xdWQ/xUZmNl9Htmt0w+qm72u2fvyoOtZj1Vy2NQ+PE6ZM+cJffdxFMmWU
         9a1LzFaQj6T1zVLbSRRdOcQbwb6laJuoZgQO4qJdXjJQD8UzJ2GlnoxRqeSkHvLsAd9W
         +xFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPuv7/XDNLOIz3d7x1JmiBp6RTIONbBpok1a+S97Lt0=;
        b=PtEm0ApqRS8fpscAMEFvDRB5aTQ519zHP6Ptn7XiWA3hpe/3NFn/h2tsuSfArFsjz8
         LI/8ozbLDIBfxInoDh+8FnixJchCnPGJQFgIz0maoYyCSu8h0WZOm4eOsyrC72rEN9gV
         NBy4C2ufxnxTwuFUfxucclOsoJtihcPEN9A3VWyFEZmTEmfu7gbnz+RM1DkufA1X30tT
         dqEwOtBnJAJ6L64OfzDu/JSHrXajvO/GSKrGBELWuqi89wqnM4EaKyJYxe8lZsrwz/qj
         xF0MFy09hcnMtRg5ib7GXVwQPscS6ea8h2Mp3C3Jl5Va+4tCQvR21ywxYHj/rOPJ3i+o
         kBNQ==
X-Gm-Message-State: AOAM531YBkUcRYFXTM5yMw/3EUfu3LCgmsqwRnmyJPAY2y/oSLaVibAO
        tlPMcChVuak8LpmMk+u8dD+HzDWiQNhI92W+C30=
X-Google-Smtp-Source: ABdhPJxWJBb2Ki7FtPMi/RYOme46Wwd9Ev0jjD1cdSkw24KCzkDvxn/4NqoFXZznfpUHsNMN64fDSG4tfoe3c42EIEY=
X-Received: by 2002:a2e:a7c5:: with SMTP id x5mr6299619ljp.258.1624423129923;
 Tue, 22 Jun 2021 21:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210623040918.8683-1-glin@suse.com>
In-Reply-To: <20210623040918.8683-1-glin@suse.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Jun 2021 21:38:38 -0700
Message-ID: <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
Subject: Re: [PATCH bpf] net/bpfilter: specify the log level for the kmsg message
To:     Gary Lin <glin@suse.com>, Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Loviska <mloviska@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 9:09 PM Gary Lin <glin@suse.com> wrote:
>
> Per the kmsg document(*), if we don't specify the log level with a
> prefix "<N>" in the message string, the default log level will be
> applied to the message. Since the default level could be warning(4),
> this would make the log utility such as journalctl treat the message,
> "Started bpfilter", as a warning. To avoid confusion, this commit adds
> the prefix "<5>" to make the message always a notice.
>
> (*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg
>
> Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
> Reported-by: Martin Loviska <mloviska@suse.com>
> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>  net/bpfilter/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
> index 05e1cfc1e5cd..291a92546246 100644
> --- a/net/bpfilter/main.c
> +++ b/net/bpfilter/main.c
> @@ -57,7 +57,7 @@ int main(void)
>  {
>         debug_f = fopen("/dev/kmsg", "w");
>         setvbuf(debug_f, 0, _IOLBF, 0);
> -       fprintf(debug_f, "Started bpfilter\n");
> +       fprintf(debug_f, "<5>Started bpfilter\n");
>         loop();
>         fclose(debug_f);
>         return 0;

Adding Dmitrii who is redesigning the whole bpfilter.
