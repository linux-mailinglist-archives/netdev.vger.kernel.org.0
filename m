Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89F4DFF2
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 07:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfFUFIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 01:08:35 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:43171 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfFUFIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 01:08:35 -0400
Received: by mail-qt1-f169.google.com with SMTP id w17so5660119qto.10;
        Thu, 20 Jun 2019 22:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOVcUfjro0B1EBFw/TjIy6+vaPZDLFKcKq4KPAmbAAM=;
        b=pwD5NDAWGXsG6Iip6JaL43m80Z3cqDRGGqvo7BF79maNKFQ0yMy95WGpHeEE/7QAMd
         G+l4a5UFZjyRFHeTbORCs1/za7ZCYmTN8VabBrz15pFMqO6sVF2xEtfgxKvLPh3d08KL
         ffxtN7xHWi2AWLyJdKy5ZRXmQamHQZbRw1PzwPxaiAn+uAr2j4AdsGjHIf2g2xqePoXa
         8PMlw37chmJT9KJ5nCu4Kh39gIpegMfjdgqAvNFuLF/Efkc7iaoBGIbw7fnqjAqPX6XT
         x0pIb8P9BFZaXVIx1M+AvUZb5BEYUi/Vf031O2F9pyOrjrn98QFdPNHluYBSMhHHF1aU
         ol2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOVcUfjro0B1EBFw/TjIy6+vaPZDLFKcKq4KPAmbAAM=;
        b=Ks1HRSW1KsCfaLhaI8dPSQPEZuwg9D4tEUsIoCwYYeBQlcd86WGjczrlg+8MMmKozN
         iUiApuxKikb/BBRvQ6tKCm2HK+fwVkOd/NEe63Avf9P7hPFRSU72XhhwviFjs612eM5I
         6xm1J6a2N5ify0dj1rRhUfngj0l8WLPCd+cJGK11R2y8o4ErXm/Ng0NgFLoJgqMdIrwl
         laUjsjtCeBBsIG1rQn94I6Ac7+TEm/3KhG9AjF47R8K4ZdJR8LbaKLkbYMVdQVVv3zQQ
         l9mz29++lv2OOQgVm79oz6dPtcaE2RPLjv6LtSi+TpXmmSpZ3QlITBUdl5bz/AlTG7ia
         O7ng==
X-Gm-Message-State: APjAAAX5bauFnZNFM80m7RzIJSJTJL3hCe/I+5539W4FHUnrYu51sYjW
        ddjdCrH1pM5DWKeJl1yao3l4Bt9y4iDqpq0LqIc=
X-Google-Smtp-Source: APXvYqytyn0o9xW8GexrQp3Lf/WU3HaUXb82Dt0xusrOIWa6KSqDzElqHeK5FRTgTkOoBRhecco/A2uoc0RK9oQQr+w=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr89675282qta.93.1561093713587;
 Thu, 20 Jun 2019 22:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162742.985-1-colin.king@canonical.com>
In-Reply-To: <20190619162742.985-1-colin.king@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 22:08:22 -0700
Message-ID: <CAEf4BzZhg0uJtPecF8t5MfXF=V7ycDrcB1RNXDNtjuFmvuAmCw@mail.gmail.com>
Subject: Re: [PATCH][next] libbpf: fix spelling mistake "conflictling" -> "conflicting"
To:     Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 9:28 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There are several spelling mistakes in pr_warning messages. Fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Oh, the beauty of copy/pasting same typo 4 times :)

Thanks for fixing! Can you please re-submit with [PATCH bpf-next]
subject prefix, as it's intended for bpf-next tree. With that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

<snip>
