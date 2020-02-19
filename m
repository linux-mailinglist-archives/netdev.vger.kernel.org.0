Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7161164AC1
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSQll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:41:41 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:45380 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 11:41:41 -0500
Received: by mail-lf1-f50.google.com with SMTP id z5so602585lfd.12;
        Wed, 19 Feb 2020 08:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xpW2s9YmRADGcXppS2FRk5Efh7WOmzPm2pmUyNxQfeQ=;
        b=dr2NYApHtpWCP6LfTVWCBXEt6GXEdtFCZ1sq8it9d4M70QzndLclem/VUm1vktQTBS
         bNTN8h4aeb1b/hJ0Qj0UeeyKhjh+YI9h3yZCs6A1QPQlfna8V3Xay7G4xP7gmX/EeD1t
         UTT6WwQ2usDL3DT6G5801VLUjI0wFfjM7/qSCITFTbKBQDUR/QTzy/EenlqYNxwheSzQ
         uDPEDt2rjXlLYdN/SgjRIi/GuWqyS2Dxdv4NpUNV/x9MP9Ro9g9IS3fHIp9u++S1LvN0
         Tw2KN92YZ7/h7ZpYzPP/9HLGNuEuTfLHutXDOwnKdM7Vb/CdP7GuqekHjoWozo3T+50g
         VnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xpW2s9YmRADGcXppS2FRk5Efh7WOmzPm2pmUyNxQfeQ=;
        b=VCgRb9QXeSEFZSxCsVPCI7TJUVX9rQPL5PizUGz7Fk570xGLMmqMNeHxsVkCfsApF3
         ofhC+l7eK5WfEkni0SGlZjHsnSlkmV7Z63IPEK5ryAMFiEJV09c2YzrSQdC7y8W0EAjb
         hdUmL5YlmZvKTbAr72XdBnt5lxS6iO6YSk3iVK5PsbJUveuiJ3DB1WI12t6H7eSWFhN1
         9svvnD0tRDz3Kl0EuomD52RsYbuTAL/jUMEj3ugGOTVMLF6vQq+R+vedRqk4VhPtJ56E
         VjZ7hBczn2OqAA727LOfMcK7w6qTTWTRni64ewFA0KFsJhOyG4L5gF7Fm1UHd8qw8Wx7
         aZOg==
X-Gm-Message-State: APjAAAX9Z2In2h9e3pYrBcb5vQkFKgmMcFCEOx0fwuvjrrtYwo7GSsmP
        tCl1WRUGZXP7lMnZmUju/Ik8vTVjyRjZaLxMvUs=
X-Google-Smtp-Source: APXvYqwPp4/AumwQc3c6Dw58j4QTP17+fn/HR+ybdvpaK6r6LPciWQp8E2+0WqLAou6rGBqtV7ghBp9cVdE0Uy7sIX4=
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr2337793lfq.157.1582130498507;
 Wed, 19 Feb 2020 08:41:38 -0800 (PST)
MIME-Version: 1.0
References: <20200219133012.7cb6ac9e@carbon>
In-Reply-To: <20200219133012.7cb6ac9e@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Feb 2020 08:41:27 -0800
Message-ID: <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> I'm willing to help out, such that we can do either version or feature
> detection, to either skip compiling specific test programs or at least
> give users a proper warning of they are using a too "old" LLVM version.
...
> progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
>         out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);

imo this is proper warning message already.
