Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD77482155
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbhLaBuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:50:01 -0500
Received: from m12-15.163.com ([220.181.12.15]:59506 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhLaBuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 20:50:00 -0500
X-Greylist: delayed 2383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 20:50:00 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:Subject:From; bh=OrauC
        ncmRLm5NLtZnieka/nTgvm33i0zC6FQ4q3zASQ=; b=RNPWRtSYm/85DH/grVHfJ
        zIL+x9Zca6K+WLEKMrG4A7gq4APtJ6ALeVLBAjqohzkn9AFmRcKm6hRBdkPeLL2G
        jfoBaBG35CInN+9OA+AMcSSBXPFNzgGo7yYGlzG/bw0qDYwlDHsdsP2Y5QitgTua
        ezBZ5NooCqnsRpr8sngaps=
Received: from [192.168.16.100] (unknown [110.80.1.43])
        by smtp11 (Coremail) with SMTP id D8CowABHDVKmYc5hgNZ6Dw--.160S2;
        Fri, 31 Dec 2021 09:49:29 +0800 (CST)
Message-ID: <88663bf1-76ed-646f-1825-870ca8f7b239@163.com>
Date:   Fri, 31 Dec 2021 09:49:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] selftests: net: udpgro_fwd.sh: Use ping6 on systems
 where ping doesn't handle IPv6
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
References: <a2295ebf-0734-a480-e908-caf5c02cb6a9@163.com>
 <20211230173106.1345deb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jianguo Wu <wujianguo106@163.com>
In-Reply-To: <20211230173106.1345deb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowABHDVKmYc5hgNZ6Dw--.160S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFW5uFWxJFyruF4DWrW3Jrb_yoWfGFcEkF
        sF9rWqgay5ZryIka9xJw1jg3sIv3yj9a4UW3s7Ary3C3s3A3y7Xw4ktF17Zr4UJw1Ygr9I
        vFn0vFWYkr1YvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbsmR5UUUUU==
X-Originating-IP: [110.80.1.43]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbB9w96kF2Mbnf80AABs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/12/31 9:31, Jakub Kicinski 写道:
> On Fri, 31 Dec 2021 09:10:00 +0800 Jianguo Wu wrote:
>> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>>
>> In CentOS7(iputils-20160308-10.el7.x86_64), udpgro_fwd.sh output
>> following message:
>>   ping: 2001:db8:1::100: Address family for hostname not supported
>>
>> Use ping6 on systems where ping doesn't handle IPv6.
>>
>> v1 -> v2:
>>  - explicitly checking the available ping feature, as e.g. do the
>>    bareudp.sh self-tests.(Paolo)
>>
>> Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
>> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> I'm afraid v1 got silently applied, see 8b3170e07539 ("selftests: net:
> using ping6 for IPv6 in udpgro_fwd.sh") upstream. Could you send an
> incremental patch?

OK, I will send an incremental patch.

Thanks!

Jianguo

