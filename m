Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84624445183
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 11:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhKDKUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 06:20:23 -0400
Received: from mailomta2-sa.btinternet.com ([213.120.69.8]:34710 "EHLO
        sa-prd-fep-048.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230057AbhKDKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 06:20:22 -0400
Received: from sa-prd-rgout-004.btmx-prd.synchronoss.net ([10.2.38.7])
          by sa-prd-fep-048.btinternet.com with ESMTP
          id <20211104101742.GSJS22188.sa-prd-fep-048.btinternet.com@sa-prd-rgout-004.btmx-prd.synchronoss.net>;
          Thu, 4 Nov 2021 10:17:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1636021062; 
        bh=Dpbk0UwcZ9bLPDJAgZJ4iwuy4Hb2z/33Y9C9552QQuY=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=NSJLik+Y+BXEz8HI4eVcRFGxdLoSpeWC8tmzsMcBCxTrZYadunUTugDjRQsGc8byl8m3hClMKARMFcXE96Y8NXupCChlOv8tBVdYFsf87qedikRFifm7ni3nxHxxClIjC5E3fbkAaXcIcDKsYUHjbOD4uoPeE6WsTUwH/GA0bME0Vm09LGPLr1G54f9BCpUXTzaMgEp3UtiY2WklxzVEhtx9MovzOb0wQyiwXK8AFI5FBAAnXd14MIcLu1azAp9LO+XwnmR7JX+GFiKSMiyrxdkdsbMUiDAVRQNUe94gR4GdKZ5moe/gFNC3XAHquKyppWgp0jd8cBbKvbmD09wtsA==
Authentication-Results: btinternet.com;
    auth=pass (LOGIN) smtp.auth=richard_c_haines@btinternet.com;
    bimi=skipped
X-SNCR-Rigid: 613943C60835A3E9
X-Originating-IP: [109.149.181.127]
X-OWM-Source-IP: 109.149.181.127 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvuddrtdeggddutdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomheptfhitghhrghrugcujfgrihhnvghsuceorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomheqnecuggftrfgrthhtvghrnhephfekgeehuddugefgffekheehteetgfejudeghffhveeuvdevudehtdeljeekudevnecukfhppedutdelrddugeelrddukedurdduvdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddurdduleekngdpihhnvghtpedutdelrddugeelrddukedurdduvdejpdhmrghilhhfrhhomheprhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepjhhmohhrrhhishesnhgrmhgvihdrohhrghdprhgtphhtthhopehkuhgsrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqshgtthhpsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqshgvtghurhhithihqdhmohguuhhlvgesvhhgvghr
        rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehluhgtihgvnhdrgihinhesghhmrghilhdrtghomhdprhgtphhtthhopehmrghrtggvlhhordhlvghithhnvghrsehgmhgrihhlrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhmohhsnhgrtggvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehprghulhesphgruhhlqdhmohhorhgvrdgtohhmpdhrtghpthhtohepshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from [192.168.1.198] (109.149.181.127) by sa-prd-rgout-004.btmx-prd.synchronoss.net (5.8.716.04) (authenticated as richard_c_haines@btinternet.com)
        id 613943C60835A3E9; Thu, 4 Nov 2021 10:17:41 +0000
Message-ID: <2aca11b48291775c2d914d4a9570765e9f86bd8d.camel@btinternet.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established
 hook in selinux
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Paul Moore <paul@paul-moore.com>, Xin Long <lucien.xin@gmail.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>
Date:   Thu, 04 Nov 2021 10:17:41 +0000
In-Reply-To: <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
References: <cover.1635854268.git.lucien.xin@gmail.com>
         <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
         <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
         <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com>
         <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com>
         <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
         <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com>
         <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-03 at 23:17 -0400, Paul Moore wrote:
> On Wed, Nov 3, 2021 at 9:46 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Nov 3, 2021 at 6:01 PM Paul Moore <paul@paul-moore.com>
> > wrote:
> > > On Wed, Nov 3, 2021 at 1:36 PM Xin Long <lucien.xin@gmail.com>
> > > wrote:
> > > > On Wed, Nov 3, 2021 at 1:33 PM Xin Long <lucien.xin@gmail.com>
> > > > wrote:
> > > > > On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek
> > > > > <omosnace@redhat.com> wrote:
> > > > > > On Tue, Nov 2, 2021 at 1:03 PM Xin Long
> > > > > > <lucien.xin@gmail.com> wrote:
> > > > > > > 
> > > > > > > Different from selinux_inet_conn_established(), it also
> > > > > > > gives the
> > > > > > > secid to asoc->peer_secid in
> > > > > > > selinux_sctp_assoc_established(),
> > > > > > > as one UDP-type socket may have more than one asocs.
> > > > > > > 
> > > > > > > Note that peer_secid in asoc will save the peer secid for
> > > > > > > this
> > > > > > > asoc connection, and peer_sid in sksec will just keep the
> > > > > > > peer
> > > > > > > secid for the latest connection. So the right use should be
> > > > > > > do
> > > > > > > peeloff for UDP-type socket if there will be multiple asocs
> > > > > > > in
> > > > > > > one socket, so that the peeloff socket has the right label
> > > > > > > for
> > > > > > > its asoc.
> > > > > > > 
> > > > > > > v1->v2:
> > > > > > >   - call selinux_inet_conn_established() to reduce some
> > > > > > > code
> > > > > > >     duplication in selinux_sctp_assoc_established(), as
> > > > > > > Ondrej
> > > > > > >     suggested.
> > > > > > >   - when doing peeloff, it calls sock_create() where it
> > > > > > > actually
> > > > > > >     gets secid for socket from socket_sockcreate_sid(). So
> > > > > > > reuse
> > > > > > >     SECSID_WILD to ensure the peeloff socket keeps using
> > > > > > > that
> > > > > > >     secid after calling selinux_sctp_sk_clone() for client
> > > > > > > side.
> > > > > > 
> > > > > > Interesting... I find strange that SCTP creates the peeloff
> > > > > > socket
> > > > > > using sock_create() rather than allocating it directly via
> > > > > > sock_alloc() like the other callers of sctp_copy_sock()
> > > > > > (which calls
> > > > > > security_sctp_sk_clone()) do. Wouldn't it make more sense to
> > > > > > avoid the
> > > > > > sock_create() call and just rely on the
> > > > > > security_sctp_sk_clone()
> > > > > > semantic to set up the labels? Would anything break if
> > > > > > sctp_do_peeloff() switched to plain sock_alloc()?
> > > > > > 
> > > > > > I'd rather we avoid this SECSID_WILD hack to support the
> > > > > > weird
> > > > > > created-but-also-cloned socket hybrid and just make the
> > > > > > peeloff socket
> > > > > > behave the same as an accept()-ed socket (i.e. no
> > > > > > security_socket_[post_]create() hook calls, just
> > > > > > security_sctp_sk_clone()).
> > > 
> > > I believe the important part is that sctp_do_peeloff() eventually
> > > calls security_sctp_sk_clone() via way of sctp_copy_sock(). 
> > > Assuming
> > > we have security_sctp_sk_clone() working properly I would expect
> > > that
> > > the new socket would be setup properly when sctp_do_peeloff()
> > > returns
> > > on success.
> > > 
> > > ... and yes, that SECSID_WILD approach is *not* something we want
> > > to do.
> > 
> > SECSID_WILD is used to avoid client's new socket's sid overwritten by
> > old socket's.
> 
> In the case of security_sctp_sk_clone() the new client socket (the
> cloned socket) should inherit the label/sid from the original socket
> (the "parent" in the inherit-from-parent label inheritance behavior
> discussed earlier).  The selinux_sctp_assoc_established() function
> should not change the socket's label/sid at all, only the peer label.
> 
> > If I understand correctly, new socket's should keep using its
> > original
> > sid, namely,
> > the one set from security_socket_[post_]create() on client side. I
> > AGREE with that.
> > Now I want to *confirm* this with you, as it's different from the
> > last version's
> > 'inherit from parent socket' that Richard and Ondrej reviewed.
> 
> Unfortunately I think we are struggling to communicate because you are
> not familiar with SELinux concepts and I'm not as well versed in SCTP
> as you are.  As things currently stand, I am getting a disconnect
> between your explanations and the code you have submitted; they simply
> aren't consistent from my perspective.
> 
> In an effort to help provide something that is hopefully a bit more
> clear, here are the selinux_sctp_sk_clone() and
> selinux_sctp_assoc_established() functions which I believe we need.
> If you feel these are incorrect, please explain and/or provide edits:
> 
>   static void selinux_sctp_sk_clone(struct sctp_association *asoc,
>                                     struct sock *sk, struct sock
> *newsk)
>   {
>     struct sk_security_struct *sksec = sk->sk_security;
>     struct sk_security_struct *newsksec = newsk->sk_security;
> 
>     /* If policy does not support SECCLASS_SCTP_SOCKET then call
>      * the non-sctp clone version.
>      */
>     if (!selinux_policycap_extsockclass())
>       return selinux_sk_clone_security(sk, newsk);
> 
>     newsksec->secid = sksec->secid;
This should be:
    newsksec->sid = sksec->sid;


>     newsksec->peer_sid = asoc->peer_secid;
>     newsksec->sclass = sksec->sclass;
>     selinux_netlbl_sctp_sk_clone(sk, newsk);
>   }
> 
>   static void selinux_sctp_assoc_established(struct sctp_association
> *asoc,
>                                              struct sk_buff *skb)
>   {
>     struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> 
>     selinux_inet_conn_established(asoc->base.sk, skb);
>     asoc->peer_secid = sksec->peer_sid;
>   }

