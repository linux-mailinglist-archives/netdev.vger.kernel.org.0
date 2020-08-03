Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABBF23AA60
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgHCQV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgHCQV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:21:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76662C061756
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 09:21:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s23so28612805qtq.12
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 09:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGx/+3R80pqTONt1Ak8Jv0FtZ9RnXmGr5UYQh/nJfgc=;
        b=oz4WmDl9Oz190893VnZkDCS4wOQS4shbES/m+6CcrPuw3fjI5AZstk82q//PF40BNs
         4k/NwG7css1MZBhTXvQLh28/2o4aIBgNGfTwdKMMODCiZpc7IpbfzYjsIWIDuyh3BnrX
         5O2V+Rki7eiEbpxTeoaC2Z4o3CZ2dwh14f07LxmDxYRFHazxX1nh6pJ9Ju4S697eKnBO
         HpXs3evqkVI1kVv7mfTOrYpMyuxY/jwcftllH0I7E9L3ICCAztypg4i69Mnuejqu8Bta
         lbFrqBrnWGuY86UlHOb3KsWJ0Ai8TVnVOSVk+jf15UsoCQWwfqJvEtREw/5Z5xS5fZz8
         QPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGx/+3R80pqTONt1Ak8Jv0FtZ9RnXmGr5UYQh/nJfgc=;
        b=K8+c3TFr5xdr0AZJP2e2+HcoXBgXqDnBw0MalseeQe0sQ+z3H8yah4Nye5KhhOLhdy
         i4tcq/ehFfBDZGJlw2s6TMUqJ41D5LPv8rPD1/avL8iTzsVSkbB6WTL6Y0uVWMNI4k2a
         LLaIYM9qB9J5hrnB+uOsZ06d8RIl34n8fZR1TrjKAXYIRMLpFsFDjhLj9clPhdC7tXI0
         6ylgbzh2GS1rX+7C6/UbzTbsrdersU1gm4oYhefz1qgj/AUTFqkk3VxrrKL0nlQ868BL
         1DQvK7Ew2DMzVZqy7QmpkNPUa97oCEvxFMAF2Sea9s6r1pigSf6skqCGdeWsbgoNl662
         y1fg==
X-Gm-Message-State: AOAM531bO2Tbpo92lXbdZRSf369qWAsxBwpOi5mZsI4Vy6G/XXZhnMMV
        BvwtcYHog0LZ7+Bg7dXBVFB/jDicyePfI64gRppQFg==
X-Google-Smtp-Source: ABdhPJwmhUXl8lp81qKMfCYBpUmSHgHegrIkkADullzlCmhwtwfwVeVPUVFj8fVYKHdh3v0sBSechMm68DGuSlE+2D4=
X-Received: by 2002:ac8:110e:: with SMTP id c14mr17167408qtj.71.1596471717331;
 Mon, 03 Aug 2020 09:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200803131948.41736-1-yuehaibing@huawei.com>
In-Reply-To: <20200803131948.41736-1-yuehaibing@huawei.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Mon, 3 Aug 2020 09:21:45 -0700
Message-ID: <CAMzD94TUnEwAtEHk9+87K964vE8sVxGZUVoZS-LjyZJKS+-O4Q@mail.gmail.com>
Subject: Re: [PATCH net-next] fib: Fix undef compile warning
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-By: Brian Vazquez <brianvv@google.com>

On Mon, Aug 3, 2020 at 6:20 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> net/core/fib_rules.c:26:7: warning: "CONFIG_IP_MULTIPLE_TABLES" is not defined, evaluates to 0 [-Wundef]
>  #elif CONFIG_IP_MULTIPLE_TABLES
>        ^~~~~~~~~~~~~~~~~~~~~~~~~
>
> Fixes: 8b66a6fd34f5 ("fib: fix another fib_rules_ops indirect call wrapper problem")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/core/fib_rules.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index a7a3f500a857..51678a528f85 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -23,7 +23,7 @@
>  #else
>  #define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f2, __VA_ARGS__)
>  #endif
> -#elif CONFIG_IP_MULTIPLE_TABLES
> +#elif defined(CONFIG_IP_MULTIPLE_TABLES)
>  #define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
>  #else
>  #define INDIRECT_CALL_MT(f, f2, f1, ...) f(__VA_ARGS__)
> --
> 2.17.1
>
>
