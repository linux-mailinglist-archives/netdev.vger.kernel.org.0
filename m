Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490D6149D6D
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgAZW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:56:27 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46979 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAZW41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 17:56:27 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so3050088pll.13
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 14:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CHXL5LBKRXjepifWGf5nfh8aThoxhhNaGCBjrPxHCPw=;
        b=408xpMRmZ8Lpg/yM5rDXrmLYYgaswX4h+RPbIiZgwqF7BfQV/3VE8nFW5sjvs1aEv6
         6OJ9se+ceFnjeYV8pZgz5AHFQ/O2i3JIfIRvbYpyG4rQjVoWumph0JmJGVLDHTRPnxA5
         UsrDb39WXGG4+D0vaJ1WWi5/UzJ/r4EoI4u4JlDCGVrwcw68Z8MzPFxc8mmi4jkfgnmQ
         gJNnSY1JMiBEXyC6CHvfnnmG2L3pdG3AhQlTrTTPlTBvfu9j5J+nizHz0w+sC1d63ldg
         VCi1GkHVc4uKon7PlnDki6kkNAtxPUZO8F2D/18aqfDL6I3g8DrnMZ68M6uLmVxZWdNl
         39mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CHXL5LBKRXjepifWGf5nfh8aThoxhhNaGCBjrPxHCPw=;
        b=deBdb5gCaw0D+TlV0Jojm8hojupDIqHuAGe6XWKfKhbOzaNfPjTeGRajcTzmnrUAcq
         miN+TEIuBbU4k7csaz4g75/iVvA1piguO7zkObJ+rxKYSlnv1NGBVAxyq8OXHn2EjP1G
         eHtZVhc4aDwG1WhjcfhW1ITBDRT2vWn0YNFGb6kqkL9TBPjAb09N4HKQR5kOMJTIpdS+
         3n+sMSu0SLKusRP3dKhbgem3Se+PJAlJp+/3iu1j8YJa6/29wY5p8IuuHxSe5qpkxHMd
         mFJNuEgWrygWutVoUwslAacUNEow1m/EpET3hRLDRkovx0/CkdyqXv2tOiZEAqYrQdAF
         vnGg==
X-Gm-Message-State: APjAAAWs3VshylYL6Z4x03/f3ZGxV7rMqk7FO3Zb2UmSmcZp6gIK80Ka
        REx3YvBFclluGZafprrSyGh/pw==
X-Google-Smtp-Source: APXvYqwNCwTfv1GXzVxGZ0iSHuWBouTCPx13KPlUkyN+H7NWaGZXaqDvUuRRo1l+dKK6d41rJHAwhA==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr14371965plb.323.1580079385664;
        Sun, 26 Jan 2020 14:56:25 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id l2sm13449339pff.59.2020.01.26.14.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 14:56:25 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal> <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
 <20200126212424.GD3870@unreal>
 <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
 <20200126222253.GX22304@unicorn.suse.cz>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b05ea7dd-d985-66b5-07c6-9c1d7ba74429@pensando.io>
Date:   Sun, 26 Jan 2020 14:57:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126222253.GX22304@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 2:22 PM, Michal Kubecek wrote:
> On Sun, Jan 26, 2020 at 02:12:38PM -0800, Shannon Nelson wrote:
>> On 1/26/20 1:24 PM, Leon Romanovsky wrote:
>>> On Sun, Jan 26, 2020 at 01:17:52PM -0800, Shannon Nelson wrote:
>>>> On 1/26/20 1:08 PM, Leon Romanovsky wrote:
>>>>> The long-standing policy in kernel that we don't really care about
>>>>> out-of-tree code.
>>>> That doesn't mean we need to be aggressively against out-of-tree code.  One
>>>> of the positive points about Linux and loadable modules has always been the
>>>> flexibility that allows and encourages innovation, and helps enable more
>>>> work and testing before a driver can become a fully-fledged part of the
>>>> kernel.  This move actively discourages part of that flexibility and I think
>>>> it is breaking part of the usefulness of modules.
>>> You are mixing definitions, nothing stops those people to innovate and
>>> develop their code inside kernel and as standalone modules too.
>>>
>>> It just stops them to put useless driver version string inside ethtool.
>>> If they feel that their life can't be without something from 90s, they
>>> have venerable MODULE_VERSION() macro to print anything they want.
>>>
>> Part of the pain of supporting our users is getting them to give us useful
>> information about their problem.  The more commands I need them to run to
>> get information about the environment, the less likely I will get anything
>> useful.  We've been training our users over the years to use "ethtool -i" to
>> get a good chunk of that info, with the knowledge that the driver version is
>> only a hint, based upon the distro involved.  I don't want to lose that
>> hint.  If anything, I'd prefer that we added a field for UTS_RELEASE in the
>> ethtool output, but I know that's too much to ask.
> At the same time, I've been trying to explain both our L1/L2 support
> guys and our customers that "driver version" information reported by
> "ethtool -i" is almost useless and that if they really want to identify
> driver version, they should rather use srcversion as reported by modinfo
> or sysfs.
>
> Michal

So as I suggested elsewhere, can we compromise by not bashing the driver 
string in the caller stack, but require the in-kernel drivers to use a 
particular macro that will put the kernel/git version into the string?  
This allows out-of-tree drivers the option of overriding the version 
with some other string that can be meaningful in any other given old or 
new distro kernel.  This should be easy to enforce mechanically with 
checkpatch, and easy enough to do a sweeping coccinelle change on the 
existing drivers.

sln

