Return-Path: <netdev+bounces-8272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A9272379D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 042131C208FF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E7C3D8A;
	Tue,  6 Jun 2023 06:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A6C2114
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:25:36 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA2810D3;
	Mon,  5 Jun 2023 23:25:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 96391601A8;
	Tue,  6 Jun 2023 08:25:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686032729; bh=rjPsMuGvKZwQ0U+WkOYb2CanbJCvdc78Dm+dRdNT2KU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=BhtJLtJYjBLaKm3E8xnID9Kmz6Ourd86jqyCoonDdTgWgJ5dGz1BUrEdv7DJpe32e
	 vDKLEi4pk0Nd/cJSVJy08L+xkSkMIbquAMj25pHMQbaYg7TE+JplU1kXZ1onfb7vxA
	 pp4paEut2OGFTIBu26jFKn97J0PuLH1Ms9RfN/HbuZGkhhSVADr71Johk6pWH4sJUH
	 eO0hCeMulqcC0Flj7gR0dtnxcmRcPvmNrHho9e/cXMg8jvTBM+uolxBFEQ1dLg26cP
	 gjdIPugRWPxVDX9RtGGDpk3JEl6ese60uve6NbTH4ZGFcWj6QREJHC81zAEFqnkpXq
	 rYqtzAlEYbLEg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hvSNORR0uzKf; Tue,  6 Jun 2023 08:25:27 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 68353601A7;
	Tue,  6 Jun 2023 08:24:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686032727; bh=rjPsMuGvKZwQ0U+WkOYb2CanbJCvdc78Dm+dRdNT2KU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=aC0wknAHsqPblClIELwQ8CrmFLBikkJqUz03jCU0JPdiRjQJ1aop+CIjeXh++ASy2
	 I6KJczErPI7HLRI+bfOk3qKU+3u3DIRKKARK+hz8IakUS5pQW74nKqVmeOSbCowXi5
	 39PA2ZO3BVLvYcNOQRxLwGvjgR/xS/YS2+LTYcfyg2BlngsKSaUh8fEBQXGJYSz+So
	 wBlqjSpYuQ2vNVDfK7d2lITVuwJBtr4vMuS8ztgOq+N7Rq4HBCCogu95FO5PU6Tkqa
	 /w9Y9TZWn5I9YA60bLKmzNhlekpnixy+GJyQcRPhkZ4xLxWQXCtQDMcenrvffkhXxO
	 Mmh7Co1UJKJ/w==
Message-ID: <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
Date: Tue, 6 Jun 2023 08:24:54 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian>
Content-Language: en-US
In-Reply-To: <ZHeN3bg28pGFFjJN@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/23 20:11, Guillaume Nault wrote:
> On Wed, May 24, 2023 at 02:17:09PM +0200, Mirsad Todorovac wrote:
>> Hi,
> 
> Hi Mirsad,
> 
>> The very recent 6.4-rc3 kernel build with AlmaLinux 8.7 on LENOVO 10TX000VCR
>> desktop box fails one test:
>>
>> [root@host net]# ./fcnal-test.sh
>> [...]
>> TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
>> TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [FAIL]
>> TEST: ping in - ns-A IPv6                                                     [ OK ]
>> [...]
>> Tests passed: 887
>> Tests failed:   1
>> [root@host net]#
> 
> This test also fails on -net. The problem is specific to ping sockets
> (same test passes with raw sockets). I believe this test has always
> failed since fcnal-test.sh started using net.ipv4.ping_group_range
> (commit e71b7f1f44d3 ("selftests: add ping test with ping_group_range
> tuned")).
> 
> The executed command is:
> 
> ip netns exec ns-A ip vrf exec red /usr/bin/ping6 -c1 -w1 -I 2001:db8:3::1 fe80::a846:b5ff:fe4c:da4e%eth1
> 
> So ping6 is executed inside VRF 'red' and sets .sin6_scope_id to 'eth1'
> (which is a slave device of VRF 'red'). Therefore, we have
> sk->sk_bound_dev_if == 'red' and .sin6_scope_id == 'eth1'. This fails
> because ping_v6_sendmsg() expects them to be equal:
> 
> static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
> {
> ...
>                  if (__ipv6_addr_needs_scope_id(ipv6_addr_type(daddr)))
>                          oif = u->sin6_scope_id;
> ...
>          if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>              (addr_type & IPV6_ADDR_MAPPED) ||
>              (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if)) <-- oif='eth1', but ->sk_bound_dev_if='red'
>                  return -EINVAL;
> ...
> }
> 
> I believe this condition should be relaxed to allow the case where
> ->sk_bound_dev_if is oif's master device (and maybe there are other
> VRF cases to also consider).

I've tried something like this, but something makes the kernel stuck
here:

TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]

#################################################################
With VRF

[hanged process and kernel won't shutdown]

The code is:

---
  net/ipv6/ping.c | 12 +++++++++++-
  1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index c4835dbdfcff..81293e902293 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -73,6 +73,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
         struct rt6_info *rt;
         struct pingfakehdr pfh;
         struct ipcm6_cookie ipc6;
+       struct net *net = sock_net(sk);
+       struct net_device *dev = NULL;
+       struct net_device *mdev = NULL;
  
         err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
                                   sizeof(user_icmph));
@@ -111,10 +114,17 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
         else if (!oif)
                 oif = np->ucast_oif;
  
+       if (oif) {
+               dev = dev_get_by_index(net, oif);
+               mdev = netdev_master_upper_dev_get(dev);
+       }
+
         addr_type = ipv6_addr_type(daddr);
         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
             (addr_type & IPV6_ADDR_MAPPED) ||
-           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
+           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
+                   !(mdev && sk->sk_bound_dev_if &&
+                             mdev != dev_get_by_index(net, sk->sk_bound_dev_if))))
                 return -EINVAL;
  
         ipcm6_init_sk(&ipc6, np);

I am obviously doing something very stupid.

Regards,
Mirsad

