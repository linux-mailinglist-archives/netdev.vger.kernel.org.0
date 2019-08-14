Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F868D95F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfHNRHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:07:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43929 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729970AbfHNRHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:07:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3so2369831pgb.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FfuwdcQYVuz1smdU6cuWM5yXvRpjDtjFrggRUBq6uDw=;
        b=NHjn2XABm/9/xwzgQjEDJfAWjZevBwrSW/x9lGsePkN6Rho/yQjLXPoaDwFkOUFMkX
         qIer4xzE/Ne3No+3x++c5jL6Kz49WC297T4Bdd8M6AnhNgVa+W69wO2qW634uEnuVujM
         OToizJFaUSBgLwvmHBJC+NwLAnA/3HApKX7sTGpE0RIN+QkyEkzGEEZ/1P1TPqWyG28x
         bPoIa4MaulM3yLmGh00ZJ4j/6RBD0zglfGGKxEZJ44DIo2C6zjzdcL+z/reLQ5829x3L
         45r1NJr5I5gFTH0gRzaj2pQjj9bqYY+yW8AUT5KADzQJ8DB4L+iqismH3QimmmmK6NVK
         M2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FfuwdcQYVuz1smdU6cuWM5yXvRpjDtjFrggRUBq6uDw=;
        b=FjCaLmVuWVUEbuAgo0SFLeGnnAAAysuxXlSCqxAIOqgnN1tzHyz+iosAWuw7fLNBbO
         7jUU5m7e2QZG5TDfQdAz041v3kTLs3Oy+hEWjBBI2RBdGqXmf0O4fQGVQZ57nq+dM5W2
         knd4+gzqS6/f1leYGJq+E9uLeXSBX4KvMnTqenEaC/ffiTACVNLZe4/0QDCPNKfqnFpf
         /Q+B+oUkdBGS6zk5HR43uHrt0TgPwXi7UwijxQxIBK+tCDMIyasaIWXqUeiRaRe7CECM
         hW76LeNngK1DoKBjTsk0HGiHzI158HDsU5Xek7KpuqcTRAOXRYLiHpzRWfnz25Ggkij+
         0qyA==
X-Gm-Message-State: APjAAAWMvyHwuyWBBKKoKt4i5WP/21HzIVUspJ36qOgJe65ffp2R6xqd
        qutLbkyecNww3YecHC1kWaggpQ==
X-Google-Smtp-Source: APXvYqzN5aJBu0nuWREutIuBmbQ4WEamZlx4CyC8y6jOxoAOHgIMfIBVaHpGtuBAWzU8DeWS4mAhYg==
X-Received: by 2002:a17:90a:c714:: with SMTP id o20mr735220pjt.50.1565802469557;
        Wed, 14 Aug 2019 10:07:49 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a189sm374332pfa.60.2019.08.14.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:07:49 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:07:48 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/4] selftests/bpf: test_progs: change
 formatting of the condenced output
Message-ID: <20190814170748.GK2820@mini-arch>
References: <20190814164742.208909-1-sdf@google.com>
 <20190814164742.208909-2-sdf@google.com>
 <CAADnVQJk=qSLR1A=1poPY85wNqiye3dMvXZOZ+1OFZSA78VARg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJk=qSLR1A=1poPY85wNqiye3dMvXZOZ+1OFZSA78VARg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/14, Alexei Starovoitov wrote:
> On Wed, Aug 14, 2019 at 9:47 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > This makes it visually simpler to follow the output.
> > Also, highlight with red color failures when outputting to tty.
> >
> > Before:
> >   #1 attach_probe:FAIL
> >   #2 bpf_obj_id:OK
> >   #3/1 bpf_verif_scale:loop3.o:OK
> >   #3/2 bpf_verif_scale:test_verif_scale1.o:OK
> >   #3/3 bpf_verif_scale:test_verif_scale2.o:OK
> >   #3/4 bpf_verif_scale:test_verif_scale3.o:OK
> >   #3/5 bpf_verif_scale:pyperf50.o:OK
> >   #3/6 bpf_verif_scale:pyperf100.o:OK
> >   #3/7 bpf_verif_scale:pyperf180.o:OK
> >   #3/8 bpf_verif_scale:pyperf600.o:OK
> >   #3/9 bpf_verif_scale:pyperf600_nounroll.o:OK
> >   #3/10 bpf_verif_scale:loop1.o:OK
> >   #3/11 bpf_verif_scale:loop2.o:OK
> >   #3/12 bpf_verif_scale:loop4.o:OK
> >   #3/13 bpf_verif_scale:loop5.o:OK
> >   #3/14 bpf_verif_scale:strobemeta.o:OK
> >   #3/15 bpf_verif_scale:strobemeta_nounroll1.o:OK
> >   #3/16 bpf_verif_scale:strobemeta_nounroll2.o:OK
> >   #3/17 bpf_verif_scale:test_sysctl_loop1.o:OK
> >   #3/18 bpf_verif_scale:test_sysctl_loop2.o:OK
> >   #3/19 bpf_verif_scale:test_xdp_loop.o:OK
> >   #3/20 bpf_verif_scale:test_seg6_loop.o:OK
> >   #3 bpf_verif_scale:OK
> >   #4 flow_dissector:OK
> >
> > After:
> >   #  1     FAIL attach_probe
> >   #  2       OK bpf_obj_id
> >   #  3/1     OK bpf_verif_scale:loop3.o
> >   #  3/2     OK bpf_verif_scale:test_verif_scale1.o
> >   #  3/3     OK bpf_verif_scale:test_verif_scale2.o
> >   #  3/4     OK bpf_verif_scale:test_verif_scale3.o
> >   #  3/5     OK bpf_verif_scale:pyperf50.o
> >   #  3/6     OK bpf_verif_scale:pyperf100.o
> >   #  3/7     OK bpf_verif_scale:pyperf180.o
> >   #  3/8     OK bpf_verif_scale:pyperf600.o
> >   #  3/9     OK bpf_verif_scale:pyperf600_nounroll.o
> >   #  3/10    OK bpf_verif_scale:loop1.o
> >   #  3/11    OK bpf_verif_scale:loop2.o
> >   #  3/12    OK bpf_verif_scale:loop4.o
> >   #  3/13    OK bpf_verif_scale:loop5.o
> >   #  3/14    OK bpf_verif_scale:strobemeta.o
> >   #  3/15    OK bpf_verif_scale:strobemeta_nounroll1.o
> >   #  3/16    OK bpf_verif_scale:strobemeta_nounroll2.o
> >   #  3/17    OK bpf_verif_scale:test_sysctl_loop1.o
> >   #  3/18    OK bpf_verif_scale:test_sysctl_loop2.o
> >   #  3/19    OK bpf_verif_scale:test_xdp_loop.o
> >   #  3/20    OK bpf_verif_scale:test_seg6_loop.o
> >   #  3       OK bpf_verif_scale
> >   #  4       OK flow_dissector
> 
> sorry this is nack.
> I prefer consistency with test_verifier output.
No problem, let me know how you feel about the other patches
in the series, can drop this one.
