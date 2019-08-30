Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295F8A331E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfH3Is7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:48:59 -0400
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:54524 "EHLO
        resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbfH3Is6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:48:58 -0400
Received: from resomta-ch2-09v.sys.comcast.net ([69.252.207.105])
        by resqmta-ch2-04v.sys.comcast.net with ESMTP
        id 3caXimwTlbgbq3caXiEQEP; Fri, 30 Aug 2019 08:48:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
        s=20190202a; t=1567154937;
        bh=JrWJpfwHo/SmXQ8qoHOff7lIJvvG7n3bpiw5LABtK0c=;
        h=Received:Received:From:To:Subject:Date:Message-ID:MIME-Version:
         Content-Type;
        b=OWMGEKJISN65YQKrEFie8Bmol2YJjn+6CHxvZdvv8wq3tFK8U8pRDNpt+8UFVdsEW
         JU7PR0KpAm2sT03dN1NNz4gxKKt3L6QnoHZPnCQ4IsbWFuqhEp7Mqp39wa9nht2V7U
         +njCccrGeUdQ1OLoRszQn0mLuDK0L85NyGmtcnS2nADlezgUHQssv4m3ZDMLRJauxJ
         3Lda9gQKa8KVfPLF9ziWsMs2jeNbAeZPxTmyoeIc+CGExgA4e3SQs/7+UCPVqDAWC6
         1d+g8pFEF2s/Yd4eJm+4aUFnrOGryNjD/k8SdBWLDOGworgJAtWIlkOlIq0gYe4e72
         MCy5V292TUTnw==
Received: from DireWolf ([108.49.206.201])
        by resomta-ch2-09v.sys.comcast.net with ESMTPSA
        id 3ca8iTrGpsv0O3caAiONaN; Fri, 30 Aug 2019 08:48:54 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgtdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvfhgjufffkfggtgfgofhtsehtqhhgtddvtdejnecuhfhrohhmpedfufhtvghvvgcukggrsggvlhgvfdcuoeiirggsvghlvgestghomhgtrghsthdrnhgvtheqnecuffhomhgrihhnpehivghtfhdrohhrghenucfkphepuddtkedrgeelrddvtdeirddvtddunecurfgrrhgrmhephhgvlhhopeffihhrvgghohhlfhdpihhnvghtpedutdekrdegledrvddtiedrvddtuddpmhgrihhlfhhrohhmpeiirggsvghlvgestghomhgtrghsthdrnhgvthdprhgtphhtthhopegurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprhgtphhtthhopehmrghrkhdrkhgvrghtohhnsehrrgihthhhvghonhdrtghomhdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehonhdvkhduiehnmhesghhmrghilhdrtghomhdprhgtphhtthhopehsrghifhhirdhkhhgrnhesshhtrhhikhhrrdhinhdprhgtphhtthhopehshhhumhestggrnhhnughrvgifrdhorhhgpdhrtghpthhtohepshhtvghphhgvnhesnhgvthifohhrkhhplhhumhgsvghrrdhorhhgpdhrtghpthhtohepvhhlrgguihhmihhrudduieesghhmrghilhdrtghomhd
X-Xfinity-VMeta: sc=-100;st=legit
From:   "Steve Zabele" <zabele@comcast.net>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Network Development'" <netdev@vger.kernel.org>,
        <shum@canndrew.org>, <vladimir116@gmail.com>,
        <saifi.khan@datasynergy.org>, <saifi.khan@strikr.in>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>, <on2k16nm@gmail.com>,
        "'Stephen Hemminger'" <stephen@networkplumber.org>,
        <mark.keaton@raytheon.com>
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
Subject: RE: Is bug 200755 in anyone's queue??
Date:   Fri, 30 Aug 2019 04:48:35 -0400
Message-ID: <000f01d55f0f$c2a921f0$47fb65d0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdVen8s+yDx4SZXJTWeKQUT7IpkgqQAaiC1Q
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem!

**Thank you** for the reply and the code segment, very much appreciated.

Can we expect that this will make its way into a near-term official =
release of the kernel? Our customers are really not up to patching and =
rebuilding kernels, plus it "taints" the kernel from a security =
perspective, and whenever there is a new release of the kernel (you come =
in one morning and your kernel has been magically upgraded for you =
because you forgot to disable auto updates) you need to rebuild and hope =
that the previous patch is still good for the new code, etc, etc.

Getting this onto the main branch as part of the official release cycle =
will be greatly appreciated!

Note that using an ebpf approach can't solve this problem (we know =
because we tried for quite a while to make it work, no luck). The key =
issue is that at the point when the ebpf filter gets the packet buffer =
reference it is pointing to the start of the UDP portion of the packet, =
and hence is not able to access the IP source address which is earlier =
in the buffer. Plus every time a new socket is opened or closed, a new =
epbf has to be created and inserted -- and there is really no good way =
to figure out which index is (now) associated with which file =
descriptor..=20

So thank you and the group for your attention to this.

With respect to your comment

>SO_REUSEPORT was not intended to be used in this way. Opening
>multiple connected sockets with the same local port.

I'd like to offer that there are a number of reliable transport =
protocols (alternatives to TCP) that use UDP. NORM (IETF RFC 5470) and =
Google's new QUIC protocol =
(https://www.ietf.org/blog/whats-happening-quic) are good examples.

Now consider that users of these protocols will want to create servers =
using these protocols -- a webserver is a good example. In fact Google =
has one running on QUIC, and many Chrome users don't even know they are =
using QUIC when they access Google webservers.

With a client-server model, clients contact the server at a well known =
server address and port. Upon first contact from a new client, the =
server opens another socket with the same local address and port and =
"connects" to the clients address and ephemeral port so that only =
traffic for the given five tuple arrives on the new file descriptor -- =
this allows the server application to keep concurrent sessions with =
different clients cleanly separated, even though all sessions use the =
same local server port. In fact, reusing the same port for different =
sessions is really important from a firewalling perspective,

This is pretty much what our application does, i.e., it uses different =
sockets/file descriptors to keep sessions straight.

And if it's worth anything, we have been using this mechanism with UDP =
for a *very* long time, the change in behavior appears to have happened =
with the 4.5 kernel.

So **thank you**!!

Steve

-----Original Message-----
From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]=20
Sent: Thursday, August 29, 2019 3:27 PM
To: Steve Zabele
Cc: Network Development; shum@canndrew.org; vladimir116@gmail.com; =
saifi.khan@datasynergy.org; saifi.khan@strikr.in; Daniel Borkmann; =
on2k16nm@gmail.com; Stephen Hemminger
Subject: Re: Is bug 200755 in anyone's queue??

On Fri, Aug 23, 2019 at 3:11 PM Steve Zabele <zabele@comcast.net> wrote:
>
> Hi folks,
>
> Is there a way to find out where the SO_REUSEPORT bug reported a year =
ago in
> August (and apparently has been a bug with kernels later than 4.4) is =
being
> addressed?
>
> The bug characteristics, simple standalone test code demonstrating the =
bug,
> and an assessment of the likely location/cause of the bug within the =
kernel
> are all described here
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D200755
>
> I'm really hoping this gets fixed so we can move forward on updating =
our
> kernels/Ubuntu release from our aging 4.4/16.04 release
>
> Thanks!
>
> Steve
>
>
>
> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> Sent: Tuesday, July 16, 2019 10:03 AM
> To: Steve Zabele
> Cc: shum@canndrew.org; vladimir116@gmail.com; =
saifi.khan@DataSynergy.org;
> saifi.khan@strikr.in; daniel@iogearbox.net; on2k16nm@gmail.com
> Subject: Re: Is bug 200755 in anyone's queue??
>
> On Tue, 16 Jul 2019 09:43:24 -0400
> "Steve Zabele" <zabele@comcast.net> wrote:
>
>
> > I came across bug report 200755 trying to figure out why some code I =
had
> > provided to customers a while ago no longer works with the current =
Linux
> > kernel. See
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D200755
> >
> > I've verified that, as reported, 'connect' no longer works for UDP.
> > Moreover, it appears it has been broken since the 4.5 kernel has =
been
> > released.
> >
> >
> >
> > It does also appear that the intended new feature of doing round =
robin
> > assignments to different UDP sockets opened with SO_REUSEPORT also =
does
> not
> > work as described.
> >
> >
> >
> > Since the original bug report was made nearly a year ago for the =
4.14
> kernel
> > (and the bug is also still present in the 4.15 kernel) I'm curious =
if
> anyone
> > is on the hook to get this fixed any time soon.
> >
> >
> >
> > I'd rather not have to do my own demultiplexing using a single =
socket in
> > user space to work around what is clearly a (maybe not so recently
> > introduced) kernel bug if at all possible. My code had worked just =
fine on
> > 3.X kernels, and appears to work okay up through 4.4.
> >
>
> Kernel developers do not use bugzilla, I forward bug reports
> to netdev@vger.kernel.org (after filtering).

SO_REUSEPORT was not intended to be used in this way. Opening
multiple connected sockets with the same local port.

But since the interface allowed connect after joining a group, and
that is being used, I guess that point is moot. Still, I'm a bit
surprised that it ever worked as described.

Also note that the default distribution algorithm is not round robin
assignment, but hash based. So multiple consecutive datagrams arriving
at the same socket is not unexpected.

I suspect that this quick hack might "work". It seemed to on the
supplied .c file:

                  score =3D compute_score(sk, net, saddr, sport,
                                        daddr, hnum, dif, sdif);
                  if (score > badness) {
  -                       if (sk->sk_reuseport) {
  +                       if (sk->sk_reuseport && !sk->sk_state !=3D
TCP_ESTABLISHED) {

But a more robust approach, that also works on existing kernels, is to
swap the default distribution algorithm with a custom BPF based one (
SO_ATTACH_REUSEPORT_EBPF).

