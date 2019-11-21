Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19213104F21
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKUJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:23:44 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44155 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:23:43 -0500
Received: by mail-qt1-f193.google.com with SMTP id o11so2888074qtr.11;
        Thu, 21 Nov 2019 01:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=on4Iq+B2dQHBEVKEbGkwbSWsSiyy1vP9STHLN/cESR4=;
        b=MOh+jfGVqxBNt21EOqrv0VJGgMyEqU6fBzYFgasfzGY5KMLq3ck3Sz+iIg8T5+S1RF
         uWUwORfX32CKmSv+62i3kv/+V+iCsfcFzWU6/B32zNqRao6A7ysQ2jXIzBucRgCqnK9B
         ysHx5sK19D3JL9TodKN9zNYWnxteF7eKVwBd0BhtNAOsNc32cPDL68CFct+41nueLcON
         p5/9CFpC/Mq9nfM7b8ljDnEKJXSIAos11bK53zRokhLHTdfGNtSmsDwSZSQCNDmT6VQx
         uZeRBnHKL13jimMBwXCPwUPWOZRxyQJwzSShjFfRkR8hmmg1rdjH0cTd3OtLHmrMUphx
         XODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=on4Iq+B2dQHBEVKEbGkwbSWsSiyy1vP9STHLN/cESR4=;
        b=Nh2dYErp5Wa/sRhw6/JAIK3sCDn1X0EYWuK8Q1yXn5ZmEs0da2ij0FFR4IyG0tSRmG
         ieXt4i4ddjfQOsDoqD16I74/la8mQ8DCEK+qu5Mom00Ag9I9r0RVnfYLFF4JXOW+/bv6
         BE80H7SmdvMsIrgdeAqw2D8FomrgDQKqYJvNwPVo5I3IYvnvyj21mLi/ym09gl0GkddD
         6iKZLzNILYxSbEIgGbaFXKsdYLFsyBqfcIGcYnJp3O9y+Phc0K3B3zgXfs487O4FSta9
         G1dzlyn+tLLmXLCN0ZIEcUjSGIDY+7mVmx6mIZdxnN4C2Hm5Cut+HqNUYJNCwgY2/W0T
         pyZQ==
X-Gm-Message-State: APjAAAWbw417QziUu0X0JY4kWKhPRQAg8dL5LLzInF57Ra18HLfPNLuV
        txMYf3g2FCeN/PoAslatA0nnzYlZp5m0kKY2IDY=
X-Google-Smtp-Source: APXvYqzZ8nnA+s0cPCCjLmUa/bYFlF2jPnOot3ZoQt0rjsMtlfv0YKp0l6uuj0DIdt2GWoktQtu/xtq5b6rmZQr9QyA=
X-Received: by 2002:ac8:4517:: with SMTP id q23mr7581464qtn.359.1574328222931;
 Thu, 21 Nov 2019 01:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20191119160757.27714-2-bjorn.topel@gmail.com> <201911211536.JzaBr1Ub%lkp@intel.com>
In-Reply-To: <201911211536.JzaBr1Ub%lkp@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 21 Nov 2019 10:23:31 +0100
Message-ID: <CAJ+HfNiq4QhHbO5reVKC7n95unqVWHSRnX0-+HoqdHb3iXoUbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce BPF dispatcher
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 at 08:27, kbuild test robot <lkp@intel.com> wrote:
>
[...]
> >> kernel/bpf/dispatcher.c:151:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>        *ipsp++ = (s64)d->progs[i]->bpf_func;
>                  ^

I'll fix the cast warning on i386 in the v2.
