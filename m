Return-Path: <netdev+bounces-7414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6762D72022A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2398C281927
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FA8111B8;
	Fri,  2 Jun 2023 12:35:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4388476
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:35:48 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9DA1AD;
	Fri,  2 Jun 2023 05:35:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id EC9D36022A;
	Fri,  2 Jun 2023 14:35:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1685709341; bh=GiY3PCo8QniBGQj8UyN1CTuqS77BAaXgU5sGuqLnEdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FLnNLs1dcZL5+6rWxY58jjfclTzOGkjXmGlj5p0yNu4qy3DGX6V4QugUz22jOAc2D
	 OZApZNCrULkT3JnEPAE8iSkgir7xUovMMqyrMCO/WfXWKAWSQVhV+rsI095EPX/Eod
	 rSQq0TLMVx32SF2Zrsa6Hj/x54QiOUZWdOjZmnmXiR+u8T7Q0WlEiVf3e3RpYYfSG6
	 6nRen4vk+2HREtDi8BqyjK/IfAX9AA8vFfhUBgIwbB1sW3Nc7CMX0hb5SmpHLteDt4
	 EFRE0881ZZ/EYppYJ/1oUXoD9rmPsdz5g3z9+oQouLTlkD5Uhq8XyqAkq3wY+AQLXI
	 1uAvpClXoyDdQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Pd8hLSxYaBA; Fri,  2 Jun 2023 14:35:39 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id EB7C560228;
	Fri,  2 Jun 2023 14:35:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1685709339; bh=GiY3PCo8QniBGQj8UyN1CTuqS77BAaXgU5sGuqLnEdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RKvZ3VSztT9yChVj5zizTrLrpxx2oTMy1YPAZVIFuGCSG3uaICafD5G6MlwZXIQtC
	 k4x8u3lvcKo01ltXVvBbW3dRBSs0h0muB1OBOPul+EF1J6EufFac5iIqBQkzg0cvdo
	 P5ukL7/mv3ncuGHvN32+P7pIDdPxRsPkQGSbUSAEwTZBv2MP4Kv9VdoRptx2OvjU7V
	 VJvMjTtNRy4ogAnyypHkOkp5SegP8rtDOM8zKXxFaW8bFqA4/LJLxfB5uM7KeCCxM8
	 1hjR9Nwh/CTrRWDPwOcYPL8lHGCQmJjHUX0NqQEyY2Ys6SneMvc/kody3lrOSbtAs8
	 0Kzv+wUkGjVFA==
Message-ID: <015f6430-f6f3-61e3-25b8-2d989f4f3496@alu.unizg.hr>
Date: Fri, 2 Jun 2023 14:35:20 +0200
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
 <ZHeN3bg28pGFFjJN@debian>
Content-Language: en-US
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
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

Hi Guillaume,

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

Thank you for your thorough investigation. It helps a great deal to
understand the issue.

I am really not that into the network stack, though I can always smuggle
the work on the network stack as a work on high-bandwidth multimedia
and do it in day hours.

Probably I need to catch up with the network stack homework.

> I believe this condition should be relaxed to allow the case where
> ->sk_bound_dev_if is oif's master device (and maybe there are other
> VRF cases to also consider).

I have looked into the code, but currently my knowledge of the code is
not sufficient for the intervention.

Thank you,
Mirsad

