Return-Path: <netdev+bounces-8510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A1F7245F2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 228951C20B53
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E783E2DBB6;
	Tue,  6 Jun 2023 14:28:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D738237B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:28:15 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0A6172C;
	Tue,  6 Jun 2023 07:28:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 17A6C60212;
	Tue,  6 Jun 2023 16:28:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686061686; bh=WyGaO6S3i6ZE6h5RKEot8ZzWqDYoqEZ5M3+W5FY+Oq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BerOiOvrFPA84MMTe0Jecw4p/zpuXCl9Dg755KjVy6YdbjLs+zvQcPMTS2hoHN7a8
	 PBEIBMqp/PfY7lfnxq7Qd+jiLglULAjKtxpxfFR2OvHxfUPCxplQbIQGsQ80j3/km8
	 xOu4q3KoSNFLTg9Bn8vpTagNEHZ9Tcq734ycjoiU1EXkV+f2zMPehzr4C1Pe8oDwL3
	 K1lDfOJE3pC9LUfLUxB6+2ACWywE0mDtxY7/yCmzmeJZrLJLolJ2bNbp2H5EcnLi3V
	 CNmEW1KaItUp4VyADsKp7cDK93kg111wjlp85EP63mkvVmrJxCx8D2OKskTeU7+ECl
	 gqCm3XBwsvPDw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLGycccop9P0; Tue,  6 Jun 2023 16:28:03 +0200 (CEST)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
	by domac.alu.hr (Postfix) with ESMTPSA id 4AE276020C;
	Tue,  6 Jun 2023 16:28:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686061683; bh=WyGaO6S3i6ZE6h5RKEot8ZzWqDYoqEZ5M3+W5FY+Oq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ElTQ1wIF0XbErv+oxeOBTZ8ZL3tWWZGIRLzmjoxM294eQKH0zb5UZ7teaSGq2wjid
	 FpGeAEfQOsmGKJypnKUYFD7RSMFrGzld7+/EKCNzF3nA7Bqp8XckRjoBs7hsdGnlLC
	 00IDp8orNHaZCLZGWk00bh8mXPZhKtoll+45Hs2Eh3LWFthjZ2TAg8yntI1zA298A4
	 79/OmQfAQHLYE5MG7ACEMD9Br4LmlT/XHTpzbKPaVid0rH4FRkm6micO9huws01FAn
	 5Brz249y6Ws6Mgbnboyn6iy6UfORMwRg2bTDBi7y3g4enbh7078uZsYiCWt8e3dWMt
	 1m4ktG8DX4WUw==
Message-ID: <12c34bed-0885-3bb3-257f-3b2438ba206f@alu.unizg.hr>
Date: Tue, 6 Jun 2023 16:28:02 +0200
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
Content-Language: en-US, hr
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian> <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
 <ZH8+jLjottBw2zuD@debian>
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZH8+jLjottBw2zuD@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/23 16:11, Guillaume Nault wrote:
> On Tue, Jun 06, 2023 at 03:57:35PM +0200, Mirsad Todorovac wrote:
>> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
>> index c4835dbdfcff..c1d81c49b775 100644
>> --- a/net/ipv6/ping.c
>> +++ b/net/ipv6/ping.c
>> @@ -73,6 +73,10 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>          struct rt6_info *rt;
>>          struct pingfakehdr pfh;
>>          struct ipcm6_cookie ipc6;
>> +       struct net *net = sock_net(sk);
>> +       struct net_device *dev = NULL;
>> +       struct net_device *mdev = NULL;
>> +       struct net_device *bdev = NULL;
>>
>>          err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
>>                                    sizeof(user_icmph));
>> @@ -111,10 +115,26 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>          else if (!oif)
>>                  oif = np->ucast_oif;
>>
>> +       if (oif) {
>> +               rcu_read_lock();
>> +               dev = dev_get_by_index_rcu(net, oif);
>> +               rcu_read_unlock();
> 
> You can't assume '*dev' is still valid after rcu_read_unlock() unless
> you hold a reference on it.
> 
>> +               rtnl_lock();
>> +               mdev = netdev_master_upper_dev_get(dev);
>> +               rtnl_unlock();
> 
> Because of that, 'dev' might have already disappeared at the time
> netdev_master_upper_dev_get() is called. So it may dereference an
> invalid pointer here.

Good point, thanks. I didn't expect those to change.

This can be fixed, provided that RCU and RTNL locks can be nested:

         rcu_read_lock();
         if (oif) {
                 dev = dev_get_by_index_rcu(net, oif);
                 rtnl_lock();
                 mdev = netdev_master_upper_dev_get(dev);
                 rtnl_unlock();
         }

         if (sk->sk_bound_dev_if) {
                 bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
         }

         addr_type = ipv6_addr_type(daddr);
         if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
             (addr_type & IPV6_ADDR_MAPPED) ||
             (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
                     !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev))) {
                 rcu_read_unlock();
                 return -EINVAL;
	}
         rcu_read_unlock();

But again this is still probably not race-free (bdev might also disappear before
the mdev == bdev test), even if it passed fcnal-test.sh, there is much duplication
of code, so your one-line solution is obviously by far better. :-)

Much obliged.

Best regards,
Mirsad

>> +       }
>> +
>> +       if (sk->sk_bound_dev_if) {
>> +               rcu_read_lock();
>> +               bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
>> +               rcu_read_unlock();
>> +       }
>> +
>>          addr_type = ipv6_addr_type(daddr);
>>          if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>>              (addr_type & IPV6_ADDR_MAPPED) ||
>> -           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
>> +           (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
>> +                   !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev)))
>>                  return -EINVAL;
>>
>>          ipcm6_init_sk(&ipc6, np);
>>
>> However, this works by the test (888 passed) but your two liner is obviously
>> better :-)
> 
> :)

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia

