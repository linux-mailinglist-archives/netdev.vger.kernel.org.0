Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025A76617A6
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 18:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjAHR4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 12:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbjAHR4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 12:56:09 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97517DF7E;
        Sun,  8 Jan 2023 09:56:06 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 30DAA604F0;
        Sun,  8 Jan 2023 18:56:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673200564; bh=cFy19nqO0N/rhSk+x/Xbk7AN8qcY/NuNeS7fDEclcDk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MntAe4S1+xnRIi2KmZ6YYRg5CMrQcoKB19K+5YZ5i7HEjSa2qKX3E0cYHGpVd1Htn
         vch5jOJOXv62y3CXQbIjjsUEZESYO4J/tGqaaC+KSvqTVqn6yIWrLc/UhTCG6IS/8Y
         lNxpqpB3wzpliVb/xYIQjedtJJG5eq1twLMG6iKgXy37raBX8+luPSDb3MHmEaFOwx
         sAbvxFp6M7zM7/xRkL9ucceBM4ULZsVo+ccqRuWu9gVovUpnY8FmBWQnZdfsQ7vySP
         5/59kUDkEsEP8uSvzoW6NW/peFFDXRC1n7bEKgej6tXQwsKj/4jlFzPd0D7xHQx4EZ
         HPrVvKer66i7Q==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zp4xA9GqTLLj; Sun,  8 Jan 2023 18:56:01 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id A210C604F1;
        Sun,  8 Jan 2023 18:56:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673200561; bh=cFy19nqO0N/rhSk+x/Xbk7AN8qcY/NuNeS7fDEclcDk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ujlhbDy0JzHx2y/4fSmdWLvXZDAt54KhtztTjC4+GebspozRbHHkEwEZhISvBBQlv
         Ch0sol339H4G03B1KVulopc5sLsZ4SIw7yTVSKAS8y4fk+FqEMJP8mQvlb3CQc0FfG
         ccEScBTeHhf5/uK/WiP9CSS/cetQ+5XVbQlFzTWFm7lbE02WpTZzcifp9PIdGTDrhg
         j/MGgQYERPdk76FTfcYMWZhdM6Wd0eGvV7kYzGjVKMJVSXzPDnk7G5jfxOXenEMRnD
         3s17M+fIC6ArUTv71zb1SFm9T7Ndjq042OhCTpTcR7hGqnreAg9nrPAWQclCqEA4Lf
         8EiogmljR2+/w==
Message-ID: <d51dcdba-86b8-78d7-d173-5826d9fa88ca@alu.unizg.hr>
Date:   Sun, 8 Jan 2023 18:55:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
Content-Language: en-US, hr
To:     Guillaume Nault <gnault@redhat.com>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian> <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian> <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
 <Y7rNgPj9WIroPcQ/@debian> <750cd534-1361-4102-67c5-2898814f8b4c@alu.unizg.hr>
 <Y7ryNK2sMv+PC6xr@debian>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <Y7ryNK2sMv+PC6xr@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08. 01. 2023. 17:41, Guillaume Nault wrote:
> On Sun, Jan 08, 2023 at 03:49:05PM +0100, Mirsad Goran Todorovac wrote:
>> On 08. 01. 2023. 15:04, Guillaume Nault wrote:
>>
>>> For some reasons, your host doesn't accept the VXLAN packets received
>>> over veth0. I guess there are some firewalling rules incompatible with
>>> this tests script.
>>
>> That beats me. It is essentially a vanilla desktop AlmaLinux (CentOS fork)
>> installation w 6.2-rc2 vanilla torvalds tree kernel.
>>
>> Maybe DHCPv4+DHCPv6 assigned address got in the way?
> 
> I don't think so. The host sends an administratively prohibited
> error. That's not an IP address conflict (and the script uses reserved
> IP address ranges which shouldn't conflict with those assigned to regular
> host).
> 
> The problem looks more like what you get with some firewalling setup
> (like an "iptables XXX -j REJECT --reject-with icmp-admin-prohibited"
> command).

To eliminate that, the only rules that seem to be enabled are those automatic,
as this is essentially a desktop machine. This reminds me that I forgot to
install fail2ban, I thought it came with the system ...

[root@pc-mtodorov linux_torvalds]# iptables-save
# Generated by iptables-save v1.8.4 on Sun Jan  8 18:50:53 2023
*filter
:INPUT ACCEPT [15241235:25618772171]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [13209318:19634265528]
:LIBVIRT_INP - [0:0]
:LIBVIRT_OUT - [0:0]
:LIBVIRT_FWO - [0:0]
:LIBVIRT_FWI - [0:0]
:LIBVIRT_FWX - [0:0]
COMMIT
# Completed on Sun Jan  8 18:50:53 2023
# Generated by iptables-save v1.8.4 on Sun Jan  8 18:50:53 2023
*security
:INPUT ACCEPT [15163987:25613250223]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [13209319:19634265904]
COMMIT
# Completed on Sun Jan  8 18:50:53 2023
# Generated by iptables-save v1.8.4 on Sun Jan  8 18:50:53 2023
*raw
:PREROUTING ACCEPT [15241455:25618791347]
:OUTPUT ACCEPT [13209321:19634266304]
COMMIT
# Completed on Sun Jan  8 18:50:53 2023
# Generated by iptables-save v1.8.4 on Sun Jan  8 18:50:53 2023
*mangle
:PREROUTING ACCEPT [15241455:25618791347]
:INPUT ACCEPT [15241235:25618772171]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [13209322:19634266440]
:POSTROUTING ACCEPT [13211416:19634553617]
:LIBVIRT_PRT - [0:0]
-A POSTROUTING -j LIBVIRT_PRT
-A LIBVIRT_PRT -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
COMMIT
# Completed on Sun Jan  8 18:50:53 2023
# Generated by iptables-save v1.8.4 on Sun Jan  8 18:50:53 2023
*nat
:PREROUTING ACCEPT [282314:13237147]
:INPUT ACCEPT [207948:8194212]
:POSTROUTING ACCEPT [1351498:86025578]
:OUTPUT ACCEPT [1351498:86025578]
:LIBVIRT_PRT - [0:0]
-A POSTROUTING -j LIBVIRT_PRT
-A LIBVIRT_PRT -s 192.168.122.0/24 -d 224.0.0.0/24 -j RETURN
-A LIBVIRT_PRT -s 192.168.122.0/24 -d 255.255.255.255/32 -j RETURN
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
COMMIT
# Completed on Sun Jan  8 18:50:53 2023
[root@pc-mtodorov linux_torvalds]# 
[root@pc-mtodorov linux_torvalds]# ip6tables-save
# Generated by ip6tables-save v1.8.4 on Sun Jan  8 18:52:56 2023
*filter
:INPUT ACCEPT [8458:771878]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9605:895758]
:LIBVIRT_INP - [0:0]
:LIBVIRT_OUT - [0:0]
:LIBVIRT_FWO - [0:0]
:LIBVIRT_FWI - [0:0]
:LIBVIRT_FWX - [0:0]
-A INPUT -j LIBVIRT_INP
-A FORWARD -j LIBVIRT_FWX
-A FORWARD -j LIBVIRT_FWI
-A FORWARD -j LIBVIRT_FWO
-A OUTPUT -j LIBVIRT_OUT
COMMIT
# Completed on Sun Jan  8 18:52:56 2023
# Generated by ip6tables-save v1.8.4 on Sun Jan  8 18:52:56 2023
*security
:INPUT ACCEPT [7327:586054]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9605:895758]
COMMIT
# Completed on Sun Jan  8 18:52:56 2023
# Generated by ip6tables-save v1.8.4 on Sun Jan  8 18:52:56 2023
*raw
:PREROUTING ACCEPT [10028:893325]
:OUTPUT ACCEPT [9605:895758]
COMMIT
# Completed on Sun Jan  8 18:52:56 2023
# Generated by ip6tables-save v1.8.4 on Sun Jan  8 18:52:56 2023
*mangle
:PREROUTING ACCEPT [9679:867735]
:INPUT ACCEPT [8458:771878]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9605:895758]
:POSTROUTING ACCEPT [10500:1051905]
:LIBVIRT_PRT - [0:0]
-A POSTROUTING -j LIBVIRT_PRT
COMMIT
# Completed on Sun Jan  8 18:52:56 2023
# Generated by ip6tables-save v1.8.4 on Sun Jan  8 18:52:56 2023
*nat
:PREROUTING ACCEPT [252:33745]
:INPUT ACCEPT [105:21315]
:POSTROUTING ACCEPT [2041:188025]
:OUTPUT ACCEPT [2041:188025]
:LIBVIRT_PRT - [0:0]
-A POSTROUTING -j LIBVIRT_PRT
COMMIT
# Completed on Sun Jan  8 18:52:56 2023
[root@pc-mtodorov linux_torvalds]# 

>>> I can probably help with the l2tp.sh failure and maybe with the
>>> fcnal-test.sh hang. Please report them in their own mail thread.
>>
>> Then I will Cc: you for sure on those two.
>>
>> But I cannot promise that this will be today. In fact, tomorrow is prognosed
>> rain so I'd better use the remaining blue-sky-patched day to do some biking ;-)
> 
> No hurry :)

:)

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

