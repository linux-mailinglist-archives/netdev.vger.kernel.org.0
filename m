Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF155AA45
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 12:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfF2Kmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 06:42:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbfF2Kmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 06:42:32 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5TAfb96058590
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 06:42:31 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2te451300c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 06:42:30 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <rppt@linux.ibm.com>;
        Sat, 29 Jun 2019 11:42:28 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 29 Jun 2019 11:42:24 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5TAgC7X33685958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Jun 2019 10:42:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10C5152050;
        Sat, 29 Jun 2019 10:42:23 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.207.49])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8D1F45204E;
        Sat, 29 Jun 2019 10:42:19 +0000 (GMT)
Date:   Sat, 29 Jun 2019 13:42:16 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] docs: packing: move it to core-api book and adjust
 markups
References: <46cb79dbc4bbff3e5a4e77b548df1e92c105ed0f.1561804613.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46cb79dbc4bbff3e5a4e77b548df1e92c105ed0f.1561804613.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19062910-0008-0000-0000-000002F84129
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062910-0009-0000-0000-0000226580EC
Message-Id: <20190629104215.GA20154@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906290135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 07:37:02AM -0300, Mauro Carvalho Chehab wrote:
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

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

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

-- 
Sincerely yours,
Mike.

