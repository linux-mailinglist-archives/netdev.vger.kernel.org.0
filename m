Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0C39044B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhEYOt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:49:57 -0400
Received: from dispatchb-us1.ppe-hosted.com ([67.231.154.165]:43394 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234106AbhEYOty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:49:54 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2021 10:49:54 EDT
Received: from dispatchb-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatchb-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 135AC27172
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:41:23 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4F161A0065;
        Tue, 25 May 2021 14:41:21 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 58A7C200087;
        Tue, 25 May 2021 14:41:21 +0000 (UTC)
Received: from [192.168.254.6] (unknown [50.34.172.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 739A113C2B1;
        Tue, 25 May 2021 07:41:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 739A113C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1621953680;
        bh=8yfmuMbpth9BXPYcTvcTm95Fo/BImujSL6NUfXWP3s8=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=aGFeB73b3KgQxXiRZIpdviA2UNbSc/5KcjZGV83r0eh6msDfQPdbJaaQsLgQKhC4w
         8AMjGKNni1J8Z8x8oiUzNmbacHNQH/onb8nGCqB4pEHncqqIgR9sMCLRScCiMTIy50
         hD+PCmExMqCRuKtVXVaPhQQhk6xUPtwYDAhEL44Q=
Subject: Re: XFRM programming with VRF enslaved interfaces
To:     David Ahern <dsahern@gmail.com>,
        Rob Dover <Rob.Dover@metaswitch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DM5PR0201MB3527C144EC33D8E6519A7484814D9@DM5PR0201MB3527.namprd02.prod.outlook.com>
 <dd1ced20-899d-56a7-d01d-e62a15d04d2c@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <a72d2a4e-c6fa-09b5-cda3-6070a1d9b574@candelatech.com>
Date:   Tue, 25 May 2021 07:41:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <dd1ced20-899d-56a7-d01d-e62a15d04d2c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1621953682-KHM5q3Xeh5iX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 12:37 PM, David Ahern wrote:
> [ cc Ben ]
> 
> On 4/15/21 9:51 AM, Rob Dover wrote:
>> Hi there,
>>
>> I'm working on an application that's programming IPSec connections via XFRM on VRFs. I'm seeing some strange behaviour in cases where there is an enslaved interface on the VRF - was wondering if anyone has seen something like this before or perhaps knows how this is supposed to work?
> 
> Ben was / is looking at ipsec and VRF. Maybe he has some thoughts.

My thought is that openvpn is nearly impossible to use in interesting ways by itself,
and when added to vrf, it is too complicated for me to deal with.  I eventually managed to sort of get
it to work.  I forget the details, but I think I had to put the 'real' network device in one vrf
and the xfrm in another.  Probably I posted my example to the mailing list...

You do need recent kernel and openvpn to have a chance of this working.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
