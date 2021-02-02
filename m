Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4587830B3C6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhBBAC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhBBAC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:02:56 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1F3C061573;
        Mon,  1 Feb 2021 16:02:16 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id e70so18135024ote.11;
        Mon, 01 Feb 2021 16:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bT/iz9WYALSgsBz7kzhDYk3Z2OUTHTWobQFwOvLm2X8=;
        b=Sxt4XIvz5xz1jQyL9tuPtzcShPQ/1C4MuJEseRX8xHIBU36RotMXYpNYxcWHciykqZ
         EC6snIoS5Bsl3R/BAceAnp8E1kcF/COMXR/DNSaSCm46PCRZ0BE+ZxqU9N9U0kX1zuJp
         MhtUDQidtLxqsG/f8+nV4QWXcIILG77O5T9EbSkJS0t9Pt7MnOXGSMN49lLtWbvqMye3
         5oX8bbOC4bRXVg6b4/+6YSbqY+zYA7scEbqfB+9+dG4JGomlXA2l3Adh3hJlMMJdMr5T
         orvUVJSS2IwlVUK08UrR6VNQQ0mHcTSme7jLRsDIKEZp6u+gu8kdkZX1Mojox+KARnLZ
         Z4wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bT/iz9WYALSgsBz7kzhDYk3Z2OUTHTWobQFwOvLm2X8=;
        b=mHQxdBUCoKkHiL21OZPlI8eiqbc2rO7TFEKHHQ/Lp+E3+lTo32GrFQvI3wys0orCIC
         S9GOQgk1sRHh4pxb41/wuY6cxtjsaezB+hRvjcerMEbS9tsIbA116yv97vTS9XcObTUX
         DsPSFBl88IJx+yey3bm/+MPugPy8Xqne0k/0ed10+O02t1Sm6YGYduusxBd33DaaDkxr
         8fXBoVQAv3pNFqT5QagKH1OJrVRhuirPL0TfhT8Ewfwn3iGN2fi0MQ5R4Y1O65LeGD2/
         aZXz9xzosGQRSz4ncIQ+Zwqm2KcozWEHnRccKE7ooax4n15xaXRUTsj/Ajb77LbpXkPx
         +rtw==
X-Gm-Message-State: AOAM530H/yl54EtBLxTvSVbmilA22ZTSVRSUBKHzoMPps/iSlOGcJgP1
        eLzAHAOnK43s/biEB3xC6qp1oDkEUAvoo5sKh7Q=
X-Google-Smtp-Source: ABdhPJxcCt2KTdc++jkg/9PxQIP/fRRRB3kAXlvPaaWbHFKNhCQeyTC3IblzI5iNm9dcBIlR9YophVl93L+wY6NA8i4=
X-Received: by 2002:a05:6830:1b6b:: with SMTP id d11mr13279728ote.254.1612224135565;
 Mon, 01 Feb 2021 16:02:15 -0800 (PST)
MIME-Version: 1.0
References: <20210201232609.3524451-1-elder@linaro.org> <20210201232609.3524451-4-elder@linaro.org>
In-Reply-To: <20210201232609.3524451-4-elder@linaro.org>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Mon, 1 Feb 2021 16:02:04 -0800
Message-ID: <CAE1WUT6VOx=sS1K1PaJG+Ks06CMpoz_efCyNhFQhD83_YNLk5A@mail.gmail.com>
Subject: Re: [PATCH net 3/4] net: ipa: use the right accessor in ipa_endpoint_status_skip()
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 3:32 PM Alex Elder <elder@linaro.org> wrote:
>
> When extracting the destination endpoint ID from the status in
> ipa_endpoint_status_skip(), u32_get_bits() is used.  This happens to
> work, but it's wrong: the structure field is only 8 bits wide
> instead of 32.
>
> Fix this by using u8_get_bits() to get the destination endpoint ID.

Isn't

>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_endpoint.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 448d89da1e456..612afece303f3 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -1164,8 +1164,8 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
>                 return true;

A few lines above this, endpoint_id is initialized as u32. If we're
going for "correctness", endpoint_id should be a u8. But of course,
this would contrast with ipa_endpoint having it as a u32.


>         if (!status->pkt_len)
>                 return true;
> -       endpoint_id = u32_get_bits(status->endp_dst_idx,
> -                                  IPA_STATUS_DST_IDX_FMASK);
> +       endpoint_id = u8_get_bits(status->endp_dst_idx,
> +                                 IPA_STATUS_DST_IDX_FMASK);
>         if (endpoint_id != endpoint->endpoint_id)
>                 return true;
>
> --
> 2.27.0
>

As far as I see it, using u32_get_bits instead of u8_get_bits simply
eliminates confusion about the type of endpoint_id. Perhaps instead of
this patch, send a patch with a comment that while u32_get_bits is
used, the field is only 8 bits?

Best regards,
Amy Parker
(she/her/hers)
