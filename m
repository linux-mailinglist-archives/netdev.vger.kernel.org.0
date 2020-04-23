Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4D21B5436
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDWF2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbgDWF2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:28:04 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8F5C03C1AB;
        Wed, 22 Apr 2020 22:28:02 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 131so3678301lfh.11;
        Wed, 22 Apr 2020 22:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nP6aSgTb5yzHaO8mObXMRlKMAsDDiSpfhL0ooIXFKlw=;
        b=Naohu49557djEZn5IfEgr2MjBoKL2f3maHlnliH1oN9sdrPIVv0t7rpuzzNCVMv+y9
         +VuAAsjj3rqxWqDrL+ei6lWubfLmyHPPXofJGuubALH/ImYSahSsLnVV5GfmF1kkHZLo
         0Nlh9G4a00o6u8qSVEyG0KPqh8HJoIUQLftI+Zz5hQHIqZa7cjfHKMM++eWizD3AKLHO
         V1xGUhuqzX9a3osb3KtN5qxJrsWDUqPr9B29Bkl6B8twUD+dp6N9sFHckA7mldTYpOX+
         s3dF4UkVTBoVff6iXWDD+8mcg5xwBXGPT+5SMvwB9IQec6/+uaPQQEQ7AGiZz4x6dLwV
         BT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nP6aSgTb5yzHaO8mObXMRlKMAsDDiSpfhL0ooIXFKlw=;
        b=LDslZ7it9iQye2wnZipaWxZSboqldd31/wy8C6bp/4g/czCEZOaga66fiYOTR1pinj
         nEQoO6YAosO32Qi+lCxDQ+bseD7PRTJ+zFy5ggoBK1vQ8E5dO5ht35EzNFhiFvtpWN2Y
         WId8PCPsDKgdLXq8AiEaEP+HnBn+DWiiuwJfiNDsup4cEkzHD1DhR5xw+vjaefjLeveB
         cfFdehu+QuOpe/O+VCymCyRF35SZm0Vut/fzPtECCT2gsJeV/d4SDKEIcjZxl7HmU9rn
         jI/WwRfL79OIkIIniGXkZG+aUOrK0Kw+RkYJPJxm3lj2MuDVRS7CL+T5sH1iWsX5sx9I
         QwMQ==
X-Gm-Message-State: AGi0PubiMFAtK8YI/rNgUbqWHfNntGZu7xrQXaDlTK/kb8s217InhE45
        5beHJceLfZJdHRyrrZsyuzvibnljS8r1GFug9L4=
X-Google-Smtp-Source: APiQypIYBG+hTRQnJiQ0UXMlha2/XMfjfmb8PGudWn/FS2iQo2idVpMd7w16EjauFDVQp+nbTioCLDXHhFN4gu0MQww=
X-Received: by 2002:ac2:4a76:: with SMTP id q22mr1249043lfp.157.1587619681104;
 Wed, 22 Apr 2020 22:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <1587427527-29399-1-git-send-email-komachi.yoshiki@gmail.com>
In-Reply-To: <1587427527-29399-1-git-send-email-komachi.yoshiki@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:27:49 -0700
Message-ID: <CAADnVQ+_6Rkynsoqe51G-jOxOfQq54QMmzbCoZJSKe_yrufTpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf_helpers.h: Add note for building with
 vmlinux.h or linux/types.h
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 5:05 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> The following error was shown when a bpf program was compiled without
> vmlinux.h auto-generated from BTF:
>
>  # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/include/ \
>    -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
>  ...
>  In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
>  linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type name '__u64'
>  ...
>
> It seems that bpf programs are intended for being built together with
> the vmlinux.h (which will have all the __u64 and other typedefs). But
> users may mistakenly think "include <linux/types.h>" is missing
> because the vmlinux.h is not common for non-bpf developers. IMO, an
> explicit comment therefore should be added to bpf_helpers.h as this
> patch shows.
>
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>

Applied. Thanks
