Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B05FEEA
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfGDX7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:59:38 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35467 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfGDX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:59:37 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so6705207edd.2;
        Thu, 04 Jul 2019 16:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4jJW1ODjssujW7r0mvcLVnuRU8gRsnswie1vkMXHTM=;
        b=n6f7BIt6eZBh+rpzr1zV1MTJrx7Jf2rjQnSbNLTiVH+P1ILTFbvxVaeQJhaduosBjD
         HUZ2eC0jBoZTUk8RQwGuxsRuQ6apzVG9wthE6olbn6m7vxsM7wn8tkycUk0Mzt5TQNgl
         64wpxqEzCeubM8rk802V/hp6p50HJ/iFG/O/BABsqGIaZI60h7LVWQ7Ne1Pw1tV5Jurk
         G1B6vWuIB9CGKP6/uWSvWrQUOxiQTAfiGRjAt5v1APDUjRSiOed2GjiQj5oBB9AuA8bA
         MaUp9zw9reGpNP43/g0isPiFLF7XtjdNAXMuWu0/VIDIbKFwvbq63gAWPFjDzIKgsH8L
         11Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4jJW1ODjssujW7r0mvcLVnuRU8gRsnswie1vkMXHTM=;
        b=OdQS3ZjASkKjTr1OW3QVM5eNXCxoZlFYe9QiHwm76cBKjrtgb96L4n6o6apTliFGb0
         xCOG94zCes/bcLKfcCG8IleOhg9C+D0PdGzlz/02IlqmU6yplUnDjeelmpcbXzw1KNIo
         twYSYR2XFpBHD/EgNCvO6e8vWgK3w6JkoCEqm+E1leLw512U7gGigjYGATAPuQTCl84n
         gmS/gJqRpP4i4lDKrWnlLA0kJY4c9zg0MveTvjjw/l8J06kBGAJuDtCx6An9BYcWyjPY
         vUW9Oh4DM+nMd9j+ZrqJ0nxRCosRb1u2Rxn1IL9PK/5Vis5MPqzz6ZnqPoUMVMEoccln
         nL2Q==
X-Gm-Message-State: APjAAAWY13NHEpxd4rj6t+ZyxJP1OEUTq3wMu+taTarOidNXFr5uXTBV
        IN0O3u58AcKuMTF/esHTmmDoDzd7OVP9qVFnxvL13JmRxN8=
X-Google-Smtp-Source: APXvYqw7oJm7517pFYrjbVKwLvBqtDU/3tpA3ukBAmdev2AJbAzXmy7UGojnqmrwZmN2N8VwyOWwmx/0aZJarn911dY=
X-Received: by 2002:a50:aa14:: with SMTP id o20mr1238067edc.165.1562284775516;
 Thu, 04 Jul 2019 16:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <46cb79dbc4bbff3e5a4e77b548df1e92c105ed0f.1561804613.git.mchehab+samsung@kernel.org>
In-Reply-To: <46cb79dbc4bbff3e5a4e77b548df1e92c105ed0f.1561804613.git.mchehab+samsung@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 5 Jul 2019 02:59:24 +0300
Message-ID: <CA+h21hpDP+ZC4RGb73ibLu50Lh3Uo9T85gOLG3V2exTTL+ccJQ@mail.gmail.com>
Subject: Re: [PATCH] docs: packing: move it to core-api book and adjust markups
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 at 13:37, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> The packing.txt file was misplaced, as docs should be part of
> a documentation book, and not at the root dir.
>
> So, move it to the core-api directory and add to its index.
>
> Also, ensure that the file will be properly parsed and the bitmap
> ascii artwork will use a monotonic font.
>
> Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>

> ---
>  Documentation/core-api/index.rst              |  1 +
>  .../{packing.txt => core-api/packing.rst}     | 81 +++++++++++--------
>  2 files changed, 50 insertions(+), 32 deletions(-)
>  rename Documentation/{packing.txt => core-api/packing.rst} (61%)
>
> diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> index d1e5b95bf86d..aebb16d7771f 100644
> --- a/Documentation/core-api/index.rst
> +++ b/Documentation/core-api/index.rst
> @@ -25,6 +25,7 @@ Core utilities
>     librs
>     genalloc
>     errseq
> +   packing
>     printk-formats
>     circular-buffers
>     generic-radix-tree
> diff --git a/Documentation/packing.txt b/Documentation/core-api/packing.rst
> similarity index 61%
> rename from Documentation/packing.txt
> rename to Documentation/core-api/packing.rst
> index f830c98645f1..d8c341fe383e 100644
> --- a/Documentation/packing.txt
> +++ b/Documentation/core-api/packing.rst
> @@ -30,6 +30,7 @@ The solution
>  ------------
>
>  This API deals with 2 basic operations:
> +
>    - Packing a CPU-usable number into a memory buffer (with hardware
>      constraints/quirks)
>    - Unpacking a memory buffer (which has hardware constraints/quirks)
> @@ -49,10 +50,12 @@ What the examples show is where the logical bytes and bits sit.
>
>  1. Normally (no quirks), we would do it like this:
>
> -63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
> -7                       6                       5                        4
> -31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
> -3                       2                       1                        0
> +::
> +
> +  63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
> +  7                       6                       5                        4
> +  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
> +  3                       2                       1                        0
>
>  That is, the MSByte (7) of the CPU-usable u64 sits at memory offset 0, and the
>  LSByte (0) of the u64 sits at memory offset 7.
> @@ -63,10 +66,12 @@ comments as "logical" notation.
>
>  2. If QUIRK_MSB_ON_THE_RIGHT is set, we do it like this:
>
> -56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
> -7                       6                        5                       4
> -24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
> -3                       2                        1                       0
> +::

If this is not too stylistically different from the rest of the kernel
docs, the RST syntax actually allows you to do "we do it like this::"
(with the two colons coming right after the text and not on their own
line, which looks more natural). The same comment applies to the other
changes below.

> +
> +  56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
> +  7                       6                        5                       4
> +  24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
> +  3                       2                        1                       0
>
>  That is, QUIRK_MSB_ON_THE_RIGHT does not affect byte positioning, but
>  inverts bit offsets inside a byte.
> @@ -74,10 +79,12 @@ inverts bit offsets inside a byte.
>
>  3. If QUIRK_LITTLE_ENDIAN is set, we do it like this:
>
> -39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
> -4                       5                       6                       7
> -7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
> -0                       1                       2                       3
> +::
> +
> +  39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
> +  4                       5                       6                       7
> +  7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
> +  0                       1                       2                       3
>
>  Therefore, QUIRK_LITTLE_ENDIAN means that inside the memory region, every
>  byte from each 4-byte word is placed at its mirrored position compared to
> @@ -86,18 +93,22 @@ the boundary of that word.
>  4. If QUIRK_MSB_ON_THE_RIGHT and QUIRK_LITTLE_ENDIAN are both set, we do it
>     like this:
>
> -32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
> -4                       5                       6                       7
> -0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
> -0                       1                       2                       3
> +::
> +
> +  32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
> +  4                       5                       6                       7
> +  0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
> +  0                       1                       2                       3
>
>
>  5. If just QUIRK_LSW32_IS_FIRST is set, we do it like this:
>
> -31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
> -3                       2                       1                        0
> -63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
> -7                       6                       5                        4
> +::
> +
> +  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
> +  3                       2                       1                        0
> +  63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
> +  7                       6                       5                        4
>
>  In this case the 8 byte memory region is interpreted as follows: first
>  4 bytes correspond to the least significant 4-byte word, next 4 bytes to
> @@ -107,28 +118,34 @@ the more significant 4-byte word.
>  6. If QUIRK_LSW32_IS_FIRST and QUIRK_MSB_ON_THE_RIGHT are set, we do it like
>     this:
>
> -24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
> -3                       2                        1                       0
> -56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
> -7                       6                        5                       4
> +::
> +
> +  24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
> +  3                       2                        1                       0
> +  56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
> +  7                       6                        5                       4
>
>
>  7. If QUIRK_LSW32_IS_FIRST and QUIRK_LITTLE_ENDIAN are set, it looks like
>     this:
>
> -7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
> -0                       1                       2                       3
> -39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
> -4                       5                       6                       7
> +::
> +
> +  7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
> +  0                       1                       2                       3
> +  39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
> +  4                       5                       6                       7
>
>
>  8. If QUIRK_LSW32_IS_FIRST, QUIRK_LITTLE_ENDIAN and QUIRK_MSB_ON_THE_RIGHT
>     are set, it looks like this:
>
> -0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
> -0                       1                       2                       3
> -32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
> -4                       5                       6                       7
> +::
> +
> +  0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
> +  0                       1                       2                       3
> +  32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
> +  4                       5                       6                       7
>
>
>  We always think of our offsets as if there were no quirk, and we translate
> --
> 2.21.0
>
