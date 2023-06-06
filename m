Return-Path: <netdev+bounces-8498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0BB724509
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAB6E28108A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06BD2D24D;
	Tue,  6 Jun 2023 13:57:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AE637B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:57:52 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2258EA;
	Tue,  6 Jun 2023 06:57:49 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 9F33260203;
	Tue,  6 Jun 2023 15:57:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686059866; bh=abLjtdf5hSL5WbCCmX+Xip49rxyNm6zxX5OIxMHHHs4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=0F6waD0ILanyaJwu/Ei4TN3BmNVTOc+fGr4mblkw6BtWKCecgWHx7EhO1YXnLCwD7
	 aXovGu0P7SJO7bQCrkTkGhpSuTeRGf2ETjwClyD66magjalNN1m6394bohrUjZWAG+
	 Wgriq5/CshrO5cI04UYMPT4n9CSMcquA0p6yPDcfG7PUcpN4AzgNY0ZgkZPJX5W1B3
	 zI6c0W+oU3ey6YBuSDvG1sOZ1T0POZkhn+mjq1KCIMsBJGSKNwDLw91hVThx/ITKFi
	 sxbsOzPpWFrWL80UpylKZT4LCvajBNYbKCvjP0Y5X9CVJG2zdVGX4MYrjoanea2Q5f
	 pNfSC4PQvCUeg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OzKsoe3Xj-7r; Tue,  6 Jun 2023 15:57:44 +0200 (CEST)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
	by domac.alu.hr (Postfix) with ESMTPSA id 2D46B60210;
	Tue,  6 Jun 2023 15:57:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686059863; bh=abLjtdf5hSL5WbCCmX+Xip49rxyNm6zxX5OIxMHHHs4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OGT42JPCNqIilKpc9c037Qayuj2X0CkHrZnURjiiUiMtE2M3rxiBZbwws4Cf4yRoq
	 l+r7Z6jDF4cDxbsnprDB03euguvCuUWboar2vjRcSH8xdkSujnz4KBY+b9bdw3d8jW
	 ksRXqro9G5t4HTbRGE4cJH4rtErDajU6sN0wXZJICyURlSd0jQeGsyoFTzMF6nFIhY
	 uPym8rlZTu7vqkfsSoWu1Efnz8kJBY5+TDPK/tWCCOQD9NkpjTqr/i4PmCZkxmF/p4
	 cEc7g0XuIr+PB1++VwGjrt1PJfDbjnjdrpzzyo+fpwFgPq8rDPN5ZiOE+Z2r4KIpxP
	 XaMzKm0ixnMJw==
Message-ID: <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
Date: Tue, 6 Jun 2023 15:57:35 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
Content-Language: en-US, hr
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZH84zGEODT97TEXG@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/23 15:46, Guillaume Nault wrote:
> On Tue, Jun 06, 2023 at 08:24:54AM +0200, Mirsad Goran Todorovac wrote:
>> On 5/31/23 20:11, Guillaume Nault wrote:
>>> I believe this condition should be relaxed to allow the case where
>>> ->sk_bound_dev_if is oif's master device (and maybe there are other
>>> VRF cases to also consider).
>>
>> I've tried something like this, but something makes the kernel stuck
>> here:
>>
>> TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
>> TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
>> TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
>> TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
>> TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
>>
>> #################################################################
>> With VRF
>>
>> [hanged process and kernel won't shutdown]
>>
>> The code is:
>>
>> ---
>>   net/ipv6/ping.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
>> index c4835dbdfcff..81293e902293 100644
>> --- a/net/ipv6/ping.c
>> +++ b/net/ipv6/ping.c
>> @@ -73,6 +73,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>          struct rt6_info *rt;
>>          struct pingfakehdr pfh;
>>          struct ipcm6_cookie ipc6;
>> +       struct net *net = sock_net(sk);
>> +       struct net_device *dev = NULL;
>> +       struct net_device *mdev = NULL;
>>          err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
>>                                    sizeof(user_icmph));
>> @@ -111,10 +114,17 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>          else if (!oif)
>>                  oif = np->ucast_oif;
>> +       if (oif) {
>> +               dev = dev_get_by_index(net, oif);
>> +               mdev = netdev_master_upper_dev_get(dev);
>> +       }
>> +
>>          addr_type = ipv6_addr_type(daddr);
>>          if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>>              (addr_type & IPV6_ADDR_MAPPED) ||
>> -           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
>> +           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
>> +                   !(mdev && sk->sk_bound_dev_if &&
>> +                             mdev != dev_get_by_index(net, sk->sk_bound_dev_if))))
>>                  return -EINVAL;
>>          ipcm6_init_sk(&ipc6, np);
>>
>> I am obviously doing something very stupid.
> 
> The problem is that dev_get_by_index() holds a reference on 'dev' which
> your code never releases. Also netdev_master_upper_dev_get() needs rtnl
> protection. These should have generated some kernel oops.
> 
> You can try this instead:
> 
> -------- >8 --------
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index c4835dbdfcff..f804c11e2146 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -114,7 +114,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>   	addr_type = ipv6_addr_type(daddr);
>   	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>   	    (addr_type & IPV6_ADDR_MAPPED) ||
> -	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
> +	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
> +	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
>   		return -EINVAL;
>   
>   	ipcm6_init_sk(&ipc6, np);

Yes, I stupidly forgot that.

I came across a fixed version:

------
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index c4835dbdfcff..c1d81c49b775 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -73,6 +73,10 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
         struct rt6_info *rt;
         struct pingfakehdr pfh;
         struct ipcm6_cookie ipc6;
+       struct net *net = sock_net(sk);
+       struct net_device *dev = NULL;
+       struct net_device *mdev = NULL;
+       struct net_device *bdev = NULL;

         err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
                                   sizeof(user_icmph));
@@ -111,10 +115,26 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
         else if (!oif)
                 oif = np->ucast_oif;

+       if (oif) {
+               rcu_read_lock();
+               dev = dev_get_by_index_rcu(net, oif);
+               rcu_read_unlock();
+               rtnl_lock();
+               mdev = netdev_master_upper_dev_get(dev);
+               rtnl_unlock();
+       }
+
+       if (sk->sk_bound_dev_if) {
+               rcu_read_lock();
+               bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+               rcu_read_unlock();
+       }
+
         addr_type = ipv6_addr_type(daddr);
         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
             (addr_type & IPV6_ADDR_MAPPED) ||
-           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
+           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
+                   !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev)))
                 return -EINVAL;

         ipcm6_init_sk(&ipc6, np);

However, this works by the test (888 passed) but your two liner is obviously
better :-)

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia

