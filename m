Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7C1D7BEF
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgERO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgERO4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:56:38 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7F7C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:56:38 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id dh1so948825qvb.13
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n77vtA/+ktvMTt9TwyFVHXMip0nepN2de34bSGL1QR8=;
        b=Fm9PF8VAsGs5oSV58hvxtXGEFTJMJrVzuZuXcqO9XiBnlURiuTN8KqEI5etF3Fb5US
         zmRzmoUBunmd8Ty7+hhlAlOM703bsQZYHanCk5oyWvU+IsZhzQ8uwzl5mO4+tCit9EHH
         FAXBCt8m6EZzd9FT2ZUt1+gzy4ukji2sUlRo5WfeGNxhmMWcKmSGNBuHT8gQNdm7yiuZ
         BUy1ksAgHvLpWMNS2Q7iHejKNG9dGguIWknazYV2B+kSzbqlj1zT2BY8u8gIdIltKLEG
         ifQaeo4SGXAUM7Q1GlSrQ5vjNMeZ3W+6a8TOawP+uHUBoa3PTMbiRLxQ/JdTeYeod7k2
         IL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n77vtA/+ktvMTt9TwyFVHXMip0nepN2de34bSGL1QR8=;
        b=bSCzQuZWIbSad1tHGYaw0NNRikcAHV16h40/AmNJ6zurwnCXrsuVn2fsVybecm693W
         JHny2YNlHBsU0MiFM8MchAWtV0pNVJYWlcwrwc47nTHDL6meixInJTvx0lqDktPrzBLn
         7+KTDEQiE2EljwRRNRyiR+rpqrHaNSLbgnqY6718vJ+wswC3F7sO8decTqeVd7qaZYj7
         FyWayTLfp3QRrUiVM2aXazYGCrx/ktlnDHem/ynmMSmpzNWwosuEmN29okrkCtsJHLC9
         gW5nb+nMc33c5VshaTe7B6g0RldTRnaTIYXtDrqNi1VszQPGVAlAKyXKocnq9OxpyFw3
         G1Gw==
X-Gm-Message-State: AOAM530QIeR2IiNPBNdBHLjg5zsJbOyze5RMYQKt6nYvjK/w2IyktCIo
        rngRK72mMzzQKPTCZKFUaGA=
X-Google-Smtp-Source: ABdhPJxOvzBZTKbSfRFtxPwRTVXq73R/IuYBsuDBpcLV4SLzhKhjLipLObzVan3zMvuj4VguFS4gZA==
X-Received: by 2002:a0c:a284:: with SMTP id g4mr1189304qva.243.1589813797674;
        Mon, 18 May 2020 07:56:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id r128sm8466330qke.109.2020.05.18.07.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:56:37 -0700 (PDT)
Subject: Re: [PATCH iproute2/net-next] man: tc-ct.8: Add manual page for ct tc
 action
To:     Paul Blakey <paulb@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, Jiri Pirko <jiri@mellanox.com>
Cc:     ozsh@mellanox.com, roid@mellanox.com
References: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0c5f8a4b-2d09-6cda-9228-dd83c4d97ff1@gmail.com>
Date:   Mon, 18 May 2020 08:56:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 8:10 AM, Paul Blakey wrote:
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> ---
>  man/man8/tc-ct.8     | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/tc-flower.8 |   6 +++
>  2 files changed, 113 insertions(+)
>  create mode 100644 man/man8/tc-ct.8
> 
> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
> new file mode 100644
> index 0000000..45d2932
> --- /dev/null
> +++ b/man/man8/tc-ct.8
> @@ -0,0 +1,107 @@
> +.TH "ct action in tc" 8 "14 May 2020" "iproute2" "Linux"
> +.SH NAME
> +ct \- tc connection tracking action
> +.SH SYNOPSIS
> +.in +8
> +.ti -8
> +.BR "tc ... action ct commit [ force ] [ zone "
> +.IR ZONE
> +.BR "] [ mark "
> +.IR MASKED_MARK
> +.BR "] [ label "
> +.IR MASKED_LABEL
> +.BR "] [ nat "
> +.IR NAT_SPEC
> +.BR "]"
> +
> +.ti -8
> +.BR "tc ... action ct [ nat ] [ zone "
> +.IR ZONE
> +.BR "]"
> +
> +.ti -8
> +.BR "tc ... action ct clear"

seems like you are documenting existing capabilities vs something new to
5.8. correct?
