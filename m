Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E7311C02
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 08:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBFHrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 02:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFHrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 02:47:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2102BC06174A;
        Fri,  5 Feb 2021 23:47:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v15so10326415wrx.4;
        Fri, 05 Feb 2021 23:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8nbbx+2BPpOusI9WdJ1gNR0JQRp9V4wdi++84RYc1q0=;
        b=hdAaw9ecKAbPrqZDbgx7RoCEPmIuju8UeNUT6H7sis7doWYMdZjAmzAFsA7qrRY9cn
         acwIVe1OrKnkkUIziPduC9O9ja2VcVpDz/tRxJBf8boM3WIiy4bHWvXdb0oNSluNZj5r
         95/qP+iETy50rYo94wWiERfRKyxgz6vwGCdhz6NARPVHtpbJ9SeixbrG9pgPfONvpy//
         4oTfsBB0h0IjJf7jJnRslOPX17/e+9gSQfCcclfua8VbIqapLqOf94owdS8U63/wFZz+
         StX6ksavDDUuHpmxlvsHjzzlMg5V/TF0Hbs4vKWntVsIFX+k6kASXUDJ15eC73Xo32eD
         JAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8nbbx+2BPpOusI9WdJ1gNR0JQRp9V4wdi++84RYc1q0=;
        b=FXuwtXMa7TaoRgrSsuuh1qE7fKOM44/OSQsWZg/eUZCwU9iECsRGprkxtfvfRZ2AHJ
         0kub9q3yPyhrEs9eXe3f2m8xy7TYH9eJNp6C4Ka3ZPUy1cU5dV0FJcysOc1NgTx4ntFQ
         FFjw1adwSox2iNHkPqkrC7xiRTElygF0Q9JjU8nC8+qa0ffdMtcftU9E86wgzRlhrUBw
         rZ89XnRgO396G1I77VpseYyY12RHQYfBOfGVxFANVr9XLUrvnP8rZI5byZ36Daf5+Cfj
         +oT2qt73HwDMT/zRHdHYA1XVdCxRU36rMCU+uR1TDyS271Mk0Q9bEYXcO6Z3rpwxr5op
         kDLw==
X-Gm-Message-State: AOAM532U3pd9/XQHTqHuXiFnM8FhUfg6yProze3AApFHlFE/Y0WU4xtg
        klxxZTJpKZ+6FHDUcuSgWkkvTSvAHA+6LP5ZL6c=
X-Google-Smtp-Source: ABdhPJzh7y1I1nDbBMMNpxZNQaVpI1H0gv0nT0MNTDIHEHj7mB3mfsY2hRWHwa47CugLuO1Md6xqhaNSSxavwkZDNVU=
X-Received: by 2002:a5d:60c2:: with SMTP id x2mr9336975wrt.248.1612597627691;
 Fri, 05 Feb 2021 23:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20210205170950.145042-1-bjorn.topel@gmail.com>
 <CALDO+SZhgSr5haWT=c1b-+WMpeaPGkDYoxCoWtTaX2+L85WEJA@mail.gmail.com> <b186bc7e-2b0b-58b8-065e-c77255b6aecb@infradead.org>
In-Reply-To: <b186bc7e-2b0b-58b8-065e-c77255b6aecb@infradead.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 6 Feb 2021 08:46:55 +0100
Message-ID: <CAJ+HfNgRQ1do=tXhHOia2KdQQ-08CYduXcgdvT6o1XcL--+_yA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: use bash instead of sh in test_xdp_redirect.sh
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     William Tu <u9012063@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 at 18:39, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 2/5/21 9:30 AM, William Tu wrote:
> > On Fri, Feb 5, 2021 at 9:09 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> >>
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> The test_xdp_redirect.sh script uses some bash-features, such as
> >> '&>'. On systems that use dash as the sh implementation this will not
> >> work as intended. Change the shebang to use bash instead.
>
> Hi,
> In general we (kernel, maybe not bpf) try to move away from bash to a mor=
e
> "standard" sh shell, so things like "&>" would be converted to ">file 2>&=
1"
> or whatever is needed.
>

Ok! I'll respin!

Bj=C3=B6rn
