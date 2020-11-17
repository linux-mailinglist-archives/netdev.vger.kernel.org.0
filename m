Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526B2B57FB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKQDiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgKQDiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:38:22 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AB9C0613CF;
        Mon, 16 Nov 2020 19:38:20 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id n5so17326490ile.7;
        Mon, 16 Nov 2020 19:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Yue+oGyk3PAnj2SUaXwlEbRxJd0lTE7ieGCNqEqHCo=;
        b=czQEZP3IcAYK1tW9o9aSwo4g4YVxhiz7WhVUDPwjAgraQFDlpYFn2lAj/yBsTxgVmo
         Qy+nthGkf9Ye7jVm6QVSPKu4U0iEcdhm79FV+TltVzcd5Owcld3wrHszNZ9aJsdY5bUg
         YN/sADkC2sc+g83zF7zz6S0nlLcGEuOGh8XRzbMCPAK+Y4RLb/OYSkyVZoOfKFtq6QLu
         eiDAclQHlM/7mqvkMYnW0bAUUqJZfucJbXrQTmVhkHhOp8mjDjrw1POxuf6zeMoVqqOE
         oyNSQWl/mXLvlK4WKmahMjligNGe+a94rso/6ciObGfFXZD7l4j5Xefz/Dg4fwg6XVCz
         9+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Yue+oGyk3PAnj2SUaXwlEbRxJd0lTE7ieGCNqEqHCo=;
        b=Uor448qQzF6IIFu2IaYjxW+6n54Vjoz5NPKITcRpkeopQQzLDOGd61ncK4E78NswIK
         aYdJ3Dqda12kmhICcocoZa7/+u0Q0Z40dxT3av4LhLhN5l/D3N2faYac632YZmNeo2sI
         DIH1MkqNVhuOPpMur3G5bHvAv/WPRxi0IJYBAN2DB7LCG7hq8GGowpudMDJQm1mhps9G
         +YLup19lRrOmNeBHSRAOgP7CPlGsSw0mng4BzyexEFUq+jn4f8Gydw+Ss7q4Oq9+zCvm
         NiSifomAAD+Jgdg3wBUwQ3+2Gx6KTIb4i4YO87BeVIaBgWTDtkhamop6CDkb4t60Yntj
         Ab8Q==
X-Gm-Message-State: AOAM5334mr8o5TaS6k/xduadGeR/YwHaKBFXdcR6xlkY7RS9358n5n5X
        4wDtSxZyNZODX0Zyu/kK8ks=
X-Google-Smtp-Source: ABdhPJwvj2bOWz90iajFuqI/gSHYeiY6CfD8e3zInbTFS1BtXd9JPot5QdkkZ3++B9LBjzUn6xCtqQ==
X-Received: by 2002:a92:9ad5:: with SMTP id c82mr11420044ill.225.1605584299943;
        Mon, 16 Nov 2020 19:38:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id z82sm7688605iof.26.2020.11.16.19.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 19:38:19 -0800 (PST)
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62d26815-60f8-ca9f-bdbf-d75070935f1d@gmail.com>
Date:   Mon, 16 Nov 2020 20:38:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116155446.16fe46cf@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 7:54 AM, Jesper Dangaard Brouer wrote:
> When compiled against dynamic libbpf, then I would use 'ldd' command to
> see what libbpf lib version is used.  When compiled/linked statically
> against a custom libbpf version (already supported via LIBBPF_DIR) then
> *I* think is difficult to figure out that version of libbpf I'm using.
> Could we add the libbpf version info in 'tc -V', as then it would
> remove one of my concerns with static linking.

Adding libbpf version to 'tc -V' and 'ip -V' seems reasonable.

As for the bigger problem, trying to force user space components to
constantly chase latest and greatest S/W versions is not the right answer.

The crux of the problem here is loading bpf object files and what will
most likely be a never ending stream of enhancements that impact the
proper loading of them. bpftool is much more suited to the job of
managing bpf files versus iproute2 which is the de facto implementation
for networking APIs. bpftool ships as part of a common linux tools
package, so it will naturally track kernel versions for those who want /
need latest and greatest versions. Users who are not building their own
agents for managing bpf files (which I think is much more appropriate
for production use cases than forking command line utilities) can use
bpftool to load files, manage maps which are then attached to the
programs, etc, and then invoke iproute2 to handle the networking attach
/ detach / list with detailed information.

That said, the legacy bpf code in iproute2 has created some
expectations, and iproute2 can not simply remove existing capabilities.
Moving iproute2 to libbpf provides an improvement over the current
status by allowing ‘modern’ bpf object files to be loaded without
affecting legacy users, even if it does not allow latest and greatest
bpf capabilities at every moment in time (again, a constantly moving
reference point).

iproute2 is a networking configuration tool, not a bpf management tool.
Hangbin’s approach gives full flexibility to those who roll their own
and for distributions who value stability, it allows iproute2 to use
latest and greatest libbpf for those who want to chase the pot of gold
at the end of the rainbow, or they can choose stability with an OS
distro’s libbpf or legacy bpf. I believe this is the right compromise at
this point in time.
