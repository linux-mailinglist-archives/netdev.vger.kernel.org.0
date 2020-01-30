Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5914D8ED
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 11:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgA3K20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 05:28:26 -0500
Received: from mail.katalix.com ([3.9.82.81]:52782 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgA3K20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 05:28:26 -0500
Received: from [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b] (unknown [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id D02F78CC10;
        Thu, 30 Jan 2020 10:28:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1580380103; bh=F42t5+89qGRGfgI1MMkECLjdwUPwDud1Dmh76FY47JY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0+tLGf/ETwn8qPOAM920cyqQzWDiDnfBBghjUxbM0CtS5pR+8kbIgjBGSUFY1IDGh
         lxneiPgKXfbkM2GKEZxigxN4RaNMnDZ/KAX7DNHXno1K0aLeqnxT2LAJA/F0e9rnPj
         2Uym/y8ThmIKAp89LSF5iPjKZcryME3PkusewrQAaChLb7rShJsLT7Ap/wuM4rfrZt
         Rps+S/LhkQ+n7B2zJC7bRtEiJHBkhwySpTeGpsXzlr6TCcwd0g0oPzsVe87D2tZWnU
         LimvHaWX1WLCvnMevYgcFh67JF6doKgiBDN2RTKkNFPn665TVAhwUsLO7atjwYD7nI
         MWHeKHPcDqgeg==
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
References: <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw> <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw> <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw> <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
Date:   Thu, 30 Jan 2020 10:28:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129114419.GA11337@pc-61.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/01/2020 11:44, Guillaume Nault wrote:
> On Mon, Jan 27, 2020 at 09:25:30AM +0000, James Chapman wrote:
>> On 25/01/2020 11:57, Guillaume Nault wrote:
>>> On Wed, Jan 22, 2020 at 11:55:35AM +0000, James Chapman wrote:
>>>> In my experience, poor L2TP data performance is usually the result o=
f
>>>> MTU config issues causing IP fragmentation in the tunnel. L2TPv3
>>>> ethernet throughput is similar to ethernet bridge throughput in the
>>>> setups that I know of.
>>>>
>>> I said that because I remember I had tested L2TPv3 and VXLAN a few
>>> years ago and I was surprised by the performance gap. I certainly can=
't
>>> remember the details of the setup, but I'd be very surprised if I had=

>>> misconfigured the MTU.
>> Fair enough. I'd be interested in your observations and ideas regardin=
g
>> improving performance at some point. But I suggest keep this thread
>> focused on the session ID scope issue.
>>
> I had started working on the data path more than a year ago, but never
> got far enough to submit anything. I might revive this work if I find
> enough time. But yes, sure, let's focus on the sessions IDs for now.
>
>>>> I can't see how replacing a lookup using a 32-bit hash key with one
>>>> using a 260-bit or more key (128+128+4 for two IPv[46] addresses and=

>>>> the session ID) isn't going to hurt performance, let alone the
>>>> per-session memory footprint. In addition, it is changing the scope =
of
>>>> the session ID away from what is defined in the RFC.
>>>>
>>> I don't see why we'd need to increase the l2tp_session's structure si=
ze.
>>> We can already get the 3/5-tuple from the parent's tunnel socket. And=

>>> there are some low hanging fruits to pick if one wants to reduce L2TP=
's
>>> memory footprint.
>>>
>>> From a performance point of view, 3/5-tuple matches are quite common
>>> operations in the networking stack. I don't expect that to be costly
>>> compared to the rest of the L2TP Rx operations. And we certainly have=

>>> room to streamline the datapath if necessary.
>> I was assuming the key used for the session ID lookup would be stored
>> with the session so that we wouldn't have to prepare it for each and
>> every packet receive.
>>
> I don't think that we could store the hash in the session structure.
> The tunnel socket could be rebound or reconnected, thus changing the
> 5/3-tuple from under us.
>
> My idea was to lookup the hash bucket using only the session ID, then
> select the session from this bucket by checking both the session ID and=

> the 5/3-tuple.

Ah I see. I'm more comfortable with this now.


>>>> I think Linux shouldn't diverge from the spirit of the L2TPv3 RFC
>>>> since the RFC is what implementors code against. Ridge's application=

>>>> relies on duplicated L2TPv3 session IDs which are scoped by the UDP
>>>> 5-tuple address. But equally, there may be existing applications out=

>>>> there which rely on Linux performing L2TPv3 session lookup by sessio=
n
>>>> ID alone, as per the RFC. For IP-encap, Linux already does this, but=

>>>> not for UDP. What if we get a request to do so for UDP, for
>>>> RFC-compliance? It would be straightforward to do as long as the
>>>> session ID scope isn't restricted by the proposed patch.
>>>>
>>> As long as the external behavior conforms to the RFC, I don't see any=

>>> problem. Local applications are still responsible for selecting
>>> session-IDs. I don't see how they could be confused if the kernel
>>> accepted more IDs, especially since that was the original behaviour.
>> But it wouldn't conform with the RFC.
>>
>> RFC3931 says:
>>
>> =C2=A0The Session ID alone provides the necessary context for all furt=
her
>> =C2=A0packet processing, including the presence, size, and value of th=
e
>> =C2=A0Cookie, the type of L2-Specific Sublayer, and the type of payloa=
d
>> =C2=A0being tunneled.
>>
>> and also
>>
>> =C2=A0The data message format for tunneling data packets may be utiliz=
ed
>> =C2=A0with or without the L2TP control channel, either via manual
>> =C2=A0configuration or via other signaling methods to pre-configure or=

>> =C2=A0distribute L2TP session information.
>>
> Since userspace is in charge of selecting the session ID, I still can't=

> see how having the kernel accept duplicate IDs goes against the RFC.
> The kernel doesn't assign duplicate IDs on its own. Userspace has full
> control on the IDs and can implement whatever constraint when assigning=

> session IDs (even the DOCSIS DEPI way of partioning the session ID
> space).
Perhaps another example might help.

Suppose there's an L2TPv3 app out there today that creates two tunnels
to a peer, one of which is used as a hot-standby backup in case the main
tunnel fails. This system uses separate network interfaces for the
tunnels, e.g. a router using a mobile network as a backup. If the main
tunnel fails, it switches traffic of sessions immediately into the
second tunnel. Userspace is deliberately using the same session IDs in
both tunnels in this case. This would work today for IP-encap, but not
for UDP. However, if the kernel treats session IDs as scoped by 3-tuple,
the application would break. The app would need to be modified to add
each session ID into both tunnels to work again.


>>> I would have to read the RFC with scoped session IDs in mind, but, as=

>>> far as I can see, the only things that global session IDs allow which=

>>> can't be done with scoped session IDs are:
>>>   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
>>>     vice-versa.
>>>   * Accepting L2TPv3 packets from peers we're not connected to.
>>>
>>> I don't find any of these to be desirable. Although Tom convinced me
>>> that global session IDs are in the spirit of the RFC, I still don't
>>> think that restricting their scope goes against it in any practical
>>> way. The L2TPv3 control plane requires a two way communication, which=

>>> means that the session is bound to a given 3/5-tuple for control
>>> messages. Why would the data plane behave differently?
>> The Cable Labs / DOCSIS DEPI protocol is a good example. It is based o=
n
>> L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
>> unscoped and not associated with a given tunnel.
>>
> Fair enough. Then we could add a L2TP_ATTR_SCOPE netlink attribute to
> sessions. A global scope would reject the session ID if another session=

> already exists with this ID in the same network namespace. Sessions wit=
h
> global scope would be looked up solely based on their ID. A non-global
> scope would allow a session ID to be duplicated as long as the 3/5-tupl=
e
> is different and no session uses this ID with global scope.
>
>>> I agree that it looks saner (and simpler) for a control plane to neve=
r
>>> assign the same session ID to sessions running over different tunnels=
,
>>> even if they have different 3/5-tuples. But that's the user space
>>> control plane implementation's responsability to select unique sessio=
n
>>> IDs in this case. The fact that the kernel uses scoped or global IDs =
is
>>> irrelevant. For unmanaged tunnels, the administrator has complete
>>> control over the local and remote session IDs and is free to assign
>>> them globally if it wants to, even if the kernel would have accepted
>>> reusing session IDs.
>> I disagree. Using scoped session IDs may break applications that assum=
e
>> RFC behaviour. I mentioned one example where session IDs are used
>> unscoped above.
>>
> I'm sorry, but I still don't understand how could that break any
> existing application.

Does my example of the hot-standby backup tunnel help?


> For L2TPoUDP, session IDs are always looked up in the context of the
> UDP socket. So even though the kernel has stopped accepting duplicate
> IDs, the session IDs remain scoped in practice. And with the
> application being responsible for assigning IDs, I don't see how making=

> the kernel less restrictive could break any existing implementation.
> Again, userspace remains in full control for session ID assignment
> policy.
>
> Then we have L2TPoIP, which does the opposite, always looks up sessions=

> globally and depends on session IDs being unique in the network
> namespace. But Ridge's patch does not change that. Also, by adding the
> L2TP_ATTR_SCOPE attribute (as defined above), we could keep this
> behaviour (L2TPoIP session could have global scope by default).

I'm looking at this with an end goal of having the UDP rx path later
modified to work the same way as IP-encap currently does. I know Linux
has never worked this way in the L2TPv3 UDP path and no-one has
requested that it does yet, but I think it would improve the
implementation if UDP and IP encap behaved similarly.

L2TP_ATTR_SCOPE would be a good way for the app to select which
behaviour it prefers.


>>>> Could we ask Ridge to submit a new version of his patch which includ=
es
>>>> a knob to enable it?
>>>>
>>> But what would be the default behaviour? If it's "use global IDs", th=
en
>>> we'll keep breaking applications that used to work with older kernels=
=2E
>>> Ridge would know how to revert to the ancient behaviour, but other
>>> users would probably never know about the knob. And if we set the
>>> default behaviour to "allow duplicate IDs for L2TPv3oUDP", then the
>>> knob doesn't need to be implemented as part of Ridge's fix. It can
>>> always be added later, if we ever decide to unify session lookups
>>> accross L2TPoUDP and L2TPoIP and that extending the session hash key
>>> proves not to be a practical solution.
>>
>> The default would be the current behaviour: "global IDs". We'll be
>> breaking applications that assume scoped session IDs, yes. But I think=

>> the number of these applications will be minimal given the RFC is clea=
r
>> that session IDs are unscoped and the kernel has worked this way for
>> almost 3 years.
>>
>> I think it's important that the kernel continues to treat the L2TPv3
>> session ID as "global".
>>
> I'm uncomfortable with this. 3 years is not that long, it's the typical=

> long term support time for community kernels (not even mentioning
> "enterprise" distributions). Also, we have a report showing that the
> current behaviour broke some use cases, while we never had any problem
> reported for the ancient behaviour (which had been in place for 7
> years).=20
This is the policy decision. I see pros and cons both ways. But perhaps
it's ok as long as the session ID can be treated as unscoped as a config
option. See later.

> And finally, rejecting duplicate IDs, won't make the session ID
> space global. As I pointed out earlier, L2TPoUDP sessions are still
> going to be scoped in practice, because that's how lookup is done
> currently. So I don't see what would be the benefit of artificially
> limitting the sessions IDs accepted by the kernel (but I agree that
> L2TPoIP session IDs have to remain unique in the network namespace).

I'd like UDP and IP to eventually work the same way.


>> However, there might be an alternative solution to fix this for Ridge'=
s
>> use case that doesn't involve adding 3/5-tuple session ID lookups in t=
he
>> receive path or adding a control knob...
>>
>> My understanding is that Ridge's application uses unmanaged tunnels
>> (like "ip l2tp" does). These use kernel sockets. The netlink tunnel
>> create request does not indicate a valid tunnel socket fd. So we could=

>> use scoped session IDs for unmanaged UDP tunnels only. If Ridge's patc=
h
>> were tweaked to allow scoped IDs only for UDP unmanaged tunnels (addin=
g
>> a test for tunnel->fd < 0), managed tunnels would continue to work as
>> they do now and any application that uses unmanaged tunnels would get
>> scoped session IDs. No control knob or 3/5-tuple session ID lookups
>> required.
>>
> Well, I'd prefer to not introduce another subtle behaviour change. What=

> does rejecting duplicate IDs bring us if the lookup is still done in
> the context of the socket? If the point is to have RFC compliance, then=

> we'd also need to modify the lookup functions.
I agree, it's not ideal. Rejecting duplicate IDs for UDP will allow the
UDP rx path to be modified later to work the same way as IP. So my idea
was to allow for that change to be made later but only for managed
tunnels (sockets created by userspace). My worry with the original patch
is that it suggests that session IDs for UDP are always scoped by the
tunnel so tweaking it to apply only for unmanaged tunnels was a way of
showing this.

However, you've convinced me now that scoping the session ID by
3/5-tuple could work. As long as there's a mechanism that lets
applications choose whether the 3/5-tuple is ignored in the rx path, I'm
ok with it.



