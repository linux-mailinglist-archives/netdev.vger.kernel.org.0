Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280BFA82BF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfIDMZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:25:13 -0400
Received: from dfw-mailout10.raytheon.com ([199.46.199.220]:50670 "EHLO
        dfw-mailout10.raytheon.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfIDMZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 08:25:12 -0400
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2019 08:25:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raytheon.com; h=from : to : cc :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version : subject; s=dkim2017;
 bh=fX+hgr02YQuc1GZqiJeoluRKf+rZ/MSU31hLvjw/uQg=;
 b=yFv2wv8C/+yyhbv8BQk5q+UGBGWtQ4oSs98JeAVza3TJKy7dEjGHWV3Uhln7424pQYGA
 b456OcCNkjo2nfnZzCdA7gp5hueZH+dy0MT/lq012lCQjw6MuWNC8FNja94ICkCF3gSr
 ohT06mqu4TeE9OHTfStaj5xdX6iut8dqzDEgRDk17lRmJhuliOsxSgFlWkU0IpF6kCId
 Gg7ENEQPrCvHTMdESyKabfRNoSV/TE/+QENL083gm0ct1CZCEtPxX+PyNPOTCAX/NegX
 gMsekCJGdWXj6PCLbX0DUWjHEEOHGemE8sJjW6Ya6X8lX9DtBlQ8YXJs5GRL0irzrWwu 7A== 
Received: from tx-mailout20.rtnmail.ray.com (tx-mailout20.rtnmail.ray.com [138.126.127.235])
        by dfw-mailout10.ext.ray.com (8.16.0.27/8.16.0.27) with ESMTPS id x84C0fnK016343
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 12:00:41 GMT
Received: from 008-smtp-out.ray.com ([23.103.12.212])
        by tx-mailout20.rtnmail.ray.com (8.16.0.27/8.16.0.27) with ESMTPS id x84C0f2Z031168
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 12:00:41 GMT
Received: from CY1F00803MB0037.008f.mgd2.msft.net (23.103.12.209) by
 CY1F00803MB0040.008f.mgd2.msft.net (23.103.12.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2136.30; Wed, 4 Sep 2019 12:00:40 +0000
Received: from CY1F00803MB0037.008f.mgd2.msft.net ([23.103.12.209]) by
 CY1F00803MB0037.008f.mgd2.msft.net ([23.103.12.209]) with mapi id
 15.20.2136.029; Wed, 4 Sep 2019 12:00:40 +0000
From:   Mark KEATON <mark.keaton@raytheon.com>
To:     Steve Zabele <zabele@comcast.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: RE: Is bug 200755 in anyone's queue??
Thread-Topic: [External] RE: Is bug 200755 in anyone's queue??
Thread-Index: AdVigOLv32ofXOqlSUCezHMwRQbyvAAheY+AAARkPgA=
Date:   Wed, 4 Sep 2019 12:00:40 +0000
Message-ID: <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
References: <010601d53bdc$79c86dc0$6d594940$@net>
 <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net>
 <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
 <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net>
In-Reply-To: <00aa01d5630b$7e062660$7a127320$@net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [23.103.12.4]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY1F00803MB0040:
Content-Type: text/plain; charset="us-ascii"
Content-ID: <42BDE720AB5CB04884BD9D86AD0B0F44@mgd.ray.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CC:   eric.dumazet@gmail.com, netdev@vger.kernel.org, shum@canndrew.org,
 vladimir116@gmail.com, saifi.khan@strikr.in, daniel@iogearbox.net,
 on2k16nm@gmail.com, stephen@networkplumber.org, zabele@comcast.net,
 willemdebruijn.kernel@gmail.com
X-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_03:,,
 signatures=0
X-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_03:,,
 signatures=0
X-DMZ-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040122
X-DMZ-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

I am the person who commented on the original bug report in bugzilla.

In communicating with Steve just now about possible solutions that maintain=
 the efficiency that you are after, what would you think of the following: =
 keep two lists of UDP sockets, those connected and those not connected, an=
d always searching the connected list first.  If the connected list is empt=
y, then the lookup can quickly use the not connected list to find a socket =
for load balancing.  If there are connected sockets, then only those connec=
ted sockets are searched first for an exact match.

Another option might be to do it with a single list if the connected socket=
s are all at the beginning of the list.  This would require the two separat=
e lookups to start at different points in the list.

Thoughts?

Thanks!
Mark


> On Sep 4, 2019, at 6:28 AM, Steve Zabele <zabele@comcast.net> wrote:
>=20
> Hi Willem,
>=20
> Thanks for continuing to poke at this, much appreciated!
>=20
>> As for the BPF program: good point on accessing the udp port when
>> skb->data is already beyond the header.
>=20
>> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>> Which I think will work, but have not tested.
>=20
> Please note that the test code was intentionally set up to make testing a=
s simple as possible. Hence the source addresses for the multiple UDP sessi=
ons were identical -- but that is not the general case. In the general case=
 a connected and bound socket should be associated with exactly one five tu=
ple (source and dest addresses, source and destination ports, and protocol.
>=20
> So a 'connect bpf' would actually need access to the IP addresses as well=
, not just the ports. To do this, the load bytes call required negative arg=
uments, which failed miserably when we tried it.
>=20
> In any event, there remains the issue of figuring out which index to retu=
rn when a match is detected since the index is not the same as the file des=
criptor value and in fact can change as file descriptors are added and dele=
ted. If I understand the kernel mechanism correctly, the operation is somet=
hing like this. When you add the first one, its assigned to the first slot;=
 when you add the second its assigned to the second slot; when you delete t=
he first one, the second is moved to the first slot) so tracking this requi=
res figuring out the order stored in the socket array within the kernel, an=
d updating the bpf whenever something changes. I don't know if it's even po=
ssible to query which slot a given=20
>=20
> So we think handling this with a bpf is really not viable.
>=20
> One thing worth mentioning is that the connect mechanism here is meant to=
 (at least used to) work the same as connect does with TCP. Bind sets the e=
xpected/required local address and port; connect sets the expected/required=
 remote address and port -- so a socket file descriptor becomes associated =
with exactly one five-tuple. That's how it's worked for several decades any=
way.
>=20
> Thanks again!!!
>=20
> Steve
>=20
> -----Original Message-----
> From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]=20
> Sent: Tuesday, September 03, 2019 1:56 PM
> Cc: Eric Dumazet; Steve Zabele; Network Development; shum@canndrew.org; v=
ladimir116@gmail.com; saifi.khan@strikr.in; Daniel Borkmann; on2k16nm@gmail=
.com; Stephen Hemminger
> Subject: Re: Is bug 200755 in anyone's queue??
>=20
> On Fri, Aug 30, 2019 at 4:30 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>=20
>> On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> wr=
ote:
>>>=20
>>>=20
>>>=20
>>> On 8/29/19 9:26 PM, Willem de Bruijn wrote:
>>>=20
>>>> SO_REUSEPORT was not intended to be used in this way. Opening
>>>> multiple connected sockets with the same local port.
>>>>=20
>>>> But since the interface allowed connect after joining a group, and
>>>> that is being used, I guess that point is moot. Still, I'm a bit
>>>> surprised that it ever worked as described.
>>>>=20
>>>> Also note that the default distribution algorithm is not round robin
>>>> assignment, but hash based. So multiple consecutive datagrams arriving
>>>> at the same socket is not unexpected.
>>>>=20
>>>> I suspect that this quick hack might "work". It seemed to on the
>>>> supplied .c file:
>>>>=20
>>>>                  score =3D compute_score(sk, net, saddr, sport,
>>>>                                        daddr, hnum, dif, sdif);
>>>>                  if (score > badness) {
>>>>  -                       if (sk->sk_reuseport) {
>>>>  +                       if (sk->sk_reuseport && !sk->sk_state !=3D
>>>> TCP_ESTABLISHED) {
>>=20
>> This won't work for a mix of connected and connectionless sockets, of
>> course (even ignoring the typo), as it only skips reuseport on the
>> connected sockets.
>>=20
>>>>=20
>>>> But a more robust approach, that also works on existing kernels, is to
>>>> swap the default distribution algorithm with a custom BPF based one (
>>>> SO_ATTACH_REUSEPORT_EBPF).
>>>>=20
>>>=20
>>> Yes, I suspect that reuseport could still be used by to load-balance in=
coming packets
>>> targetting the same 4-tuple.
>>>=20
>>> So all sockets would have the same score, and we would select the first=
 socket in
>>> the list (if not applying reuseport hashing)
>>=20
>> Can you elaborate a bit?
>>=20
>> One option I see is to record in struct sock_reuseport if any port in
>> the group is connected and, if so, don't return immediately on the
>> first reuseport_select_sock hit, but continue the search for a higher
>> scoring connected socket.
>>=20
>> Or do return immediately, but do this refined search in
>> reuseport_select_sock itself, as it has a reference to all sockets in th=
e
>> group in sock_reuseport->socks[]. Instead of the straightforward hash.
>=20
> That won't work, as reuseport_select_sock does not have access to
> protocol specific data, notably inet_dport.
>=20
> Unfortunately, what I've come up with so far is not concise and slows
> down existing reuseport lookup in a busy port table slot. Note that it
> is needed for both ipv4 and ipv6.
>=20
> Do not break out of the port table slot early, but continue to search
> for a higher scored match even after matching a reuseport:
>=20
> "
>   @@ -413,28 +413,39 @@ static struct sock *udp4_lib_lookup2(struct net *=
net,
>                                     struct udp_hslot *hslot2,
>                                     struct sk_buff *skb)
> {
> +       struct sock *reuseport_result =3D NULL;
>        struct sock *sk, *result;
> +       int reuseport_score =3D 0;
>        int score, badness;
>        u32 hash =3D 0;
>=20
>        result =3D NULL;
>        badness =3D 0;
>        udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
>                score =3D compute_score(sk, net, saddr, sport,
>                                      daddr, hnum, dif, sdif);
>                if (score > badness) {
> -                       if (sk->sk_reuseport) {
> +                       if (sk->sk_reuseport &&
> +                           sk->sk_state !=3D TCP_ESTABLISHED &&
> +                           !reuseport_result) {
>                                hash =3D udp_ehashfn(net, daddr, hnum,
>                                                   saddr, sport);
> -                               result =3D reuseport_select_sock(sk, hash=
, skb,
> +                               reuseport_result =3D
> reuseport_select_sock(sk, hash, skb,
>                                                        sizeof(struct udph=
dr));
> -                               if (result)
> -                                       return result;
> +                               if (reuseport_result)
> +                                       reuseport_score =3D score;
> +                               continue;
>                        }
>                        badness =3D score;
>                        result =3D sk;
>                }
>        }
> +
> +       if (badness < reuseport_score)
> +               result =3D reuseport_result;
> +
>        return result;
> "
>=20
> To break out after the first reuseport hit when it is safe, i.e., when
> it holds no connected sockets, requires adding this state to struct
> reuseport_sock at __ip4_datagram_connect. And modify
> reuseport_select_sock to read this. At least, I have not found a more
> elegant solution.
>=20
>> Steve, Re: your point on a scalable QUIC server. That is an
>> interesting case certainly. Opening a connected socket per flow adds
>> both memory and port table pressure. I once looked into an SO_TXONLY
>> udp socket option that does not hash connected sockets into the port
>> table. In effect receiving on a small set of listening sockets (e.g.,
>> one per cpu) and sending over separate tx-only sockets. That still
>> introduces unnecessary memory allocation. OTOH it amortizes some
>> operations, such as route lookup.
>>=20
>> Anyway, that does not fix the immediate issue you reported when using
>> SO_REUSEPORT as described.
>=20
> As for the BPF program: good point on accessing the udp port when
> skb->data is already beyond the header.
>=20
> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
> Which I think will work, but have not tested.
>=20
> As of kernel 4.19 programs of type BPF_PROG_TYPE_SK_REUSEPORT can be
> attached (with CAP_SYS_ADMIN). See
> tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c for an
> example that parses udp headers with bpf_skb_load_bytes.
>=20
