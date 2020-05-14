Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F941D3DB5
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgENTjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727991AbgENTjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:39:54 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D04C061A0C;
        Thu, 14 May 2020 12:39:53 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 8so3682285lfp.4;
        Thu, 14 May 2020 12:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6KkrSjsGOVrQqPOlguAfrNoTE7xuQImXbfVmVffSvZc=;
        b=HRX+JUKoo0S14di2S6+t+MRWDg5yg0FQYE16r6I/+VXy1vwNDGOZzb+y+J4euHoSKQ
         +WGW7DL8flnFcnI6Pp2x7SwuC/sR1K/9EfCypsrXuEmXnLLfKcEvMCpUKZLby05SOKhv
         cOUd3rl2Ro9dPYQq05egEst/mZPij1nBa68WFzZg09of5jJtkxNzMKm7OtzhzKdW4vqo
         mGhWW2rDNaZEWc6YxG4Y0/kqQa++VkvuAwsebMkOtCsrTLkYCaVYtTfKZtyuthGAl+YZ
         aq4vYOdxkyNtU80uiEH/teAV24yS6Uu97dBfg7loIwHs3kRM5uB10r1zD+ExlSeyZtMA
         xPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6KkrSjsGOVrQqPOlguAfrNoTE7xuQImXbfVmVffSvZc=;
        b=TyJ2WdJi2aB/i0z9Gw1zaLlpXuAeL16RHPDtBinj0aL/7U3VtvaIsIFqoV/fpcqGKh
         89vwjR5FKbFugHWy0wdgUPcjzqbmpe6SPzlEu8jD8JIFLqaGlQ9tyHNFopYFhn5J7uzB
         HDXVQP3bgYGyEmsNwO6P4yyY4V9lsq7/n3nbLith87gNIJ9S7rF5VuKYEdkYJPmERQMz
         eSgwIFxYsxoPDbqMyQE/qNwGSUfBkNnXAmi6cuLBXcMHExjP4dSZeOYy6s1Jtz6/kL89
         zA9D1TynIZnkMJ1LO4IKC/oLRrwp/9xyP3Yxc8nlAwvPqKuxMLwl6Nvd6LrA/CpKcUOd
         TWNg==
X-Gm-Message-State: AOAM532Vx6l4ZLS7yxWdBWgNAd+lsOV0IiAZM0mpeOlqO5813HWjxOgf
        qYyz6jgQAjtJvoAtFDgOg5Advk0D5S7w/GBEYjU=
X-Google-Smtp-Source: ABdhPJyYJURPDmXeUqMb+y4SJms2zyjBrcPnrpmatbs47rDJL89qAYT/VgDywx6lpCYwbuDn3/U51WRGY+vvycMmthM=
X-Received: by 2002:a19:505c:: with SMTP id z28mr4376744lfj.174.1589485192109;
 Thu, 14 May 2020 12:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200511113234.80722-1-mcroce@redhat.com> <0dd7c40b-c80b-9149-f022-d8113b77558a@fb.com>
In-Reply-To: <0dd7c40b-c80b-9149-f022-d8113b77558a@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 12:39:38 -0700
Message-ID: <CAADnVQKtMZoULOtHzxvb=r7K4C8R4vc-zDqZD6eFDCfxgh2xYw@mail.gmail.com>
Subject: Re: [PATCH bpf] samples: bpf: fix build error
To:     Yonghong Song <yhs@fb.com>
Cc:     Matteo Croce <mcroce@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Joe Stringer <joe@ovn.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 1:32 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/11/20 4:32 AM, Matteo Croce wrote:
> > GCC 10 is very strict about symbol clash, and lwt_len_hist_user contains
> > a symbol which clashes with libbpf:
> >
> > /usr/bin/ld: samples/bpf/lwt_len_hist_user.o:(.bss+0x0): multiple definition of `bpf_log_buf'; samples/bpf/bpf_load.o:(.bss+0x8c0): first defined here
> > collect2: error: ld returned 1 exit status
> >
> > bpf_log_buf here seems to be a leftover, so removing it.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied to bpf tree. Thanks
