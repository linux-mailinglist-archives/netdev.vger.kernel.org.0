Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D15F2357A8
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgHBOuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:50:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34169 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgHBOuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:50:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9DB945C00E6;
        Sun,  2 Aug 2020 10:50:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 02 Aug 2020 10:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=y/nYC4p0UxNIRmwsxd+rin2nG9iUGSm1VZkNUIQ31
        PY=; b=Xa/6oNg7cc97O/VFWJOW4gNn3JXno//0kPCTBIt864tZxeOEWfYNq/Qn1
        8kScGv7/itbf/sD1cjz0OnFRVPqPSoFCQFyhvTLV37C4IP0wOr0yxsvQq5nuaK93
        ecFKUWy30lQKOp+a1A8HrcZjGJDuEP6nEERZnBcyqz4uXRbzqZ3jotxN0vrTT3/1
        m3Ir6WSEd4zSRqS3irYqnJVCWSgATYaknpcxJtgWRi2fczjvavzNlXbOKCkBS8U3
        hLhrwjEmOXn3ckL5t88ZWCCX1u+Sekk9wvPn2CtJtNiW7Q6uewItlVDIxdcXISWa
        mic9cDGjVZ/DkGUwTB+kmKePCysJg==
X-ME-Sender: <xms:mtImX_G9rUHQN3SOK6EmZ7gqG-S34tZGqMUYaihocc2TxHTBZSgaaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedvgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffgeehueffgfefteduvdfgteekveffjefhgefgffegtdevjeeukeeivddtveeg
    teenucffohhmrghinheptghumhhulhhushhnvghtfihorhhkshdrtghomhenucfkphepje
    elrddukedurddvrddujeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:m9ImX8WBwm8v7Heyb4lpi1WZZFA69FqP9mbcBJYEZyvWLm9QzZ3qzA>
    <xmx:m9ImXxKXZMWq-QVEmcePov19dniC7zDibEjZUMGYn36PLxMfn4XGUQ>
    <xmx:m9ImX9HqCZG2WLcWBGAxLyVqOXKPB-ycy8hQWH9vylXFBPW2dfr7dQ>
    <xmx:m9ImX0BI6cJSw1GkylJtf2FkKO-zWvfaAbXfVYzp6b-OMm3eqsPQ6A>
Received: from localhost (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 472FC3060067;
        Sun,  2 Aug 2020 10:50:02 -0400 (EDT)
Date:   Sun, 2 Aug 2020 17:49:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Yi Yang =?utf-8?B?KOadqOeHmikt5LqR5pyN5Yqh6ZuG5Zui?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGNhbiBj?= =?utf-8?Q?urren?=
 =?utf-8?Q?t?= ECMP implementation support consistent hashing for next hop?
Message-ID: <20200802144959.GA2483264@shredder>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
 <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 10:36:59PM -0600, David Ahern wrote:
> On 6/11/20 6:32 PM, Yi Yang (杨燚)-云服务集团 wrote:
> > David, thank you so much for confirming it can't, I did read your cumulus document before, resilient hashing is ok for next hop remove, but it still has the same issue there if add new next hop. I know most of kernel code in Cumulus Linux has been in upstream kernel, I'm wondering why you didn't push resilient hashing to upstream kernel.
> > 
> > I think consistent hashing is must-have for a commercial load balancing solution, otherwise it is basically nonsense , do you Cumulus Linux have consistent hashing solution?
> > 
> > Is "- replacing nexthop entries as LB's come and go" ithe stuff https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hashing is showing? It can't ensure the flow is distributed to the right backend server if a new next hop is added.
> 
> I do not believe it is a problem to be solved in the kernel.
> 
> If you follow the *intent* of the Cumulus document: what is the maximum
> number of load balancers you expect to have? 16? 32? 64? Define an ECMP
> route with that number of nexthops and fill in the weighting that meets
> your needs. When an LB is added or removed, you decide what the new set
> of paths is that maintains N-total paths with the distribution that
> meets your needs.

I recently started looking into consistent hashing and I wonder if it
can be done with the new nexthop API while keeping all the logic in user
space (e.g., FRR).

The only extension that might be required from the kernel is a new
nexthop attribute that indicates when a nexthop was last recently used.
User space can then use it to understand which nexthops to replace when
a new nexthop is added and when to perform the replacement. In case the
nexthops are offloaded, it is possible for the driver to periodically
update the nexthop code about their activity.

Below is a script that demonstrates the concept with the example in the
Cumulus documentation. I chose to replace the individual nexthops
instead of creating new ones and then replacing the group.

It is obviously possible to create larger groups to reduce the impact on
existing flows when a new nexthop is added.

WDYT?

```
#!/bin/bash

### Setup ####

IP="ip -n testns"

ip netns add testns

$IP link add name dummy_a up type dummy
$IP link add name dummy_b up type dummy
$IP link add name dummy_c up type dummy
$IP link add name dummy_d up type dummy
$IP link add name dummy_e up type dummy

$IP route add 1.1.1.0/24 dev dummy_a
$IP route add 2.2.2.0/24 dev dummy_b
$IP route add 3.3.3.0/24 dev dummy_c
$IP route add 4.4.4.0/24 dev dummy_d
$IP route add 5.5.5.0/24 dev dummy_e

### Initial nexthop configuration ####
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hash-buckets

$IP nexthop replace id 1 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 2 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 3 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 4 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 5 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 6 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 7 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 8 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 9 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 10 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 11 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 12 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 10000 group 1/2/3/4/5/6/7/8/9/10/11/12

echo
echo "Initial state:"
echo
$IP nexthop show

### Nexthop B is removed ###
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#remove-next-hops

$IP nexthop replace id 2 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 6 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 10 via 4.4.4.4 dev dummy_d

echo
echo "After nexthop B was removed:"
echo
$IP nexthop show

### Initial state restored ####

$IP nexthop replace id 2 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 6 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 10 via 2.2.2.2 dev dummy_b

echo
echo "After intial state was restored:"
echo
$IP nexthop show

### Nexthop E is added ####
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#add-next-hops

# Nexthop 2, 5, 8 are active. Replace in a way that minimizes
# interruptions.
$IP nexthop replace id 1 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 2 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 3 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 4 via 5.5.5.5 dev dummy_e
# Nexthop 5 remains the same
# Nexthop 6 remains the same
# Nexthop 7 remains the same
# Nexthop 8 remains the same
$IP nexthop replace id 9 via 5.5.5.5 dev dummy_e
$IP nexthop replace id 10 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 11 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 12 via 3.3.3.3 dev dummy_c

echo
echo "After nexthop E was added:"
echo
$IP nexthop show

ip netns del testns
```

> 
> I just sent patches for active-backup nexthops that allows an automatic
> fallback when one is removed to address the redistribution problem, but
> it still requires userspace to decide what the active-backup pairs are
> as well as the maximum number of paths.
