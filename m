Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4C28B1F3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfHMIDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:03:07 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39067 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfHMIDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:03:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id b1so1071664otp.6;
        Tue, 13 Aug 2019 01:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xpTjmXViSqIki2Cb2qHpkfQ62APVJj7AGYZMRIsoCJ8=;
        b=AYFA0Q48dX8onM7zG1H8BuQOm2zh/w79ApEK6ezu93//mTeriuACrbmOrAUH4FTlRE
         grdX+HbfBfjYQM3DPrOGRw5HZpIEFcrBB4mLP0Jn2ue/W+RdzBXlYtDl8eajDOiUjZzl
         S2BStp2whwPW/DdQ4FqQUVOn+d5agQUeEAKJdzy9A53jzAmj72y2/7DlBvubA+K6cLUV
         W30iWaGSFvtDIrjrU7ZmVTy19Evq518Xe1klm+es+rjpGJYW2VXkgFkqPCQOBJFJlWAY
         +IgfLW8ged01WvOmEibmynVe5lN8t6yD1am79qSRamNXI0x6/2qQBD0WzzuN/iPgWlhf
         QPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xpTjmXViSqIki2Cb2qHpkfQ62APVJj7AGYZMRIsoCJ8=;
        b=KjApIHuXb/AyCeiXN7/OxPhmZPuJfOXgl/QQS3ci5G9FkSsfCGaFH/N1KkzCr2suv8
         1G7/jRWHeJ/zsKMizL57W22co+gXyZqcPWVz1ytk3uox1pr6amNUpK9VDmPjVafKYpFY
         1/gWyBnRrpm6ctMLcPa0GJ/yOBfLptue0KJM6vVedtHoV38gIi/EIQjLtYAytEb+bRQd
         ZjHS51IV0/u/t9zfBjff5ERM1fG5A9EZyWdHkio8FFWi1edfh6xrKs64c0x61dh2jBKz
         I1aBPE33YzaqrBZjrExts6GBU3JU2N5ftqGGgWdhFaCMK3S3aU4UnNsUwcu6wmFFG7Zl
         R+tA==
X-Gm-Message-State: APjAAAXEPlNfB2L3JnG1z3l6QuxwWzdw+ft9/lCYbPufyPLlw+POepSz
        44INt5VNEkhm9xTSQpl9Z+Pb/HDaM7jCS4q/wxc=
X-Google-Smtp-Source: APXvYqzzSJbUR/V1lvk2p/n+pBFYlV3r4RaXqZ8riQxviItgG2T6vtN6lVbqJgCVjr/mfYonAVDHl6acFGgXOfajAzU=
X-Received: by 2002:aca:fcc4:: with SMTP id a187mr619358oii.126.1565683385526;
 Tue, 13 Aug 2019 01:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org> <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 13 Aug 2019 10:02:54 +0200
Message-ID: <CAJ8uoz0bBhdQSocQz8Y9tvrGCsCE9TDf3m1u6=sL4Eo5tZ17YQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        linux-mm@kvack.org, Xdp <xdp-newbies@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Alexei Starovoitov <ast@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 2:45 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
> established already and are part of configuration interface.
>
> But for 32-bit systems, while AF_XDP socket configuration, the values
> are to large to pass maximum allowed file size verification.
> The offsets can be tuned ofc, but instead of changing existent
> interface - extend max allowed file size for sockets.

Can you use mmap2() instead that takes a larger offset (2^44) even on
32-bit systems?

/Magnus

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>
> Based on bpf-next/master
>
> v2..v1:
>         removed not necessarily #ifdev as ULL and UL for 64 has same size
>
>  mm/mmap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7e8c3e8ae75f..578f52812361 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1358,6 +1358,9 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
>         if (S_ISBLK(inode->i_mode))
>                 return MAX_LFS_FILESIZE;
>
> +       if (S_ISSOCK(inode->i_mode))
> +               return MAX_LFS_FILESIZE;
> +
>         /* Special "we do even unsigned file positions" case */
>         if (file->f_mode & FMODE_UNSIGNED_OFFSET)
>                 return 0;
> --
> 2.17.1
>
