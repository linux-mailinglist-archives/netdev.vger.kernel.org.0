Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8287FDEB
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbfHBP76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:59:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39716 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388421AbfHBP76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:59:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so33852112pls.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/dWNRQosRlkttTXZjyh8zXptYc3M7Bpc2q1b9a/3gnQ=;
        b=n3VGS6vu8Uolc3Tdh+vAhk89fSdr7B5OchYZIkZEfuAQtnO/VvoeGFvhx9y6GfyYlT
         iB23EFBXHyBbwi1Z5MAGt9CStnTFvfZESbJxPf9H3DH4G9K3RtH/cdw8LMOpRZ09wvPh
         EP3TZHnCKjfLzLo3wUvo/+5H9WalQ0SAJk5LYr5llb0Ff7yu/2No7GDUPHgVSGsyFTYk
         5e/ry1kGmIEFe6aUxujlU46LhbEYmaXDJuqZUmik3uJz4bLSI94jRpst976QvNxg+hC0
         du8lmgFmqbD/HB6cX62++ST7lwhEhmunUxA4xETVFm6Y4vlxuSu17uwxVRNgKr3/RXp+
         qQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/dWNRQosRlkttTXZjyh8zXptYc3M7Bpc2q1b9a/3gnQ=;
        b=nth+bw8PwgAim44xf/JdgxCi+w6ktSrxzWnBW/vfKyoN/R3psuLnWWTG+m6gCbRKo9
         xXSLQfledvOosu7wfJQvX8AWzf/8qSjmZ05qvUxBPNKJB3jL2EwLRu7RguDl9TvxQx2e
         T+vRwXIbOMxoNiPf1kDME++XHnlEO7MHWeMn3sxTfdkcEmpn8Wuo6T91ivN5rxRMN/hN
         0nxZxq/MloEeovISbQxAHqt6oUk6sAr9GReARw+xm0wwWSMl9WzdouAT+tLhr215Aukx
         B0psBmt68P6kpevxhHphDqrSNg26R4FiI3GoUNJx31CxtDInIumpc3Dus4CnMK+yd3LO
         I3RQ==
X-Gm-Message-State: APjAAAUbvp0Vryi+WWbwe4R3ePaGxJiNxadB0IdDPfNs6Keip4qKZzmE
        g4C/IJI5Xt7jLpH03paQDCf6kFKC
X-Google-Smtp-Source: APXvYqyoN8tnLoQLXk8vhjy1U73W0qyjW22jycfy5sVV5hVyPU6xP1S2gYP6rxu1f+ODreDUIycPSA==
X-Received: by 2002:a17:902:aa09:: with SMTP id be9mr46486443plb.52.1564761596881;
        Fri, 02 Aug 2019 08:59:56 -0700 (PDT)
Received: from [172.27.227.195] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k8sm71245156pgm.14.2019.08.02.08.59.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:59:55 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
 <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
 <4c89b1cd-4dba-9cd8-0f4e-ae0a5d8bc61c@gmail.com>
 <CAADnVQLLKziv+3oOEijh=woyBZ7KsxoJ8=BB9ax+XJT9wxTuYQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <75e0a242-6960-90a7-9f3d-96536e0a0bb7@gmail.com>
Date:   Fri, 2 Aug 2019 09:59:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQLLKziv+3oOEijh=woyBZ7KsxoJ8=BB9ax+XJT9wxTuYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 9:14 AM, Alexei Starovoitov wrote:
> On Thu, Aug 1, 2019 at 9:04 PM David Ahern <dsahern@gmail.com> wrote:
>> ...
>>
>>>
>>> with -v I see:
>>> COMMAND: ip netns exec ns-A ping -c1 -w1 -I 172.16.2.1 172.16.1.2
>>> ping: unknown iface 172.16.2.1
>>> TEST: ping out, address bind - ns-B IP                                        [FAIL]
>>
>> With ping from iputils-ping -I can be an address or a device.
> 
> the ping, I have installed, supports -I.
> The issue is somewhere else. Ideas?
> 

make sure ping supports the overloading of -I (both dev and address).

check your kernel version. No results guaranteed on kernel prior to 5.3

This is Fedora 29 with 5.1 kernel

TEST: ping out - ns-B IP                                          [ OK ]
TEST: ping out, device bind - ns-B IP                             [ OK ]
TEST: ping out, address bind - ns-B IP                            [ OK ]
TEST: ping out - ns-B loopback IP                                 [ OK ]
TEST: ping out, device bind - ns-B loopback IP                    [ OK ]
TEST: ping out, address bind - ns-B loopback IP                   [ OK ]
TEST: ping in - ns-A IP                                           [ OK ]
TEST: ping in - ns-A loopback IP                                  [ OK ]
TEST: ping local - ns-A IP                                        [ OK ]
TEST: ping local - ns-A loopback IP                               [ OK ]
TEST: ping local - loopback                                       [ OK ]
TEST: ping local, device bind - ns-A IP                           [ OK ]
TEST: ping local, device bind - ns-A loopback IP                  [ OK ]
TEST: ping local, device bind - loopback                          [ OK ]
TEST: ping out, blocked by rule - ns-B loopback IP                [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                 [ OK ]
TEST: ping out, blocked by route - ns-B loopback IP               [ OK ]
TEST: ping in, blocked by route - ns-A loopback IP                [ OK ]
TEST: ping out, unreachable default route - ns-B loopback IP      [ OK ]

Tests are known to work on Debian stretch and buster. Appears to work on
Fedora 29.
