Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD813E0F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfEEHJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:09:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37505 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEHJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:09:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id 132so754639ljj.4;
        Sun, 05 May 2019 00:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86IsQ+1TRa/YdfouMkqY9bv+eAp/uRNAqHVCsOKSrp4=;
        b=QxwKXpdN++ecfvXUpfHSB1QVzKs1swGJa53VWUqgjbx9fDCGJSmXRakStR5VfjtCw9
         gmDBxlBTorHgu6OdcRi9bLAN3Za2XwTbFXUb10K4bcYnSR/eHIGGIVnkVKQjxareVkrj
         ZOoKcSGjfUMqfFK+ODUeDGav821oOULUSN2OaOM+BrnamtR276iNK/b0/u2McMn18Fpm
         lykfV/bXOxNwi+6hd+75f1tXNpHqxef+qdNPkX+q9IWGEx1gVoO+SzuOff0deqEwGmyT
         gwoOl1XYCpoQOauoZC8qkFpITxH0almPIfSY5fWKp9qXXnp0NDVb5wqKcsXqds5EM3Xb
         KyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86IsQ+1TRa/YdfouMkqY9bv+eAp/uRNAqHVCsOKSrp4=;
        b=J1zhg9jdeouHSxNQ5n1z2qKYirpzzC3N88si/MgdjbxX/cO3itYLWocXdhJEYXhTTG
         SWUZatH6jDsf2V323X2xqAtGnup6y6uckOXDJI2SfW10DFQbznexFlcFPWEDCpUp/PVj
         Y5PvwGpf9wfAlCknBN0646iAFW93G5Chz7VFU5TQWsa0quDnKiKfdUMUUie4hugZ163h
         jXw8o/c6gNSasVsdkAxShHORcff98/tqE7Z5fVccwq2u28FwDxwElQf1etolkCzhhBHX
         IwNqe2rsqfdDrjqucQqMOWfiAsxthOpUTSutAk2cQO2TvPVgWnv+L/1JonacPmuDT3t+
         fi6A==
X-Gm-Message-State: APjAAAVZZrrRTJE5wwdN3iioxwnhWgTz17yrAutFKRQ9UAXeH2uCD/uN
        3yYzimvoQr0RD77FPZDfbKogWiD9BsNBCBygLss=
X-Google-Smtp-Source: APXvYqysrKkIELd8DvfO/xkzE+RHeYqEM0TC5nrEGX0ypY36I52XhmAjWU+BSJO0NE9OZwRO/1sHK/IekvoB86v6nEo=
X-Received: by 2002:a2e:84ce:: with SMTP id q14mr10290667ljh.80.1557040145788;
 Sun, 05 May 2019 00:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <1556822018-75282-1-git-send-email-u9012063@gmail.com>
 <CAH3MdRVLVugbJbD4_u2bYjqitC4xFL_j8GoHUTBN77Tm9Dy3Ew@mail.gmail.com>
 <CALDO+SZtusQ3Zw4jT6BEgGV7poiwSwZDuhghO+6y53RBA0Mg1A@mail.gmail.com> <CAH3MdRX2KVqC4NRyeSVgY4mxRD6X6EzVB-_h_rp_Dv6LMJe67g@mail.gmail.com>
In-Reply-To: <CAH3MdRX2KVqC4NRyeSVgY4mxRD6X6EzVB-_h_rp_Dv6LMJe67g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 5 May 2019 00:08:54 -0700
Message-ID: <CAADnVQJszk_14Pc8tGdEaz-+eGayOVZTz8qFutX-10w7OyUzjQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: add libbpf_util.h to header install.
To:     Y Song <ys114321@gmail.com>
Cc:     William Tu <u9012063@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 2:09 PM Y Song <ys114321@gmail.com> wrote:
>
> On Fri, May 3, 2019 at 12:54 PM William Tu <u9012063@gmail.com> wrote:
> >
> > On Thu, May 2, 2019 at 1:18 PM Y Song <ys114321@gmail.com> wrote:
> > >
> > > On Thu, May 2, 2019 at 11:34 AM William Tu <u9012063@gmail.com> wrote:
> > > >
> > > > The libbpf_util.h is used by xsk.h, so add it to
> > > > the install headers.
> > >
> > > Can we try to change code a little bit to avoid exposing libbpf_util.h?
> > > Originally libbpf_util.h is considered as libbpf internal.
> > > I am not strongly against this patch. But would really like to see
> > > whether we have an alternative not exposing libbpf_util.h.
> > >
> >
> > The commit b7e3a28019c92ff ("libbpf: remove dependency on barrier.h in xsk.h")
> > adds the dependency of libbpf_util.h to xsk.h.
> > How about we move the libbpf_smp_* into the xsk.h, since they are
> > used only by xsk.h.
>
> Okay. Looks like the libbpf_smp_* is used in some static inline functions
> which are also API functions.
>
> Probably having libbpf_smp_* in libbpf_util.h is a better choice as these
> primitives can be used by other .c files in tools/lib/bpf.
>
> On the other hand, exposing macros pr_warning(), pr_info() and
> pr_debug() may not
> be a bad thing as user can use them with the same debug level used by
> libbpf itself.
>
> Ack your original patch:
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
