Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9910DA54
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 21:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfK2UAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 15:00:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45585 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfK2UAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 15:00:33 -0500
Received: by mail-lj1-f193.google.com with SMTP id d20so3325462ljc.12;
        Fri, 29 Nov 2019 12:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1pC1+EVeSHXuceCNVPylQPVNa3ykp3OuN3IseTjYqQ=;
        b=k/KLDiBUsyjUADM+17nSCGLYuSSNtc4jCh/nrFE9t1xEM06uVjD+tcBZy2+6a0T6VS
         bmoljCdG5Zsz9Qk3L3scsbzjsHv128ZEzSpvmsNvlLPJtgCB1/CW0VOdnv5We5gXUvLI
         K9nHaB/+jCrpdKYOo1p0KfAIOnyFFMtEOPQgIoQuMn8LFUOfHTNIxIE89Qf28oR6ecLk
         ZpPBzyNpiO5fbEyloTIBfOKg78eGGdJK/hPRa2VT2biShHC/IcDVA6H3nEm2EU7nVohB
         fmsXJwsf0rdNi1tZzLlDZdrUTrKQWkoF8WitSe3LtI3mp2Rur/MLgQnMWJJYMXNh8AW8
         //Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1pC1+EVeSHXuceCNVPylQPVNa3ykp3OuN3IseTjYqQ=;
        b=FGTZNClJOTvLRuCuvdvaweB5S1uYuzG3qdr7X6kKciChnhoJctOakc7486GI0UTLgE
         3yMtcgC9f0IInrwANDGO1lcWwZj4JyJyRQA1wvzNGO/EHPrFB4a68OQJJXmGu/kp+c++
         lccQfScCN+FZiFHj29wdGrHj5n3MybSnDUG8+0c+k9yrfsRtcoL/qAvRa7ovKHUK7QhI
         4bQHDFX7ZlBxQ7cHYUASAeUhNEAzKical7R7U3PoD7WJ3PmbMurXKRAs4rc4mP41/Rja
         i9qAi7ToF1N5Bsp34rbM5PkzUkb9YCbTobWeLc/OUhqXZc+Lj/Pp1bHQe6boA6wvoilO
         0UJA==
X-Gm-Message-State: APjAAAUvxql7zDtCX5YLzg0chuPUAVCDA9tuIJKjfc9eCSRIuBF5sPFq
        DSA2rfUcphv1Tj+KFL1KlSt8cReEeLnyeMymK/U=
X-Google-Smtp-Source: APXvYqy0DHwLKeqkM4WNjm69oKu66hIR9l8GJDyYWkd8HLiprvU/XgPfQTSAcNtYTMVqUure7KhXLr83QSj9gIlwYWg=
X-Received: by 2002:a2e:3e0f:: with SMTP id l15mr39566245lja.209.1575057630172;
 Fri, 29 Nov 2019 12:00:30 -0800 (PST)
MIME-Version: 1.0
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain> <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain>
In-Reply-To: <20191127230001.GO388551@localhost.localdomain>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 29 Nov 2019 21:00:19 +0100
Message-ID: <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Perhaps, but SELinux isn't used by many distros, including the servers
> > where I have nics that steal some ports.  It's also much much
> > more difficult, requiring a policy, compilers, etc... and it gets even
> > more complex if you need to dynamically modify the set of ports,
> > which requires extra tools and runtime permissions.
>
> I'm no SELinux expert, but my /etc/ssh/sshd_config has this nice handy
> comment:
> # If you want to change the port on a SELinux system, you have to tell
> # SELinux about this change.
> # semanage port -a -t ssh_port_t -p tcp #PORTNUMBER

Right, so I'm also not at all an SELinux expert.

But: I run Fedora as my preferred distro of choice and it is of course
SELinux enabled (and has been for many many years now) and I'm aware
of that ssh port magic, precisely because I sometimes run ssh on a
port different than 22.

I'm also working full time on Android, where I bash my head against
SELinux quite regularly ;-)

> The kernel has no specific knowledge of 'ssh_port_t' and all I need to
> do to allow such port, is run the command above.

I don't think that's actually true.  I believe somewhere in the
SELinux policy there is a reference to a set named ssh_port_t, some
binary number assigned to it, and a default set of ports (ie. 22).

semanage, looks up 'ssh_port_t' maps it to some number X and tells the
kernel that port P needs to be added to set X, and it needs super
privileges to do so, because obviously managing the SELinux policy is
about as privileged as you can get.  And then it stores that P should
be in X somewhere on disk so it survives reboot.  I don't know if
along the way it reloaded the entire policy or just a subset.

strace'ing semanage seems to roughly confirm this (although there's
tons and tons of output...)

> No compiler, etc.

The compiler is present on fedora at least.  I don't know if semanage
invokes it or not, obviously at some point it was invoked.

> The distribution would have to have a policy, say,
> 'unbindable_ports_t', and it could work similarly, I suppose, but I
> have no knowledge on this part.

Yes, the OS image has to include 'semanage' and all the selinux
tooling, and has to ship a policy which has the unbindable_ports_t
already defined in it...

But here's I think the fundamental problem with an SELinux approach.
By default SELinux is deny all.  All you can do is grant extra privs.
I'm not aware of a way to actually say system wide disallow X.
'neverallow' is a compile time policy enforcement hack, and isn't
(afaik) translated into anything that's actually given to the kernel.

So really instead you'd need to create a port set for every app -
including a default , and then make sure that whatever port you want
to block is excluded from each of those sets.

ie.
[root@gaia ~]# semanage port -l | egrep '32768|65535'
ephemeral_port_t               tcp      32768-60999
ephemeral_port_t               udp      32768-60999
unreserved_port_t              sctp     1024-65535
unreserved_port_t              tcp      61001-65535, 1024-32767
unreserved_port_t              udp      61001-65535, 1024-32767

You need to iterate through all port sets, and remove port P from each
of them in turn.
(can port sets overlap? not sure... do ports need to be in some set?
perhaps also need to add the port to the unbindable set or something)

It's certainly doable, but it's a *lot* of work.
If you're on Fedora... then this isn't a huge problem, because someone
did most of the work for you already...  But, on any other distro?

And let's not even get started wrt. interactions with network namespaces.

I also don't know of a way to allow changes to selinux for NET_ADMIN
(correct me if I'm wrong),
I also don't immediately know how to do this with /proc settings, but
it seems like it should be achievable either via some additional
patches, or via some clever boot-time network namespace creation
hackery (on Android I imagine the answer would involve some sort of
selinux tagging of the appropriate sysctl file in order to allow netd
to change it).

> On not having SELinux enabled, you got me there. I not really willing
> to enter a "to do SELinux or not" discussion. :-)

:-)

I'm of the opinion that SELinux and other security policy modules
should be reserved for things related to system wide security policy.
Not for things that are more along the lines of 'functionality'.

Also selinux has 'permissive' mode which causes the system to ignore
all selinux access controls (in favour of just logging) and this is
what is commonly used during development (because it's such a pain to
work with).

This could also technically be probably done via bpf syscall filters,
or bpf cgroup hooks...
But those approaches have performance implications and require a huge
amount of machinery and complexity to manage.
