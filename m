Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3C765F943
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 02:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjAFBoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 20:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjAFBoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 20:44:22 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCB21C43E;
        Thu,  5 Jan 2023 17:44:20 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 92860604F1;
        Fri,  6 Jan 2023 02:44:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672969455; bh=j0I8Yg736QaEcLiDbDpjG//QkBBv0KbB4F0zCJztB50=;
        h=Date:To:Cc:From:Subject:From;
        b=YhmcuEesCE2aMfiaoaiv9I8l+c4DdjBEiSnxGEmUcBGaGRx/4HF1MBMCojRTJs90V
         wh9FvfCnIua4NrJ9GCZsrpEtvVyaciVZNVOhV99QyLyG8MfzSANBBqPhPN9X6YJ0rb
         Evd/PhAMNalrGgjOXPdc+4d+F/mA1I6hmmHLme0ZJ5FM9cdZCCBXfcOJAKWl+U5JYH
         SiwERgDfpwjlxXzBBAWNYZq3ZdLv2LExBWsAfdqaXExKk5m1XCUbMicBqJHIeH4+Hl
         EcHSO/y0ZDgDpzYGtDqzjJyHATf1E7SAAIS9FLhO5A+lFUWfmmAjbK05OpJnJhBw8A
         jcTqbQFctWwLw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id msczIeCKyGkU; Fri,  6 Jan 2023 02:44:13 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 5F127604F0;
        Fri,  6 Jan 2023 02:44:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672969453; bh=j0I8Yg736QaEcLiDbDpjG//QkBBv0KbB4F0zCJztB50=;
        h=Date:To:Cc:From:Subject:From;
        b=O167wkos98+hcqUs6h330GpW0tzm8eOuTxaZ/VJvLgB6O+nEqgYcFRgY592Bxj1dx
         ED+jUYzKZnd9HmqGoXe8EbTUvTguQTWH8F6n8AMu1lK4MbytEurX1x22MKdWr+iHSD
         zVTQeo8qyXQYpCc+aAmUslN98r0Nsymtm9fBDf+M/IoitzUhQvW1Kai626Vnq8ALol
         EzYOPeYDJ2EBlhty5vS7Xx2zEE8uLVyGXnLC5T8xbDu9mi4hzJpqY+5fJwIFXqVEa3
         oiPe1AKpjqtsAtaiiLjPraOdTlF3Va4tHlwNHTkaPeAj+GegRCFXut6xV0E0A06e28
         /0YOsCX3Q0aEw==
Content-Type: multipart/mixed; boundary="------------QSSseDKsp4kXRF0c0Oi6OPbY"
Message-ID: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
Date:   Fri, 6 Jan 2023 02:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     linux-kselftest@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------QSSseDKsp4kXRF0c0Oi6OPbY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

I was wondering whether I am already obnoxious with three or four bug reports in
two days and you might find it easier to hire an assassin to silence me
than to fix them :)

But the saner approach prevailed and I thought of the advantage of pulling
through with 6.2-rc2 selftests on all my available hardware.

Please find included the lshw output, config and dmesg log.
The kernel is essentially vanilla mainline torvalds tree kernel with
CONFIG_KMEMLEAK=y and MG-LRU enabled (somewhat maybe brave, but I believe unrelated).

https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/config-6.2-rc2-20230104.txt
https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/dmesg-20220105.txt

[root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/l2_tos_ttl_inherit.sh
┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │     4 │ inherit 0xc4 │  inherit 116 │ false │Cannot create namespace file "/var/run/netns/testing": File exists
RTNETLINK answers: File exists
RTNETLINK answers: File exists
RTNETLINK answers: File exists

Of course, I should have tried to fix these myself, but I am not quite an expert
in namespaces.

BTW, Florian asked for a bash -x output, so I am providing one to save one roundtrip:

https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/bash.html

Kind regards,
Mirsad

--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
-- 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union
--------------QSSseDKsp4kXRF0c0Oi6OPbY
Content-Type: application/x-xz; name="lshw.txt.xz"
Content-Disposition: attachment; filename="lshw.txt.xz"
Content-Transfer-Encoding: base64

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


--------------QSSseDKsp4kXRF0c0Oi6OPbY--
