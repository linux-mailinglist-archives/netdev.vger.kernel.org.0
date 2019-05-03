Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE68A1342F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 21:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfECTyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 15:54:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45520 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECTyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 15:54:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id t1so7411498qtc.12;
        Fri, 03 May 2019 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dcNO8H4JVaKlLHehIOVLfbJ0MseX0TEZi3YtkHapVeE=;
        b=OkMBUfw4i6GE6tlDtd15zhYU/IhCdb4FiDnpBVGpv8Tf+oElh+7N+XWPiXi6s+byNO
         2k0+WanD9//PW9OjgMqnKODOiY0nzdWjiSMoV/b8aks3zBzAkv/uQSr0lH1lrnCLZYn3
         R6xP3DV/YgxGx/03hj3lzQovCtT4IeQQl7p7zGzP2CIfo/XDHmaNHIYd9r5a6pFecN5g
         1dh23b7knP32tcZURwiN7+ZhjvdizxxbB7E4LG4AxSP6bz6EKmEGSDTqgw0hQF+YtnV0
         oYpOvog98lwAiy+AjwxYYc5JIBv+sWWaUT6uDuvKyGkPKaUXQ8sMH8B3BZL8FbHX1mVs
         S3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dcNO8H4JVaKlLHehIOVLfbJ0MseX0TEZi3YtkHapVeE=;
        b=diMDEZ3L2C5fPsPal6Ar8WDV//d/33eh70OTrx80iBwzGxU5GCcmTN3iEIiguG1EYn
         xxKivbDOJMqQokCVHxwhbWyeHE5ZEg6tazGijvSTYHNwSG4nJFBgtkI/xVYhasSRocce
         34MuqB9sBtHLNoguyWYmZ0lLSJWzN7IrA0bWwxO0FxR1CrNWOzsFOv4ZTWtfAs6Yc+f5
         3D0QQfiozLoFzJ7vZiPT4aaZfWbFyhRaMkh/erdnc/kXWh1jmQ/+9ktQodIntTGbHxFc
         lQoJxMOWT7aCWpeZ0v7fLsm08Wk6wpH282M9Qw296yT87Z6iEP0PzIx2HRxdSS1l599I
         iQDw==
X-Gm-Message-State: APjAAAUDjpFctetixvuHWanVaIVYFjVcQZqzZ4mATiCV654hT9E16Anm
        sjy/OY6IWutqE7p17nlsZFyM7WW14YNYgag8bVk=
X-Google-Smtp-Source: APXvYqwYZLwRtRGf79qzGB2xP1Xx0iaBKEVGsRmDg/udzzTcKOtpgbrWBfe0qwpaz2izHyQDCocu9k/jn3t51iZ0jQc=
X-Received: by 2002:a0c:881c:: with SMTP id 28mr9472135qvl.150.1556913250225;
 Fri, 03 May 2019 12:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <1556822018-75282-1-git-send-email-u9012063@gmail.com> <CAH3MdRVLVugbJbD4_u2bYjqitC4xFL_j8GoHUTBN77Tm9Dy3Ew@mail.gmail.com>
In-Reply-To: <CAH3MdRVLVugbJbD4_u2bYjqitC4xFL_j8GoHUTBN77Tm9Dy3Ew@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 3 May 2019 12:53:33 -0700
Message-ID: <CALDO+SZtusQ3Zw4jT6BEgGV7poiwSwZDuhghO+6y53RBA0Mg1A@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: add libbpf_util.h to header install.
To:     Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 1:18 PM Y Song <ys114321@gmail.com> wrote:
>
> On Thu, May 2, 2019 at 11:34 AM William Tu <u9012063@gmail.com> wrote:
> >
> > The libbpf_util.h is used by xsk.h, so add it to
> > the install headers.
>
> Can we try to change code a little bit to avoid exposing libbpf_util.h?
> Originally libbpf_util.h is considered as libbpf internal.
> I am not strongly against this patch. But would really like to see
> whether we have an alternative not exposing libbpf_util.h.
>

The commit b7e3a28019c92ff ("libbpf: remove dependency on barrier.h in xsk.h")
adds the dependency of libbpf_util.h to xsk.h.
How about we move the libbpf_smp_* into the xsk.h, since they are
used only by xsk.h.

Regards,
William

> >
> > Reported-by: Ben Pfaff <blp@ovn.org>
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > ---
> >  tools/lib/bpf/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index c6c06bc6683c..f91639bf5650 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -230,6 +230,7 @@ install_headers:
> >                 $(call do_install,bpf.h,$(prefix)/include/bpf,644); \
> >                 $(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
> >                 $(call do_install,btf.h,$(prefix)/include/bpf,644); \
> > +               $(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
> >                 $(call do_install,xsk.h,$(prefix)/include/bpf,644);
> >
> >  install_pkgconfig: $(PC_FILE)
> > --
> > 2.7.4
> >
