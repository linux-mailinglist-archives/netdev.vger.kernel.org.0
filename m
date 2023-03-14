Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8376B96E6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCNNzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCNNy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:54:28 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1F591D3;
        Tue, 14 Mar 2023 06:52:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id C4654604F3;
        Tue, 14 Mar 2023 14:52:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678801934; bh=winiTHLb17xj2o5gjeA/xwqNuNo9qdGozG2R42TvGWI=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=vQOB++GOpn2PDg+uZ/+MpAR98KnnwxrlO7UJyN57vKhsxmz48LsRXSO7+DNqbbdV3
         KjUPaBtTEp3BA55OF8B5xrGsK78TzQIOHrOBa8gVchUT8OJjgNlQ1sqpqYZTniRW8c
         4t3qBzDYmjcIwqDOE87qrKI5M2GMfXpr8jxgyakDvvpoxrAsLUvx/D7i1jxdIEtwgu
         yWfGN3Uk2rl07fqK8HtYyG3mW0QsI7w+qhqkhs73PZXTNE2YpAxn1Izyu+6qm6p1Fm
         jcskLpQULZjG43lykTCxJGUK7welwgwk2sb+FXPF3m4M/V/FkWBtLPoK0256HHX63O
         hzEFnsIpFLyfA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IprvmGBEEZqw; Tue, 14 Mar 2023 14:52:12 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id ED8C2604F2;
        Tue, 14 Mar 2023 14:52:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678801932; bh=winiTHLb17xj2o5gjeA/xwqNuNo9qdGozG2R42TvGWI=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=I2lH65lLaxohUVPAJ6+77a48CoWxrboffiqTT9lhdrl2MHnJ/w1osTJVCetxd0iRf
         WkBNbfn4eP/MsDpsAD/BdGZJpcJiI2oFH0jFsiW33XR4q3hfCfdP7bEUVYMsa+q4UK
         Wizn+aP3dRD4lpli7+HY9h9yaPspNXnC6UpbqsI4SYTLtW+GxvpPJvkD94FD9bGkcG
         i9651TBgNrcokZWnfZFmsGGcIolFopjsYfqIBrx4TwhCTyWFIoNF2ltNX70zT0OBYo
         cWg5uYOlq5cVrxj6jYP2+DFCZ60081OctZajWQPRbLKZ0aSJQ/fPqVevqkSVA9VHWS
         97nYXsu4fB9rA==
Message-ID: <d7a64812-73db-feb2-e6d6-e1d8c09a6fed@alu.unizg.hr>
Date:   Tue, 14 Mar 2023 14:52:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: BUG: selftest/net/tun: Hang in unregister_netdevice
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <a0734a6b-9491-b43a-6dff-4d3498faee2e@alu.unizg.hr>
Content-Language: en-US, hr
In-Reply-To: <a0734a6b-9491-b43a-6dff-4d3498faee2e@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 12:45, Mirsad Todorovac wrote:
> Hi, all!
> 
> After running tools/testing/selftests/net/tun, there seems to be some kind of hang
> in test "FAIL  tun.reattach_delete_close" or "FAIL  tun.reattach_close_delete".
> 
> Two tests exit by timeout, but the processes left are unkillable, even with kill -9 PID:
> 
> [root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
> root        1140       1  0 12:16 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
> root        1333       1  0 12:16 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
> root        3930    2309  0 12:20 pts/1    00:00:00 tools/testing/selftests/net/tun
> root        3952    2309  0 12:21 pts/1    00:00:00 tools/testing/selftests/net/tun
> root        4056    3765  0 12:25 pts/1    00:00:00 grep --color=auto tun
> [root@pc-mtodorov linux_torvalds]# kill -9 3930 3952
> [root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
> root        1140       1  0 12:16 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
> root        1333       1  0 12:16 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
> root        3930    2309  0 12:20 pts/1    00:00:00 tools/testing/selftests/net/tun
> root        3952    2309  0 12:21 pts/1    00:00:00 tools/testing/selftests/net/tun
> root        4060    3765  0 12:25 pts/1    00:00:00 grep --color=auto tun
> [root@pc-mtodorov linux_torvalds]#
> 
> The kernel seems to be stuck in some loop, and filling the log with the
> following messages until reboot, where it is also waiting very long on the
> situation to timeout, which apparently never happens.
> 
> Mar 14 11:54:09 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 11:54:19 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 11:54:29 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 11:54:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 11:54:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> 
> The platform is kernel 6.3.0-rc2 on AlmaLinux 8.7 and a LENOVO_MT_10TX_BU_Lenovo_FM_V530S-07ICB
> (lshw output attached).
> 
> The .config is here:
> 
> https://domac.alu.hr/~mtodorov/linux/selftests/net-tun/config-6.3.0-rc2-mg-andy-devres-00006-gfc89d7fb499b
> 
> Basically, it is a vanilla Torvalds tree kernel with MGLRU, KMEMLEAK, and CONFIG_DEBUG_KOBJECT enabled.
> And devres patch.
> 
> Please find the strace of the net/tun run attached.
> 
> I am available for additional diagnostics.

Hi, again!

I've been busy while waiting for reply, so I wondered how would a vanilla kernel
go through the test, considering that I've been testing a number of patches
lately.

I did a fresh git clone from repo and woa.

Surprisingly, the test with CONFIG_DEBUG_KOBJECT turned off passes:

[root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/tun
TAP version 13
1..5
# Starting 5 tests from 1 test cases.
#  RUN           tun.delete_detach_close ...
#            OK  tun.delete_detach_close
ok 1 tun.delete_detach_close
#  RUN           tun.detach_delete_close ...
#            OK  tun.detach_delete_close
ok 2 tun.detach_delete_close
#  RUN           tun.detach_close_delete ...
#            OK  tun.detach_close_delete
ok 3 tun.detach_close_delete
#  RUN           tun.reattach_delete_close ...
#            OK  tun.reattach_delete_close
ok 4 tun.reattach_delete_close
#  RUN           tun.reattach_close_delete ...
#            OK  tun.reattach_close_delete
ok 5 tun.reattach_close_delete
# PASSED: 5 / 5 tests passed.
# Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0
[root@pc-mtodorov linux_torvalds]#

So, no hanging processes that cannot be killed now.

If you think it is worthy to explore the lockup that occurs when turning
CONFIG_DEBUG_KOBJECT=y, I will rebuild once again with these turned on,
to clear any doubts.

Until later.

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
