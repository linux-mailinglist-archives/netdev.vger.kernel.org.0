Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E226D5927
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjDDHG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjDDHG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:06:57 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31171E56
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:06:55 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p204so37517481ybc.12
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 00:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680592014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=laATaplj+CfmkugTREhH+0gNcPHHNC3LROl0npAzzas=;
        b=UMNi+h5Xk7KYncFycbjE4EoZ2nRJsLDoWTKg4jD6ROf83x8rMFOdubrkt+U+z1SLuj
         01w2VqyulofTHP5SJNntvNJX4nXUt83BEg1ZBX9EcNDXHtOLXl5fZ6vODhJlSQocxkgA
         +Tg2O+GSHwOgXUpfHLPSN/K6LZa6EjM/WqEniwSlzwQLNrXzuPCoowK1b1i5X+D24goa
         tQdSEAk5tBofeyD3IerS0FIVaoCDczehJaCkjn9Mrp1Z8JnOsyYLEDvMHRrZAWLRYoPy
         0Zkx/PGaHir4ZbngKBG6htlPjIpeJLLTsV7KajKwDYIGcT2xNH9MLvKW/7zUjZBE2IAO
         sXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=laATaplj+CfmkugTREhH+0gNcPHHNC3LROl0npAzzas=;
        b=0a/ojyr6I659ZIi6eA7D26//HKgjQmkfwMv/vSaK4XYbKt8G5LJDJw6bKr0k3kdmOc
         cAd4AuAYZTVJH7rsrSp13D4aQa5SwFeS+QCkh7WJ2vn9J8ZliYNq4BVN3Lw3MJEsN6OX
         vhB0qpqJpUHVc733zLCtce2kxpY/pomUeqFMfbgDxsPhM+mryujucxHELxTiN7BL1pQw
         x5aFv3mS21f5tEDm2SD+D6GAUAf5Oe8ljyeBndj0qKJTVfSXk6tQgqJSZkSP/rz6Eq96
         CXyRnWSbc8Au8ro6vbWx0oLT1WaMrbJijHj24kThpGejtscsF4TNk2w7uQkD7yaxs/pG
         SpkA==
X-Gm-Message-State: AAQBX9ejLJz4kNOkJsx1s58VnsMDh+TH5bnQgKMVhBkAeYZ6reTYSCjA
        jxIw8+7oNa1I+kO0osALFNS03EW3h9pOXYytkktZwvTdSj8BoV4E/Z4=
X-Google-Smtp-Source: AKy350YnjhVIktk3BkmvB+aF5S/l3qrUSd+5psQZRRQwR3MSL8Jo/hFpWkI4oPnrhVHSKWG4PQpBM7HbWjjS+3NGVkg=
X-Received: by 2002:a25:d0cf:0:b0:b3c:637f:ad00 with SMTP id
 h198-20020a25d0cf000000b00b3c637fad00mr1252516ybg.5.1680592014363; Tue, 04
 Apr 2023 00:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230402084120.3041477-1-dankamongmen@gmail.com>
In-Reply-To: <20230402084120.3041477-1-dankamongmen@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 09:06:43 +0200
Message-ID: <CAJ8uoz2DhhSEDO=5kAB1UMp9mnXUtLisq60frqNK9TOZ9gMjeA@mail.gmail.com>
Subject: Re: [PATCH] [net] update xdp_statistics in docs
To:     nick black <dankamongmen@gmail.com>
Cc:     netdev@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 at 06:38, nick black <dankamongmen@gmail.com> wrote:
>
> Add the three fields from xdp_statistics that were
> missing in the AF_XDP documentation.

Thanks Nick.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: nick black <dankamongmen@gmail.com>
> ---
>  Documentation/networking/af_xdp.rst | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git Documentation/networking/af_xdp.rst Documentation/networking/af_xdp.rst
> index 247c6c4127e9..a968de7e902c 100644
> --- Documentation/networking/af_xdp.rst
> +++ Documentation/networking/af_xdp.rst
> @@ -445,6 +445,9 @@ purposes. The supported statistics are shown below:
>         __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
>         __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
>         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
> +       __u64 rx_ring_full; /* Dropped due to rx ring being full */
> +       __u64 rx_fill_ring_empty_descs; /* Failed to retrieve item from fill ring */
> +       __u64 tx_ring_empty_descs; /* Failed to retrieve item from tx ring */
>     };
>
>  XDP_OPTIONS getsockopt
> --
> 2.40.0
