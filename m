Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA21E444D16
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhKDBtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhKDBtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:49:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F298C061714;
        Wed,  3 Nov 2021 18:46:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i5so6267608wrb.2;
        Wed, 03 Nov 2021 18:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6UZ9QzgDO0cKHF5YhLIs9VgxnGlTbz4OFbftB+dyTWA=;
        b=eOctDe7zw0mVyaLMEPaq0CFWmR4LZfppwf58NICJVQVHgxHuAybDgae0VUPRcoeOMv
         wjZjTw4bYaczAzL8k+U+B4l/WwCWdxGz7KStaJcBEh9xOy8kJYu4is6Rsg17KY3DT82q
         jYzkWEFyoimN2aBMEBVMaJofUFRb0TBXHLzpLzCWC/9+4LggC/v1lpQGi4gMUgqwNn0A
         zFuN6/qKcq1gr6C+3turAL4FJAekc53LdQpSW3iXXmZtxDKHCkGV84oEJbEHrhP/ii1f
         qtd0ej6TAGnm6jzfQQKgfLQgWDXHtFjsZ+mktSCK4FnbVs9tQ2UwPGOHCN2ZufDQKcjU
         6JxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6UZ9QzgDO0cKHF5YhLIs9VgxnGlTbz4OFbftB+dyTWA=;
        b=NQ5sAqJ5r2roScbGZXcNjLusEwD1Sqtdq+pFYctCScNxailsJJc0c0OBmooRpp1hb4
         GkI94rx2gWw0dYS4KyYGl6xqTsnRxi4bVYWH57hW39m7/wgcCPpHqQadj+JKT4/I6hgQ
         m096o9jMsr/k/gVCMVxYjOQYKZsRJHC87Goz/O+1Akv9W/tvWjK+goRHXp9reuf5Cd8C
         R4l3lEPd8vkPMZ/uvhS6WKLmvIOQsNuhtzq6Fz9fgKOX06bad8t4b1XQPSAr5JzAhdot
         n4Ha68/Q4MCWHWO+xOLzriZBbZyEJnIkVknhNEp5DdbkJ34sgBuVX7qDHsbOA55lvSpg
         +9NQ==
X-Gm-Message-State: AOAM533SJluZqmkx2ocfvy9bU06fmUZ51gYPpw9TcrdyAmiPCL2fgYHV
        fJZ//1zTqDvsj9crmp8eqzReXZGH2Zvdys0vBsw=
X-Google-Smtp-Source: ABdhPJyaczO54g3EhWm66dK0ow4tFDvuAAcvmMZ/5PYaCARB8LDFdfh3ulyit0H+xLHFBkeZeVgk7T4IWFENx42QB6I=
X-Received: by 2002:a5d:4563:: with SMTP id a3mr43479496wrc.130.1635990404084;
 Wed, 03 Nov 2021 18:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
 <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
 <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com>
 <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com> <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
In-Reply-To: <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Nov 2021 21:46:32 -0400
Message-ID: <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 6:01 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Nov 3, 2021 at 1:36 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Nov 3, 2021 at 1:33 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > > On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > Different from selinux_inet_conn_established(), it also gives the
> > > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > > > > as one UDP-type socket may have more than one asocs.
> > > > >
> > > > > Note that peer_secid in asoc will save the peer secid for this
> > > > > asoc connection, and peer_sid in sksec will just keep the peer
> > > > > secid for the latest connection. So the right use should be do
> > > > > peeloff for UDP-type socket if there will be multiple asocs in
> > > > > one socket, so that the peeloff socket has the right label for
> > > > > its asoc.
> > > > >
> > > > > v1->v2:
> > > > >   - call selinux_inet_conn_established() to reduce some code
> > > > >     duplication in selinux_sctp_assoc_established(), as Ondrej
> > > > >     suggested.
> > > > >   - when doing peeloff, it calls sock_create() where it actually
> > > > >     gets secid for socket from socket_sockcreate_sid(). So reuse
> > > > >     SECSID_WILD to ensure the peeloff socket keeps using that
> > > > >     secid after calling selinux_sctp_sk_clone() for client side.
> > > >
> > > > Interesting... I find strange that SCTP creates the peeloff socket
> > > > using sock_create() rather than allocating it directly via
> > > > sock_alloc() like the other callers of sctp_copy_sock() (which calls
> > > > security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
> > > > sock_create() call and just rely on the security_sctp_sk_clone()
> > > > semantic to set up the labels? Would anything break if
> > > > sctp_do_peeloff() switched to plain sock_alloc()?
> > > >
> > > > I'd rather we avoid this SECSID_WILD hack to support the weird
> > > > created-but-also-cloned socket hybrid and just make the peeloff socket
> > > > behave the same as an accept()-ed socket (i.e. no
> > > > security_socket_[post_]create() hook calls, just
> > > > security_sctp_sk_clone()).
>
> I believe the important part is that sctp_do_peeloff() eventually
> calls security_sctp_sk_clone() via way of sctp_copy_sock().  Assuming
> we have security_sctp_sk_clone() working properly I would expect that
> the new socket would be setup properly when sctp_do_peeloff() returns
> on success.
>
> ... and yes, that SECSID_WILD approach is *not* something we want to do.
 SECSID_WILD is used to avoid client's new socket's sid overwritten by
old socket's.

If I understand correctly, new socket's should keep using its original
sid, namely,
the one set from security_socket_[post_]create() on client side. I
AGREE with that.
Now I want to *confirm* this with you, as it's different from the last version's
'inherit from parent socket' that Richard and Ondrej reviewed.

>
> In my mind, selinux_sctp_sk_clone() should end up looking like this.
>
>   void selinux_sctp_sk_clone(asoc, sk, newsk)
>   {
>     struct sk_security_struct sksec = sk->sk_security;
>     struct sk_security_struct newsksec = newsk->sk_security;
>
>     if (!selinux_policycap_extsockclass())
>         return selinux_sk_clone_security(sk, newsk);
>
>     newsksec->sid = sksec->secid;
>     newsksec->peer_sid = asoc->peer_secid;
>     newsksec->sclass = sksec->sclass;
>     selinux_netlbl_sctp_sk_clone(sk, newsk);
>   }
Let's say, this socket has 3 associations now, how can we ensure
the new socket's sid is set to the right sid? I don't think we can use
"sksec->secid" in this place, this is not TCP.

>
> Also, to be clear, the "assoc->secid = SECSID_WILD;" line should be
> removed from selinux_sctp_assoc_established().  If we are treating
> SCTP associations similarly to TCP connections, the association's
> label/secid should be set once and not changed during the life of the
> association.
The association's label/secid will never change once set in this patchset.
it's just a temporary record, and later it will be used to set socket's
label/secid. I think that's the idea at the beginning.

>
> > > > > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > > > > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > > > > Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > > Tested-by: Richard Haines <richard_c_haines@btinternet.com>
> > > >
> > > > You made non-trivial changes since the last revision in this patch, so
> > > > you should have also dropped the Reviewed-by and Tested-by here. Now
> > > > David has merged the patches probably under the impression that they
> > > > have been reviewed/approved from the SELinux side, which isn't
> > > > completely true.
> > >
> > > Oh, that's a mistake, I thought I didn't add it.
> > > Will he be able to test this new patchset?
>
> While I tend to try to avoid reverts as much as possible, I think the
> right thing to do is to get these patches reverted out of DaveM's tree
> while we continue to sort this out and do all of the necessary testing
> and verification.
>
> Xin Long, please work with the netdev folks to get your patchset
> reverted and then respin this patchset using the feedback provided.
Hi, Paul,

The original issue this patchset fixes is a crucial one (it could cause
peeloff sockets on client side to not work) which I think
can already be fixed now. If you think SECSID_WILD is tricky but
no better way yet, my suggestion is to leave it for now until we have
a better solution to follow up. As I couldn't find a better way to work
it out. Also, we may want to hear Richard's opinion on how it should
work and how this should be fixed.

Thanks.

>
> --
> paul moore
> www.paul-moore.com
