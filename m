Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07210F2BC
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 23:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLBWPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 17:15:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44162 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfLBWPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 17:15:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id az9so621256plb.11
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 14:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NhXX3I1UlqvZdQq8+fgCGGfKkFSrcYd+r8H30a1bOCs=;
        b=xBPpkjXI8u1WpYOXZw96OJLU8A84/4scxd+32jXsqBw9SDCMGgQUUSIrCWQw8RYpxC
         Af/PwEc92MVgwEJb4lIMh7iOKKStr0rjLqGbuC3JTkSzf+7A9I6oL13CKnO6EXv3gVIS
         UtVHAnch3GCA8LNGzkp76ZF94ubybtdzBCoT2frtTMOdjDW5chgrS5kfibeaOx0IKmQX
         OUdcLgWaZgxStH3JFYJivnLFwRt3q3RPnKY06n2zme218YFFy+PeLqm8YCV9ednPk419
         0np5fxiZIA32H37nSHwsAeuZfnAP+xSF0WBFFtyjgkZ1apppncSdwFbSdHUCLztEI/73
         jPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NhXX3I1UlqvZdQq8+fgCGGfKkFSrcYd+r8H30a1bOCs=;
        b=MUfBX9XzPQNYzVkeF2w/Gbwp1ngJKyYJl9FTqCt0vvg69v61/zSfY2EKyKSlbws3a3
         v2nS7cl/toMVKJkrf0Ibwac0tA8oRIimUPEXI7gKuhXFdfCu3kQsStE1DYOoiGH/nYM1
         RYpQ6BNTq9V0wDk+5XR8WlLXW93D0zweRn9kb1gh4GmX+1hgMopIn6wEkezAuQ4/x/am
         96jkbhCcrxqjO1zo4xzrFPaoGBvSyWt0LIRiTXNVhj+rDY8AbLZeHu35s0twqCkjEcxm
         7HEPdkTFqpF/IVcYdFnrsTlHMwvWUdyyAgfndw0/7B27g/lbLOynAK51PV2QRwvPFV8E
         bW/A==
X-Gm-Message-State: APjAAAU0XzV8D/Ua/0LHPuTdWDRJu8HmVn8SbcUQmZofqSAyDtJ07Maw
        Tv8WP2cvmJ6YPTw6mw94o23SqA==
X-Google-Smtp-Source: APXvYqx6oI6+VcmQyEBQIV5AE1EznqUclyUDPFU8yQ8VOnEH2bFjVbO/806HRDztwEu7NN1vTPE4Fw==
X-Received: by 2002:a17:902:6bc7:: with SMTP id m7mr1389404plt.341.1575324932557;
        Mon, 02 Dec 2019 14:15:32 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f81sm493477pfa.118.2019.12.02.14.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 14:15:31 -0800 (PST)
Date:   Mon, 2 Dec 2019 14:15:31 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] selftests/bpf: bring back c++ include/link test
Message-ID: <20191202221531.GB202854@mini-arch>
References: <20191202202112.167120-1-sdf@google.com>
 <CAEf4BzZGOSAFU-75hymmv2pThs_WJd+o25zFO0q4XQ=mWpYgZA@mail.gmail.com>
 <20191202214935.GA202854@mini-arch>
 <CAEf4BzYzY2WsiDoGokeo9AjmYfnrAhEn0YhTeQV6Gt-53WhR4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYzY2WsiDoGokeo9AjmYfnrAhEn0YhTeQV6Gt-53WhR4A@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02, Andrii Nakryiko wrote:
> On Mon, Dec 2, 2019 at 1:49 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 12/02, Andrii Nakryiko wrote:
> > > On Mon, Dec 2, 2019 at 12:28 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > +# Make sure we are able to include and link libbpf against c++.
> > > > +$(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
> > > > +       $(CXX) $(CFLAGS) $^ -lelf -o $@
> > >
> > > let's use $(LDLIBS) instead here
> > Sure, I'll send a v2 with $(LDLIBS); it might be worth doing for
> > consistency.
> >
> > Just curious: any particular reason you want to do it?
> > (looking it tools/build/features, I don't see any possible -lelf
> > cross-dependency)
> 
> The main reason is that I'd like to only have one (at least one per
> Makefile) place where we specify expected library dependencies. In my
> extern libbpf change I was adding explicit dependency on zlib, for
> instance, and having to grep for -lxxx to see where I should add -lz
> is error-prone and annoying. Nothing beyond that.
Makes sense, agreed.
