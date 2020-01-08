Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D96EB1339B7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 04:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgAHDpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 22:45:25 -0500
Received: from mail-il1-f169.google.com ([209.85.166.169]:38094 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgAHDpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 22:45:25 -0500
Received: by mail-il1-f169.google.com with SMTP id f5so1494883ilq.5;
        Tue, 07 Jan 2020 19:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZhEXkz/Ikgaa2TPZMXb0nNQRN/vT/dP6jXGgHVXgmxo=;
        b=Bwwo+FdjiCvyI61VjrtnVA038Ig6cGYfxYTHl2P8WBHFvLfER1gku3JN4MfBHjKZW8
         dEN4mH8UYmcSlEpR7iUzjre4aXzjrb6zIgEvncRA1ooJMNjoMSh/7Pd8hzvfmCkVNFzh
         enUuJN4fSBT0LsBsjpMFJK5Btk3oAB/IsBdpgN79fMPjV0aroMuNfCm6TS1bhwdz6eNg
         9P9gductqwL7LzXKkp63dHv34/nZhYIU+ecTqXLbESygo2KqsbAD5PcNzcBP0QKplpwR
         YlzIEE+F/h+LZzInVNA8cpa4aLkABfxcxuJ9yR2T5phfyIMB/DGZZWfuTLaMQ09flcV8
         U6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZhEXkz/Ikgaa2TPZMXb0nNQRN/vT/dP6jXGgHVXgmxo=;
        b=ktwlL+2w1Ai+BMM+F3+3q9hIpaBvNKIgSEQ7HNtLrxu97LVel212H/74jlZZQ0bbGK
         1/XyO1bfyNYCLoVcIZh9QTGfDln+2JdlBmLwEUHIFabxJxf3jj/jmsAi+YCGyhQO+4Ve
         W4jFVTAoQsHRh1kUFIr2m/WJAGjV4jMkVAn8aD1bsb2vYqCvTJ/F/5Xmh90asRIZ7td9
         7v5Vw7hM/IYImdzDWwbbzBtRyCNhlft9zNzUTG5J9tw2nToVbvC++ozfaCO0FvQbw9e5
         m32MPDKIQpN+zek39MBdgtmCXS/aULAN2gRQUoOsYHo/qTHPZDrQxeRn56wJh51heeF+
         zU9A==
X-Gm-Message-State: APjAAAUCqMKyJu7imHaQOriWcGtiU6hztQaI8AcV/iiEq9U8auoKfpE/
        uF90hmplbf92GosFjKipeO4=
X-Google-Smtp-Source: APXvYqzkdRP47LR7codGlznu8B+mG30W2DgydK83fa7ocXOyasXBFEBA74AdKTexeZLZUlaW0EtaKg==
X-Received: by 2002:a92:d84d:: with SMTP id h13mr2154105ilq.180.1578455124433;
        Tue, 07 Jan 2020 19:45:24 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s7sm518737ild.73.2020.01.07.19.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 19:45:23 -0800 (PST)
Date:   Tue, 07 Jan 2020 19:45:15 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Message-ID: <5e15504b79ddb_68832ae93d7145c063@john-XPS-13-9370.notmuch>
In-Reply-To: <87imlnht6k.fsf@toke.dk>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-8-bjorn.topel@gmail.com>
 <5e14caaaab6f7_67962afd051fc5c06f@john-XPS-13-9370.notmuch>
 <87imlnht6k.fsf@toke.dk>
Subject: RE: [PATCH bpf-next v2 7/8] xdp: remove map_to_flush and map swap
 detection
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Bj=C3=B6rn T=C3=B6pel wrote:
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> =

> >> Now that all XDP maps that can be used with bpf_redirect_map() track=
s
> >> entries to be flushed in a global fashion, there is not need to trac=
k
> >> that the map has changed and flush from xdp_do_generic_map()
> >> anymore. All entries will be flushed in xdp_do_flush_map().
> >> =

> >> This means that the map_to_flush can be removed, and the correspondi=
ng
> >> checks. Moving the flush logic to one place, xdp_do_flush_map(), giv=
e
> >> a bulking behavior and performance boost.
> >> =

> >> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> ---
> >
> > __dev_map_flush() still has rcu_read_lock/unlock() around flush_list =
by
> > this point, assuming I've followed along correctly. Can we drop those=

> > now seeing its per CPU and all list ops are per-cpu inside napi conte=
xt?
> =

> Hmm, I guess so? :)
> =

> > Two reasons to consider, with this patch dev_map_flush() is always
> > called even if the list is empty so even in TX case without redirect.=

> > But probably more important it makes the locking requirements more cl=
ear.
> > Could probably be done in a follow up patch but wanted to bring it up=
.
> =

> This series was already merged, but I'll follow up with the non-map
> redirect change. This requires a bit of refactoring anyway, so I can
> incorporate the lock removal into that...
> =

> -Toke
> =


Ah I was just catching up with email and missed itwas already applied.

I can also submit a few fixup patches no problem for the comments and thi=
s.

.John=
