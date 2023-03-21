Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463766C3B13
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCUT5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCUT5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:57:17 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A021C5B6;
        Tue, 21 Mar 2023 12:57:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 9C58B60500;
        Tue, 21 Mar 2023 20:57:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679428631; bh=wiKwer93E0RP/tpRTJyQig+I11C43ciBFzwge/FvRrk=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=1hFiUQ+6z53cIAi7XaBMymS6JhhIGXi8Az7p95+Bh0/L6VH8ULIT4WHBa6sQ/E9Sp
         TdVk1TYCzHxufGFNJa3J8UILe0yy/+XEb1YiL5murMMm7SEuAPXKJoCy82gZIWR4Ip
         +ty+RDIA4AN4BTwXBvkfXa2wQ6DyTQ7oLR02Mekdrp21ZVa8+mDGBzA6dSjP6tcqgS
         c8XHHqTi45r206MXCGwSwMFjAO6pj5RXfK8we++M7ifDdVTEkpCOWw0H3b7CkgLkeB
         Whh+ZmgyNyivmb4bL6ukfyE32fstTz59NU14NWg0TsKJB2mrTIDBFZLx011YNf9zq2
         MoyYaV+KVnn+Q==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UQWPy4JILc4r; Tue, 21 Mar 2023 20:57:09 +0100 (CET)
Received: from [192.168.1.4] (unknown [109.227.34.15])
        by domac.alu.hr (Postfix) with ESMTPSA id A4205604F7;
        Tue, 21 Mar 2023 20:57:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679428629; bh=wiKwer93E0RP/tpRTJyQig+I11C43ciBFzwge/FvRrk=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Q8hMX5kqosZpRSKzBxPYmm8HZQaKwYv61WTi2NiFDlZtqSr7jQ0E+doyVtmxGrU5R
         YeAeAkz5ljkCjsns57MTxWwfhZ6Y4ssVLgDvS8j3kBLTA97RDZdLK+SU4uSx9rl4mV
         jtdQZYpHLiHk3obuKDK/qgqjV+qe+iyEGvM3kDeXZSdwcytJKSoA+JmtANbpGu3AA7
         XwQoDsbjrknWkiwVTOtC0zEkX8BWz6DRzrQT4mHnIqKMceOBDQTazCJhzPBulihJRp
         BqK2euS8BukOQl0EwpYrONyIJ00vvpJ2oSY+Ht9x9smdDEwa3xuRoVK5ifOzp25B2j
         uB5shvt1xMc/g==
Message-ID: <4ee8307a-7512-b8ad-0218-6fab071440dc@alu.unizg.hr>
Date:   Tue, 21 Mar 2023 20:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <ad89d824-6fa4-990d-42ed-f768db92cfb1@alu.unizg.hr>
 <20230320195903.314dcb21@kernel.org>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Organization: Academy of Fine Arts, University of Zagreb
Subject: Re: BUG: selftests/net/tls: FAIL in sm4_ccm tests
In-Reply-To: <20230320195903.314dcb21@kernel.org>
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

On 3/21/2023 3:59 AM, Jakub Kicinski wrote:
> On Mon, 20 Mar 2023 17:07:36 +0100 Mirsad Todorovac wrote:
>> The environment is AlmaLinux 8.7 running 6.3-rc3 vanilla kernel with
>> MGLRU, KMEMLEAK and CONFIG_DEBUG_KOBJECT=y enabled.
> 
> Do you have SM4 and CCM enabled in you kernel .config ?
> It's not a popular cipher.
> Make sure your config has all the options listed in
> tools/testing/selftests/net/config

Done that. Thanks, now all tools/testing/selftest/net/tls tests passed:

# PASSED: 554 / 554 tests passed.
# Totals: pass:554 fail:0 xfail:0 xpass:0 skip:0 error:0

Should I then probably rebuild the kernel for the tests with 
tools/testing/selftest/*/config merged?

Thanks,
Mirsad

-- 
Mirsad Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
tel. +385 (0)1 3711 451
mob. +385 91 57 88 355
