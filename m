Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BEE19B654
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgDATSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:18:32 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:45110 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbgDATSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:18:32 -0400
Received: by mail-qk1-f175.google.com with SMTP id c145so1217704qke.12
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=k/QzoOrt32rBDiK/uScRsW4zy/U6BoKgXgKci1DCleU=;
        b=ADt8oi0OgdnplGd7Q7FYLbLHvarmp0ehq8Y4D/rxE2sgCxIHmlPJdYB/o6mtH0Wt6m
         aeTc11tcySPS06WYo+LJvCD8mTf2b5QmUXWo9jnjbL3CBald/bBYpw6d6iByLeKCEW1+
         Kbs0ZrukQ8Y0qhwuuax0NvwX99FILSUf72mnmt4JrAmgVnb75Yo6+SDuG76w+MxY+qX/
         XlzbQO/NhyWVgp7UL9pULu+vDLO9lCbubZCsQT7EMT48HIl9rKMtQGKH08dCEciCd0L6
         TEe3OK09UwUw0gfpe0sJaFOjRMyFyJS/UaqcJEFjAv6jrs5QV2gd4U1AE/Ax89DipnQZ
         PjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k/QzoOrt32rBDiK/uScRsW4zy/U6BoKgXgKci1DCleU=;
        b=ThuyRBj6fv4tOlHOYs2OnhOyWCQPVZR6HaOd+uFrszDOQ6H+Jk7gh4nOyFYxJxACnI
         Y+omtLBpjOSulL4KDhRp85iLtPcJP6cJ9UtiLS2RkD/Gy/49wRq1PQaQYoOvelGNx4E/
         zxnNjA6mRfP5Y+hgi2hk74IdUky+Kwg3HtCMlZxyQXFn1alj0sgIp0gOX0pAKX1PgRIO
         BOhF6948Yz656sR8dFAmBa+K4kTWRhU15C2ddks7Lq0RjaVl6CPaoHxIcCAj36niJkW9
         4+P0auPEkXlKewTRf/M4vxtujHBeyazaWPV02dymThthvOj1HQwsiR4FhxapUryFa4m0
         csBQ==
X-Gm-Message-State: ANhLgQ00BWIMoX0peuZJxPmYoVhIgOZXRJdqwRRjq5ovsEfVWyqFb2v6
        LA91vbUiQ/rNLsr+8QqTZKjELWBn
X-Google-Smtp-Source: ADFU+vttQUc2aA5eZ75+DecbSLe7+PmG7D90xH0z5HqI4yYIPUJ9pV41WEi7i84Lp0OHg4UVwjzrMg==
X-Received: by 2002:a05:620a:1ed:: with SMTP id x13mr10898820qkn.70.1585768711128;
        Wed, 01 Apr 2020 12:18:31 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f8fc:a46d:375f:4fa2? ([2601:282:803:7700:f8fc:a46d:375f:4fa2])
        by smtp.googlemail.com with ESMTPSA id c19sm2036914qkk.81.2020.04.01.12.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 12:18:30 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
References: <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
Date:   Wed, 1 Apr 2020 13:18:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401181650.flnxssoyih7c5s5y@topsnens>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 12:16 PM, Maximilian Bosch wrote:
> Hi!
> 
> First of all, sorry for my delayed response!
> 
>> functional test script under tools/testing/selftests/net covers VRF
>> tests and it ran clean for 5.4 last time I checked. There were a few
>> changes that went into 4.20 or 5.0 that might be tripping up this use
>> case, but I need a lot more information.
> 
> I recently started an attempt to get those tests running on my machine
> (and a Fedora VM after that), however I had several issues with
> timeouts (when running `sudo -E make -C tools/testing/selftests TARGETS="net"
> run_tests`).
> 
> May I ask if there are further things I need to take care of to get
> those tests successfully running?

This should work:
    make -C tools/testing/selftests/net nettest
    PATH=$PWD/tools/testing/selftests/net:$PATH
    tools/testing/selftests/net/fcnal-test.sh

> 
>> are you saying wireguard worked with VRF in the past but is not now?
> 
> No. WireGuard traffic is still working fine. The only issue is
> TCP-traffic through a VRF (which worked with 4.19, but doesn't anymore
> with 5.4 and 5.5).
> 
>> 'ip vrf exec' loads a bpf program and that requires locked memory, so
>> yes, you need to increase it.
> 
> Thanks a lot for the explanation!
> 
>> Let's start with lookups:
>>
>> perf record -e fib:* -a -g
>> <run test that fails, ctrl-c>
>> perf script
> 
> For the record, please note that I'm now on Linux 5.5.13.
> 
> I ran the following command:
> 
> ```
> sudo perf record -e fib:* -a -g -- ssh root@92.60.36.231 -o ConnectTimeout=10s
> ```

If you want that ssh connection to work over a VRF you either need to
set the shell context:
    ip vrf exec <NAME> su - $USER

or add 'ip vrf exec' before the ssh. If it is an incoming connection to
a server the ssh server either needs to be bound to the VRF or you need
'net.ipv4.tcp_l3mdev_accept = 1'

> 
> The full output can be found here:
> 
> https://gist.githubusercontent.com/Ma27/a6f83e05f6ffede21c2e27d5c7d27098/raw/4852d97ee4860f7887e16f94a8ede4b4406f07bc/perf-report.txt

seems like you have local rule ahead of the l3mdev rule. The order
should be:

# ip ru ls
1000:	from all lookup [l3mdev-table]
32765:	from all lookup local
32766:	from all lookup main

That is not the problem, I just noticed some sub-optimal lookups.

The tcp reset suggests you are doing an outbound connection but the
lookup for what must be the SYN-ACK is not finding the local socket -
and that is because of the missing 'ip vrf exec' above.
