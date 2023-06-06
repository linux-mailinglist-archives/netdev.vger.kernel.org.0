Return-Path: <netdev+bounces-8593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCA7724AD7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F2A4280FEE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939CB22E3B;
	Tue,  6 Jun 2023 18:07:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D5519915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:07:50 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0590710DB;
	Tue,  6 Jun 2023 11:07:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 98F0560222;
	Tue,  6 Jun 2023 20:07:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686074865; bh=2Qg6Hnn/GT3M9jXFEGMttEB5iGyXDH66CaSOdMgoKRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xMDYvAjjsa89sBGCrrgceRWguk+MiYlIZB/pJEermeUqf/6V+y7VvCC5ywxmFMyXJ
	 q5OLIu8P0Yhxys0zEvdV5kk1qiHYjZLqvBkVmakncLOEuoKdSiSBAmV6SBxQOkBopJ
	 JTdHwFjuK0yRsLJpnC3zgU+uE7yWpKrtLcDSO1MBrkkm1ocIYwxQBr45Ocz21BcdGg
	 P8sMjY/yFCfok2tIdtMjz4SKh1OlntBYuzVv5xBFCCi7n9I4NsCA3hlOzQv6DG4t24
	 5WUhNc7POaq9VbMTngk+lXaM0dyefVCiVltsZzjVs3iQWlIYRDiShYhcvsLTek9hQn
	 TI2HZsPv9ccGA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gMziTJrY3cfX; Tue,  6 Jun 2023 20:07:43 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id CD6916021E;
	Tue,  6 Jun 2023 20:07:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686074863; bh=2Qg6Hnn/GT3M9jXFEGMttEB5iGyXDH66CaSOdMgoKRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QMbZnORBnmqf7lIHAwuOEAtgNtuI47NhSZQgTEL/CYP/khqojqSg9jXJFrT9JDZhr
	 a/U0HJ1bozdgQxJyCrnPi0STAF+50M98GaqPyt3d9xX31JxVveHM+Jj1SH/S+kIMvR
	 Zgc5gJc5fBnm4gfqXo6n/w7tlDg649/zpKeCGOIJQW48oI95Aw6qYq4gxnxvNYBf35
	 f56Tjn0KjBZtUi091G1gUTSXRAimKP9jrE37ARyL0Xcnq5Pnvl4utwm0wVlt45UTuU
	 l86zYe/GavN+WnB7pL9yBJiBqQn+nho+O0Gs8QFzuoT6ypbIKPFxu0AVyscSHWYt6M
	 Y9IK6MgqRINOg==
Message-ID: <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
Date: Tue, 6 Jun 2023 20:07:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL][FIX TESTED] in
 vrf "bind - ns-B IPv6 LLA" test
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian>
Content-Language: en-US
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZH84zGEODT97TEXG@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

The problem appears to be fixed:

# ./fcnal-test.sh
[...]
TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [ OK ]
TEST: ping in - ns-A IPv6                                                     [ OK ]
[...]
Tests passed: 888
Tests failed:   0
#

The test passed in both environments that manifested the bug.

Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>

However, test on my AMD Ubuntu 22.04 box with 6.4-rc5 commit a4d7d7011219
has shown additional four failed tests:

root@host # grep -n FAIL ../fcnal-test-4.log
90:TEST: ping local, VRF bind - VRF IP                                           [FAIL]
92:TEST: ping local, device bind - ns-A IP                                       [FAIL]
116:TEST: ping local, VRF bind - VRF IP                                           [FAIL]
118:TEST: ping local, device bind - ns-A IP                                       [FAIL]
root@host #

But you would probably want me to file a separate bug report?

Best regards,
Mirsad

