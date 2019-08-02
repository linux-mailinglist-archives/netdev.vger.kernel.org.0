Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57C7EAEB
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 06:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfHBEEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 00:04:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46497 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbfHBEEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 00:04:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id c3so12153804pfa.13
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 21:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IxRqWCcmJRX0ie66VBgPfUMAMCzYT0RmzAZRvSfowVk=;
        b=tDZ++Mk3WzE8XLs2I8+5aY4Yd0LnF0hA9R8y6Btk2A9ZBbjsBdES7+qT2C2g1JJBVE
         WSOfe8miYAo69575cB+APc+zoi9gi6d6rHwtS7DQ/aCjb+Nzpi0H/KagUOzdRseKDm/V
         tX13GKJgRW2qOjeIB7ciOJRXN4rO0YSDVhamsbnbgKJ82IiQ+tT1QlvLVDxblSDhkgmz
         5gLL1AIWrOeuFB+bm2ihkRfcCH6lkj1NxD9j0PT+zfKWOQb/VBJpoMAN4+sei/YKMhNB
         6DiDxl2F1mFMBDP84Lv3TYd1p+W0BNpvss/QecRoBVIG9XdC7dlphY8AE9pWd25mHhLB
         SCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxRqWCcmJRX0ie66VBgPfUMAMCzYT0RmzAZRvSfowVk=;
        b=UN1PYD1DtpJbRamLUuaM4wj9f98BCqbAuttYzBgVzaIl9sYD7RubK2mIDdf04ZFIOa
         52EjfhGJuxfZyG9qAWMrmsRb53Wa41N/UcspafkmGyfK14zKKrwrE3+qVb0PL4RPJpx0
         vyNiQqM3EBCwJENu83Al3D9O8RJ1nno3f2XNpDP2mSc9vP2kmfsgCsIJBBppbm8Ez6KU
         LRBrC7GNiD3IBCu2EpxcovKzMC5mzHJXFA1KSyCWQhblTVi6f6eveTnHqv0HQ0nV7mzF
         XBW/9aq3hwcqDc9+SJZWoyzPSA8FFB8Pp2QfLNEpoA2IC7DjTsLiDHuxioZH8K9BfM40
         ClUQ==
X-Gm-Message-State: APjAAAWGmhMCFGxEVLxVx4Leo9yX4/qGv07so4E1hnAWhsMx9ioDga3Z
        vxFmmA9W63UtKj1xke7SMo9heV8R
X-Google-Smtp-Source: APXvYqwT+lcwMnjnFOKWAsUe5RDCrfT9x5cp+iz1/Mp9Nb8jIzOFqHmN/fM5NSB/+xxva87mkQrtBw==
X-Received: by 2002:a65:4948:: with SMTP id q8mr63592511pgs.214.1564718672826;
        Thu, 01 Aug 2019 21:04:32 -0700 (PDT)
Received: from [172.27.227.205] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id br18sm6048445pjb.20.2019.08.01.21.04.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 21:04:31 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190801185648.27653-1-dsahern@kernel.org>
 <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4c89b1cd-4dba-9cd8-0f4e-ae0a5d8bc61c@gmail.com>
Date:   Thu, 1 Aug 2019 22:04:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 6:19 PM, Alexei Starovoitov wrote:
> On Thu, Aug 01, 2019 at 11:56:33AM -0700, David Ahern wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> This is a port the functional test cases created during the development
>> of the VRF feature. It covers various permutations of icmp, tcp and udp
>> for IPv4 and IPv6 including negative tests.
> 
> Thanks a lot for doing this!
> 
> Is there expected output ?

My tests are quiet by default with a verbose option and pause on fail.

$ fcnal-test.sh -h
usage: fcnal-test.sh OPTS

	-4          IPv4 tests only
	-6          IPv6 tests only
	-t <test>   Test name/set to run
	-p          Pause on fail
	-P          Pause after each test
	-v          Be verbose


> All tests suppose to pass on the latest net-next?

they do for me. Buster image. 5.3-rc1 kernel.

> 
> I'm seeing:
> ./fcnal-test.sh
> ...
> SYSCTL: net.ipv4.raw_l3mdev_accept=0
> TEST: ping out - ns-B IP                                                      [ OK ]
> TEST: ping out, device bind - ns-B IP                                         [ OK ]
> TEST: ping out, address bind - ns-B IP                                        [FAIL]
> TEST: ping out - ns-B loopback IP                                             [ OK ]
> TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
> TEST: ping out, address bind - ns-B loopback IP                               [FAIL]
> TEST: ping in - ns-A IP                                                       [ OK ]
> TEST: ping in - ns-A loopback IP                                              [ OK ]
> TEST: ping local - ns-A IP                                                    [ OK ]
> TEST: ping local - ns-A loopback IP                                           [ OK ]
> TEST: ping local - loopback                                                   [ OK ]
> TEST: ping local, device bind - ns-A IP                                       [ OK ]
> TEST: ping local, device bind - ns-A loopback IP                              [FAIL]
> TEST: ping local, device bind - loopback                                      [FAIL]

...
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
...

> 
> with -v I see:
> COMMAND: ip netns exec ns-A ping -c1 -w1 -I 172.16.2.1 172.16.1.2
> ping: unknown iface 172.16.2.1
> TEST: ping out, address bind - ns-B IP                                        [FAIL]

With ping from iputils-ping -I can be an address or a device.

$ man ping

       -I interface
           interface is either an address, or an interface name. If
interface is an address, it
           sets source address to specified interface address. If
interface in an interface name,
           it sets source interface to specified interface. NOTE: For
IPv6, when doing ping to a
           link-local scope address, link specification (by the
'%'-notation in destination, or
           by this option) can be used but it is no longer required.
