Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F8E4451CC
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 11:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKDK7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 06:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKDK7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 06:59:08 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B2EC061714;
        Thu,  4 Nov 2021 03:56:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so3941817wmz.2;
        Thu, 04 Nov 2021 03:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWWXhfRjzRysjE0NOvlFjKePJBuoPIi4Ry+b748tzNs=;
        b=JBxTmWbY70ZlQw09JgizVDUINgs67bQfkDVVClj4C6KjRfii0FJMzNEd7yRcm6EKlf
         /q0HG1mTt0mNvjq60isCXGrrclPlOM5OK1DE3gFl3fj7h5C0dQLvA21a10/lQ7GcRiA/
         W10TOLn7RLRKaUvhoE08zNomINd4nunVUPyHBLGxHAs23mguo4hsXBeS96iBVdxn+moA
         B8QRoTsASW1voZxfGc6ozHOd4xBShjDhdd4PWMlnnWwyCTKqZAOnW7KQ6gsr06J6f46d
         VbdNJBbjhAgAvViBVEgTqUxtvotX7CKOpgUZmdWzJW2vaEFFNyrDF3NEbehMHtWtOPJJ
         5jkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWWXhfRjzRysjE0NOvlFjKePJBuoPIi4Ry+b748tzNs=;
        b=7wr6Hhsg0LxaUBE5UUtxg0VTiQ+sq5GANq8Kv+C79u85k/1LAymJ+GHF/CqVYbaGQG
         KKqKUv+dDpiRotGHWMc1z2qNpkNo4L8VZELegxK2c7koKPMWW5N6KRRDERFonqJIcrzD
         NqGofF940bYzyNgqSFaqyZwW8s31IDtwpr+KpqwSpnVtE23kSezYkX3pfEExHXOi0++X
         ah9l1LWb90HUW+qUaXZ6fghrnSm0gYMkQoABfhKTHeJMU6PgcH4uvQkmciEWKrDYYPDE
         RO5NYQehKyAQ3fDw443fK5useJCpBrE32Srqt/1dVS6YRdlnsLoOxuND6tLxHEZBosLH
         OnKw==
X-Gm-Message-State: AOAM533GSLbQcxZdaBqUZitwoy7P2tLyM/1uTw8M0eCfmRzbW46QRbf8
        BC12jqUDYGhh7YxNoeDYkNOrH17kJJ3POaPQEKc=
X-Google-Smtp-Source: ABdhPJw+tXxe/YWGGiXFBzKZux/R5pAIVkL+bontHuXR1Q8ayZE79eFWb/Dpyp6owkTUAKUYRaGQ5reEP/FQM1DAL+g=
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr22955656wmk.135.1636023389240;
 Thu, 04 Nov 2021 03:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
 <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
 <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com>
 <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com>
 <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
 <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com> <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
In-Reply-To: <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 4 Nov 2021 06:56:17 -0400
Message-ID: <CADvbK_cmo5Nbrgdt_qLZVnee4M_e4vrw+ocHG5BZpPH_=SS=bQ@mail.gmail.com>
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

On Wed, Nov 3, 2021 at 11:17 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Nov 3, 2021 at 9:46 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Nov 3, 2021 at 6:01 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Wed, Nov 3, 2021 at 1:36 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Wed, Nov 3, 2021 at 1:33 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > > > > On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > > >
> > > > > > > Different from selinux_inet_conn_established(), it also gives the
> > > > > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > > > > > > as one UDP-type socket may have more than one asocs.
> > > > > > >
> > > > > > > Note that peer_secid in asoc will save the peer secid for this
> > > > > > > asoc connection, and peer_sid in sksec will just keep the peer
> > > > > > > secid for the latest connection. So the right use should be do
> > > > > > > peeloff for UDP-type socket if there will be multiple asocs in
> > > > > > > one socket, so that the peeloff socket has the right label for
> > > > > > > its asoc.
> > > > > > >
> > > > > > > v1->v2:
> > > > > > >   - call selinux_inet_conn_established() to reduce some code
> > > > > > >     duplication in selinux_sctp_assoc_established(), as Ondrej
> > > > > > >     suggested.
> > > > > > >   - when doing peeloff, it calls sock_create() where it actually
> > > > > > >     gets secid for socket from socket_sockcreate_sid(). So reuse
> > > > > > >     SECSID_WILD to ensure the peeloff socket keeps using that
> > > > > > >     secid after calling selinux_sctp_sk_clone() for client side.
> > > > > >
> > > > > > Interesting... I find strange that SCTP creates the peeloff socket
> > > > > > using sock_create() rather than allocating it directly via
> > > > > > sock_alloc() like the other callers of sctp_copy_sock() (which calls
> > > > > > security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
> > > > > > sock_create() call and just rely on the security_sctp_sk_clone()
> > > > > > semantic to set up the labels? Would anything break if
> > > > > > sctp_do_peeloff() switched to plain sock_alloc()?
> > > > > >
> > > > > > I'd rather we avoid this SECSID_WILD hack to support the weird
> > > > > > created-but-also-cloned socket hybrid and just make the peeloff socket
> > > > > > behave the same as an accept()-ed socket (i.e. no
> > > > > > security_socket_[post_]create() hook calls, just
> > > > > > security_sctp_sk_clone()).
> > >
> > > I believe the important part is that sctp_do_peeloff() eventually
> > > calls security_sctp_sk_clone() via way of sctp_copy_sock().  Assuming
> > > we have security_sctp_sk_clone() working properly I would expect that
> > > the new socket would be setup properly when sctp_do_peeloff() returns
> > > on success.
> > >
> > > ... and yes, that SECSID_WILD approach is *not* something we want to do.
> >
> > SECSID_WILD is used to avoid client's new socket's sid overwritten by
> > old socket's.
>
> In the case of security_sctp_sk_clone() the new client socket (the
> cloned socket) should inherit the label/sid from the original socket

"""
 The initial SCTP client association would
need to take it's label from the parent process so perhaps that is the
right answer for all SCTP client associations[2].

[2] I'm guessing the client associations might also want to follow the
setsockcreatecon(3) behavior, see selinux_sockcreate_sid() for more
info.
"""
What I got is to take it's label from the parent process, which means
we get it from socket_sockcreate_sid(), not directly copy from parent
socket. It seems I misunderstood that, Sorry, maybe we should just
use the v1 patchset.


> (the "parent" in the inherit-from-parent label inheritance behavior
> discussed earlier).  The selinux_sctp_assoc_established() function
> should not change the socket's label/sid at all, only the peer label.
Right, that's what it currently does in this patchset, no *socket* sid
is changed, and only *socket*'s peer label.

{
        struct sk_security_struct *sksec = asoc->base.sk->sk_security;

        selinux_inet_conn_established(asoc->base.sk, skb);
        asoc->peer_secid = sksec->peer_sid;
        asoc->secid = SECSID_WILD;
}

>
> > If I understand correctly, new socket's should keep using its original
> > sid, namely,
> > the one set from security_socket_[post_]create() on client side. I
> > AGREE with that.
> > Now I want to *confirm* this with you, as it's different from the last version's
> > 'inherit from parent socket' that Richard and Ondrej reviewed.
>
> Unfortunately I think we are struggling to communicate because you are
> not familiar with SELinux concepts and I'm not as well versed in SCTP
> as you are.  As things currently stand, I am getting a disconnect
> between your explanations and the code you have submitted; they simply
> aren't consistent from my perspective.
>
> In an effort to help provide something that is hopefully a bit more
> clear, here are the selinux_sctp_sk_clone() and
> selinux_sctp_assoc_established() functions which I believe we need.
> If you feel these are incorrect, please explain and/or provide edits:
>
>   static void selinux_sctp_sk_clone(struct sctp_association *asoc,
>                                     struct sock *sk, struct sock *newsk)
>   {
>     struct sk_security_struct *sksec = sk->sk_security;
>     struct sk_security_struct *newsksec = newsk->sk_security;
>
>     /* If policy does not support SECCLASS_SCTP_SOCKET then call
>      * the non-sctp clone version.
>      */
>     if (!selinux_policycap_extsockclass())
>       return selinux_sk_clone_security(sk, newsk);
>
>     newsksec->secid = sksec->secid;
>     newsksec->peer_sid = asoc->peer_secid;
>     newsksec->sclass = sksec->sclass;
>     selinux_netlbl_sctp_sk_clone(sk, newsk);
>   }
here, SCTP is one-to-many socket, and it means one socket can have
multiple associations or connections, so for sksec->sid in one socket
it can only save the latest cid, if we peel off an old one, it will get the
wrong cid on server side.

>
>   static void selinux_sctp_assoc_established(struct sctp_association *asoc,
>                                              struct sk_buff *skb)
>   {
>     struct sk_security_struct *sksec = asoc->base.sk->sk_security;
>
>     selinux_inet_conn_established(asoc->base.sk, skb);
>     asoc->peer_secid = sksec->peer_sid;
>   }
>
> > > > > > > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > > > > > > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > > > > > > Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > > > > Tested-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > > >
> > > > > > You made non-trivial changes since the last revision in this patch, so
> > > > > > you should have also dropped the Reviewed-by and Tested-by here. Now
> > > > > > David has merged the patches probably under the impression that they
> > > > > > have been reviewed/approved from the SELinux side, which isn't
> > > > > > completely true.
> > > > >
> > > > > Oh, that's a mistake, I thought I didn't add it.
> > > > > Will he be able to test this new patchset?
> > >
> > > While I tend to try to avoid reverts as much as possible, I think the
> > > right thing to do is to get these patches reverted out of DaveM's tree
> > > while we continue to sort this out and do all of the necessary testing
> > > and verification.
> > >
> > > Xin Long, please work with the netdev folks to get your patchset
> > > reverted and then respin this patchset using the feedback provided.
> >
> > Hi, Paul,
> >
> > The original issue this patchset fixes is a crucial one (it could cause
> > peeloff sockets on client side to not work) which I think
> > can already be fixed now. If you think SECSID_WILD is tricky but
> > no better way yet, my suggestion is to leave it for now until we have
> > a better solution to follow up. As I couldn't find a better way to work
> > it out. Also, we may want to hear Richard's opinion on how it should
> > work and how this should be fixed.
>
> While I understand you did not intend to mislead DaveM and the netdev
> folks with the v2 patchset, your failure to properly manage the
> patchset's metadata *did* mislead them and as a result a patchset with
> serious concerns from the SELinux side was merged.  You need to revert
> this patchset while we continue to discuss, develop, and verify a
> proper fix that we can all agree on.  If you decide not to revert this
> patchset I will work with DaveM to do it for you, and that is not
> something any of us wants.
>
> --
> paul moore
> www.paul-moore.com
