Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEBFA8901
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbfIDOvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:51:40 -0400
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:39992 "EHLO
        resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730067AbfIDOvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:51:39 -0400
Received: from resomta-ch2-09v.sys.comcast.net ([69.252.207.105])
        by resqmta-ch2-10v.sys.comcast.net with ESMTP
        id 5WFpiRip55j7s5WdFieCna; Wed, 04 Sep 2019 14:51:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
        s=20190202a; t=1567608697;
        bh=hEQSwiXwZXq+t2Mq8UckSHPBTEdh1pfpiLtF0nzYnfo=;
        h=Received:Received:Content-Type:Mime-Version:Subject:From:Date:
         Message-Id:To;
        b=WgORJhXDUaZGks+v/1zuEHoqnK4y2TTZdaIq1r+/brCFAsTVzdTNAnr3LxiBFzC9V
         8A/HpNTV01GVomEfbx4kRuW/cyeYWVeCcbFWtS19Ewcb1tld6qVKT0rWAikpk6NlWK
         XikrKnxMNaQu6EzlGP7SW1XfUEBcFKNoODUHJ33tCMPBGOFtol45IxsHIVVafIm6oY
         eQyF+YFShNXe/CLwqpeyr+r4mrgBLEu8QeG6+sxEtcNe9sAtFYiQYsDIIVxOvEa1uU
         i96efzToUujfde1aKHUdQ+CK9gVyPHCavCU8u6O2I4v4qAgY7t3409xD1aR3Xtnzrb
         cu/jo+3LActFg==
Received: from [192.1.18.200] ([192.1.18.200])
        by resomta-ch2-09v.sys.comcast.net with ESMTPSA
        id 5Wcmist2Rsv0O5WcoiW16c; Wed, 04 Sep 2019 14:51:35 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgeduvddrudejhedgjeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurheptggguffhofgjfffgkfhfvfesthhqmhdthhdtvdenucfhrhhomhepufhtvghvvgcukggrsggvlhgvuceoiigrsggvlhgvsegtohhmtggrshhtrdhnvghtqeenucfkphepudelvddruddrudekrddvtddtnecurfgrrhgrmhephhgvlhhopegludelvddruddrudekrddvtddtngdpihhnvghtpeduledvrddurddukedrvddttddpmhgrihhlfhhrohhmpeiirggsvghlvgestghomhgtrghsthdrnhgvthdprhgtphhtthhopeifihhllhgvmhguvggsrhhuihhjnhdrkhgvrhhnvghlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhtvghphhgvnhesnhgvthifohhrkhhplhhumhgsvghrrdhorhhgpdhrtghpthhtohepshgrihhfihdrkhhhrghnsehsthhrihhkrhdrihhnpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgrrhhkrdhkvggrthhonhesrhgrhihthhgvohhnrdgtohhmpdhrtghpthhtohepohhnvdhkudeinhhmsehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrnhhivghlsehiohhgvggrrhgsohigrdhnvghtpdhrtghpthhtohepvhhlrgguihhmihhrudduieesghhmrghilhdrtghomhdprhgtphh
X-Xfinity-VMeta: sc=-100;st=legit
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Is bug 200755 in anyone's queue??
From:   Steve Zabele <zabele@comcast.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
Date:   Wed, 4 Sep 2019 10:51:07 -0400
Cc:     Mark KEATON <mark.keaton@raytheon.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com> <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com> <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com> <00aa01d5630b$7e062660$7a127320$@net> <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com> <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think a dual table approach makes a lot of sense here, especially if we lo=
ok at the different use cases. For the DNS server example, almost certainly t=
here will not be any connected sockets using the server port, so a test of w=
hether the connected table is empty (maybe a boolean stored with the unconne=
cted table?) should get to the existing code very quickly and not require ac=
cessing the memory holding the connected table. For our use case, the connec=
ted sockets persist for long periods (at network timescales at least) and so=
 any rehashing should be infrequent and so have limited impact on performanc=
e overall.

So does a dual table approach seem workable to other folks that know the int=
ernals?

Thanks!

Steve

Sent from my iPhone

> On Sep 4, 2019, at 8:23 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
>=20
>=20
>> On 9/4/19 2:00 PM, Mark KEATON wrote:
>> Hi Willem,
>>=20
>> I am the person who commented on the original bug report in bugzilla.
>>=20
>> In communicating with Steve just now about possible solutions that mainta=
in the efficiency that you are after, what would you think of the following:=
  keep two lists of UDP sockets, those connected and those not connected, an=
d always searching the connected list first.=20
>=20
> This was my suggestion.
>=20
> Note that this requires adding yet another hash table, and yet another loo=
kup
> (another cache line miss per incoming packet)
>=20
> This lookup will slow down DNS and QUIC servers, or any application solely=
 using not connected sockets.
>=20
>=20
> The word 'quick' you use is slightly misleading, since a change like that i=
s a trade off.
> Some applications might become faster, while others become slower.
>=20
> Another issue is that a connect() can follow a bind(), we would need to re=
hash sockets
> from one table to another. (Or add another set of anchors in UDP sockets, s=
o that sockets can be in all the hash tables)
>=20
>=20
> If the connected list is empty, then the lookup can quickly use the not co=
nnected list to find a socket for load balancing.  If there are connected so=
ckets, then only those connected sockets are searched first for an exact mat=
ch.
>>=20
>> Another option might be to do it with a single list if the connected sock=
ets are all at the beginning of the list.  This would require the two separa=
te lookups to start at different points in the list.
>>=20
>> Thoughts?
>>=20
>> Thanks!
>> Mark
>>=20
>>=20
>>> On Sep 4, 2019, at 6:28 AM, Steve Zabele <zabele@comcast.net> wrote:
>>>=20
>>> Hi Willem,
>>>=20
>>> Thanks for continuing to poke at this, much appreciated!
>>>=20
>>>> As for the BPF program: good point on accessing the udp port when
>>>> skb->data is already beyond the header.
>>>=20
>>>> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>>>> Which I think will work, but have not tested.
>>>=20
>>> Please note that the test code was intentionally set up to make testing a=
s simple as possible. Hence the source addresses for the multiple UDP sessio=
ns were identical -- but that is not the general case. In the general case a=
 connected and bound socket should be associated with exactly one five tuple=
 (source and dest addresses, source and destination ports, and protocol.
>>>=20
>>> So a 'connect bpf' would actually need access to the IP addresses as wel=
l, not just the ports. To do this, the load bytes call required negative arg=
uments, which failed miserably when we tried it.
>>>=20
>>> In any event, there remains the issue of figuring out which index to ret=
urn when a match is detected since the index is not the same as the file des=
criptor value and in fact can change as file descriptors are added and delet=
ed. If I understand the kernel mechanism correctly, the operation is somethi=
ng like this. When you add the first one, its assigned to the first slot; wh=
en you add the second its assigned to the second slot; when you delete the f=
irst one, the second is moved to the first slot) so tracking this requires f=
iguring out the order stored in the socket array within the kernel, and upda=
ting the bpf whenever something changes. I don't know if it's even possible t=
o query which slot a given=20
>>>=20
>>> So we think handling this with a bpf is really not viable.
>>>=20
>>> One thing worth mentioning is that the connect mechanism here is meant t=
o (at least used to) work the same as connect does with TCP. Bind sets the e=
xpected/required local address and port; connect sets the expected/required r=
emote address and port -- so a socket file descriptor becomes associated wit=
h exactly one five-tuple. That's how it's worked for several decades anyway.=

>>>=20
>>> Thanks again!!!
>>>=20
>>> Steve
>>>=20
>>> -----Original Message-----
>>> From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]=20
>>> Sent: Tuesday, September 03, 2019 1:56 PM
>>> Cc: Eric Dumazet; Steve Zabele; Network Development; shum@canndrew.org; v=
ladimir116@gmail.com; saifi.khan@strikr.in; Daniel Borkmann; on2k16nm@gmail.=
com; Stephen Hemminger
>>> Subject: Re: Is bug 200755 in anyone's queue??
>>>=20
>>> On Fri, Aug 30, 2019 at 4:30 PM Willem de Bruijn
>>> <willemdebruijn.kernel@gmail.com> wrote:
>>>>=20
>>>>> On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On 8/29/19 9:26 PM, Willem de Bruijn wrote:
>>>>>>=20
>>>>>> SO_REUSEPORT was not intended to be used in this way. Opening
>>>>>> multiple connected sockets with the same local port.
>>>>>>=20
>>>>>> But since the interface allowed connect after joining a group, and
>>>>>> that is being used, I guess that point is moot. Still, I'm a bit
>>>>>> surprised that it ever worked as described.
>>>>>>=20
>>>>>> Also note that the default distribution algorithm is not round robin
>>>>>> assignment, but hash based. So multiple consecutive datagrams arrivin=
g
>>>>>> at the same socket is not unexpected.
>>>>>>=20
>>>>>> I suspect that this quick hack might "work". It seemed to on the
>>>>>> supplied .c file:
>>>>>>=20
>>>>>>                 score =3D compute_score(sk, net, saddr, sport,
>>>>>>                                       daddr, hnum, dif, sdif);
>>>>>>                 if (score > badness) {
>>>>>> -                       if (sk->sk_reuseport) {
>>>>>> +                       if (sk->sk_reuseport && !sk->sk_state !=3D
>>>>>> TCP_ESTABLISHED) {
>>>>=20
>>>> This won't work for a mix of connected and connectionless sockets, of
>>>> course (even ignoring the typo), as it only skips reuseport on the
>>>> connected sockets.
>>>>=20
>>>>>>=20
>>>>>> But a more robust approach, that also works on existing kernels, is t=
o
>>>>>> swap the default distribution algorithm with a custom BPF based one (=

>>>>>> SO_ATTACH_REUSEPORT_EBPF).
>>>>>>=20
>>>>>=20
>>>>> Yes, I suspect that reuseport could still be used by to load-balance i=
ncoming packets
>>>>> targetting the same 4-tuple.
>>>>>=20
>>>>> So all sockets would have the same score, and we would select the firs=
t socket in
>>>>> the list (if not applying reuseport hashing)
>>>>=20
>>>> Can you elaborate a bit?
>>>>=20
>>>> One option I see is to record in struct sock_reuseport if any port in
>>>> the group is connected and, if so, don't return immediately on the
>>>> first reuseport_select_sock hit, but continue the search for a higher
>>>> scoring connected socket.
>>>>=20
>>>> Or do return immediately, but do this refined search in
>>>> reuseport_select_sock itself, as it has a reference to all sockets in t=
he
>>>> group in sock_reuseport->socks[]. Instead of the straightforward hash.
>>>=20
>>> That won't work, as reuseport_select_sock does not have access to
>>> protocol specific data, notably inet_dport.
>>>=20
>>> Unfortunately, what I've come up with so far is not concise and slows
>>> down existing reuseport lookup in a busy port table slot. Note that it
>>> is needed for both ipv4 and ipv6.
>>>=20
>>> Do not break out of the port table slot early, but continue to search
>>> for a higher scored match even after matching a reuseport:
>>>=20
>>> "
>>>  @@ -413,28 +413,39 @@ static struct sock *udp4_lib_lookup2(struct net *=
net,
>>>                                    struct udp_hslot *hslot2,
>>>                                    struct sk_buff *skb)
>>> {
>>> +       struct sock *reuseport_result =3D NULL;
>>>       struct sock *sk, *result;
>>> +       int reuseport_score =3D 0;
>>>       int score, badness;
>>>       u32 hash =3D 0;
>>>=20
>>>       result =3D NULL;
>>>       badness =3D 0;
>>>       udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
>>>               score =3D compute_score(sk, net, saddr, sport,
>>>                                     daddr, hnum, dif, sdif);
>>>               if (score > badness) {
>>> -                       if (sk->sk_reuseport) {
>>> +                       if (sk->sk_reuseport &&
>>> +                           sk->sk_state !=3D TCP_ESTABLISHED &&
>>> +                           !reuseport_result) {
>>>                               hash =3D udp_ehashfn(net, daddr, hnum,
>>>                                                  saddr, sport);
>>> -                               result =3D reuseport_select_sock(sk, has=
h, skb,
>>> +                               reuseport_result =3D
>>> reuseport_select_sock(sk, hash, skb,
>>>                                                       sizeof(struct udph=
dr));
>>> -                               if (result)
>>> -                                       return result;
>>> +                               if (reuseport_result)
>>> +                                       reuseport_score =3D score;
>>> +                               continue;
>>>                       }
>>>                       badness =3D score;
>>>                       result =3D sk;
>>>               }
>>>       }
>>> +
>>> +       if (badness < reuseport_score)
>>> +               result =3D reuseport_result;
>>> +
>>>       return result;
>>> "
>>>=20
>>> To break out after the first reuseport hit when it is safe, i.e., when
>>> it holds no connected sockets, requires adding this state to struct
>>> reuseport_sock at __ip4_datagram_connect. And modify
>>> reuseport_select_sock to read this. At least, I have not found a more
>>> elegant solution.
>>>=20
>>>> Steve, Re: your point on a scalable QUIC server. That is an
>>>> interesting case certainly. Opening a connected socket per flow adds
>>>> both memory and port table pressure. I once looked into an SO_TXONLY
>>>> udp socket option that does not hash connected sockets into the port
>>>> table. In effect receiving on a small set of listening sockets (e.g.,
>>>> one per cpu) and sending over separate tx-only sockets. That still
>>>> introduces unnecessary memory allocation. OTOH it amortizes some
>>>> operations, such as route lookup.
>>>>=20
>>>> Anyway, that does not fix the immediate issue you reported when using
>>>> SO_REUSEPORT as described.
>>>=20
>>> As for the BPF program: good point on accessing the udp port when
>>> skb->data is already beyond the header.
>>>=20
>>> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>>> Which I think will work, but have not tested.
>>>=20
>>> As of kernel 4.19 programs of type BPF_PROG_TYPE_SK_REUSEPORT can be
>>> attached (with CAP_SYS_ADMIN). See
>>> tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c for an
>>> example that parses udp headers with bpf_skb_load_bytes.
>>>=20

