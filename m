Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19EA17AD68
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCERi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:38:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39868 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCERi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:38:57 -0500
Received: by mail-lj1-f196.google.com with SMTP id f10so7023066ljn.6;
        Thu, 05 Mar 2020 09:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AjhdRYjDPFMTb22nPTZry4E/4CciJROpmnc6zv5X8Vg=;
        b=QjmpFRwS72p2y1jT2grAaixO/Fj7ExldbHvxqFnHIKGSN7mp6yvTg0LTjqIIv4VkKO
         +WeHfN069Od8rFuh/KQVN97gl+DSe7axo04atuXl9f3nNPKdqwsDBqrUMpoT2V8i02oJ
         MjGAgwBStoHwVRPFDWUhNYSUsc2fxLk30NSWpX8qyhTNw3DJKe/NsN+H0MngerHmysdz
         gc9BtobLIwkInmSNYyuVRObjuP6pEt2iY/14lT0IiZobgAqfvVHTaqrTnVTU9woZ7WFD
         XL29FtnZZ4By9EgqLR3pNX2T1zSNcbFPYE2VNu88hLdnvbnWXVujtgYn+zf5tih+K5nJ
         hOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AjhdRYjDPFMTb22nPTZry4E/4CciJROpmnc6zv5X8Vg=;
        b=Jhg03ol3zo4hbt5US8iK0uzRlCfkKwsW1IAnEWT0i/vr42AqXODx4+q1Y4/sUTQg4Q
         pVouh4L444sCv20uBWafL2bnOmVb+XnXOxgAK8bY03300HqI1zvlQpiChtqKzRl5cKBG
         ty6PAYcyI97+tCENqdAuUYJwYZKGNV23F19Hl7v8UVFPQhZMyr36WuN7/NmTka85Ukyr
         JpXIGGP4Hjw+kmQGzqACfK/2tju0WOHgQCK1DYDO7mBy1OoaWLciHLDOq77fGK+jI2Qo
         rzkvAneHFMf7uPDvA/R5CUgpIOyWJoBaXjEOTd4knxHV4QMVvuzMmnOZyl5o+7VZ9U0X
         UhkQ==
X-Gm-Message-State: ANhLgQ0EgScrLtixEzC3APjZm87hSr/9ruFKFN79VfY66tZvpqapqhwS
        DmcqC1Q52ntHYAyurFbJ8bxJuwhuhqc3dYDKp3U=
X-Google-Smtp-Source: ADFU+vtXBGwHlMSdbyhPktHbkhplsEt4jfLLEKNjPpDTwBv5BGuitJHDawiTWbUYw94VLKGibffNlVaOONDOSHX362Y=
X-Received: by 2002:a2e:760f:: with SMTP id r15mr6128149ljc.234.1583429933466;
 Thu, 05 Mar 2020 09:38:53 -0800 (PST)
MIME-Version: 1.0
References: <20200305175528.5b3ccc09@canb.auug.org.au> <715919f5-e256-fbd1-44ff-8934bda78a71@infradead.org>
 <CAADnVQ+TYiVu+Ksstj4LmYa=+UPwbv-dv-tscRaKn_0FcpstBg@mail.gmail.com>
 <CACYkzJ4ks6VgxeGpJApvqJdx6Q-8PZwk-r=q4ySWsDBDy1jp+g@mail.gmail.com> <CACYkzJ5_8yQV2JPHFz_ZE0vYdASmrAes3Boy_sjbicX6LuiORw@mail.gmail.com>
In-Reply-To: <CACYkzJ5_8yQV2JPHFz_ZE0vYdASmrAes3Boy_sjbicX6LuiORw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 5 Mar 2020 09:38:42 -0800
Message-ID: <CAADnVQ+K4Vc2_=tB7COFFBy3uswike-TERoSF=1=GdnWFDUutQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 5 (bpf_trace)
To:     KP Singh <kpsingh@chromium.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 9:32 AM KP Singh <kpsingh@chromium.org> wrote:
>
> This fails as we added bpf_test_run_tracing in net/bpf/test_run.c
> which gets built only CONFIG_NET is enabled. Which, this particular
> config, disables.
>
> Alexei, if it's okay with you. I can send a patch that separates the
> tracing test code into kernel/bpf/test_run_trace.c which depends
> only on CONFIG_BPF_SYSCALL.

In such situation we typically add __weak dummy call.
May be split will work too.
or move tracing_prog_ops to kernel/bpf/core.c ?
