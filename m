Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4A6332E91
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCISy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCISyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:54:20 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A3EC06174A;
        Tue,  9 Mar 2021 10:54:19 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id e20so3019874ljn.6;
        Tue, 09 Mar 2021 10:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xh3ApoclD7V/WByGDpuR9C/OkQWfw3kJt316u4qe2Ls=;
        b=MWCkLT/CyytKUTWPdRnUOmx8fTSjAV4lMSAVCKtnFMZI76r8mKFY/BUCioBvi5tc6J
         tY74k59BHl00aHRU6aSYCsa2OlqknL0uQYqBN0AkWcy49vQHdJh1Y5r/oWpKDcu+Vvf2
         nkmEMGL9qXTarSbsvpXy9AfY/Ak+4ZmbJp+HsUSB78B0udj0qa/VuXBQ2j4syLpwuFpE
         vaMnvoSyQUi1VA+ACHTBiLWZypI9sIYSVFkVbfVKZoaLlQoI8H2NSIkJfykkNZ7OZYPy
         3ejhOXGRNU5tkGEz3hd2iWNW+es2biPvkkTSVaWhSOYnq3yHcAfw6CWqZfH9pPoaKkyC
         jSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xh3ApoclD7V/WByGDpuR9C/OkQWfw3kJt316u4qe2Ls=;
        b=iBrV5IZeHejLh/scIBdvOThk7JAWT0TChEyGsncfHcRU7sNgja+xYQ5w//QT7KAYcJ
         iD/vTooG2cksMJSIR9BftIshIsRZ1fLosFBOxCgyt7PskFpxfhGOpmzry//uDE4d7Xt1
         jndXu657IvIBljJ1pASEZpHZQsKAdJDnyQPXLN9S50c8s1UrM2C81E5vlgSSooI5SUBx
         m0LCYpkhjFMvt4n8hAueXfz79eH6JtTSMpFLqHIdR42BxoiyvKLudtLu+MSs23r89G+a
         SwCswjieREtgTdxxViypabhaEBPuiuntoGhGggYwERre5Doht9n0u4AfOHH05z0OWwHH
         1yNg==
X-Gm-Message-State: AOAM5313uZHI56GgY5gIHPWEujdvKY4fZ7hmBVShGBkF9ZH2+BzjgFuK
        c9CDKx8ErcXb4E9iK4+jFlTxqK+Idy22BFX3pGk=
X-Google-Smtp-Source: ABdhPJyZRJwOUo9O0ktr4pYaRSqcRY5bi84dZTY2/rxSJvBDjNhanwh9dLd36LaF+9DO0wUVZUzdQN0o3gNbsp48cas=
X-Received: by 2002:a2e:8193:: with SMTP id e19mr14260345ljg.445.1615316058308;
 Tue, 09 Mar 2021 10:54:18 -0800 (PST)
MIME-Version: 1.0
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
In-Reply-To: <20210309032214.2112438-1-liuhangbin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 9 Mar 2021 10:53:41 -0800
Message-ID: <CALDO+SZXB8f8zP3sZTHpEgS3xspXbzTVBW18ODSfKsYJna-2Ew@mail.gmail.com>
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 7:22 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> When fixing the bpf test_tunnel.sh genve failure. I only fixed
> the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
> fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
> there is no geneve opt"), when there is no tunnel option and
> bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
> packets and break all geneve rx traffic. Just set opt_class to 0 and
> keep returning TC_ACT_OK at the end.
>
> Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

LGTM, thanks.
Acked-by: William Tu <u9012063@gmail.com>
