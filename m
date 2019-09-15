Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35EBB3146
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfIOR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:58:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46440 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOR6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:58:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so21219113pfg.13
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 10:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4P4zb5lAflrGCfmGI6aYaNm2vdkoKHu9bO5OFwDigcU=;
        b=BPJNvtZsXpcAR65y/ufHWTHXcgDHSZ9Fq2muasdQN+KhBhkBSjxae2FK+3NV7Rwo36
         lpOvAXXvNHw98+f33t0mZrRqSa33pVoE7Jn94rTod8rH0wdRsmI2XP3uGXtwjEXzvSuo
         vQq9GwNLVRFfzykr5t0oDYghVucKSuc9dMywmTuurzU65Igh4JglUJ6dta8pJupsUq1p
         zuYmVUXpN+2ZvyjipWc5BJOTkBfJ/B21UqRa0iHdbYTwonOvF3STBLR026kF6bLBav+Q
         CcxKpZbk0WFQnKX5OHOHN1onLr/EtEVqk8+fqbTF+MM7B5nBbWK3zEMZF9fSlUe/cnIa
         vUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4P4zb5lAflrGCfmGI6aYaNm2vdkoKHu9bO5OFwDigcU=;
        b=ioAPBQIah2O09dk7+Ut7q5TG1Uqmo5VMgAg05uKQ0VKIEcqzRuN+5yr2mxZJUG6wzJ
         /aFTPLWrHgTdzAZAVT3PzHZMffVAunrRoi/TCldXWXrUXcpAda4IcOLmLDT/9WJi89qI
         JEuGxntA6+neeGgqOixW5wiufb0b86UHR2jDQ+rPjHL4wpkOKCaLzhOGAYmcH1iTBvpx
         FT0phSHM/bHmD544PkhmcFHv33RXcp9LLRSqQlAmDXb3NSTQO5wUGhBc2MQLgiyO4pGT
         mPFR+HaiONAYmrSKpWNbYXI+T4Bh3MR+4IYzJR1PAKgRRoPzsgPKZncCVUibA67zeQWe
         R/UQ==
X-Gm-Message-State: APjAAAV/kIwXytwX3BG9qEaGRGANJPfbholkXtiJi666NzeIe60uA9D6
        KHirBAmqjzbNhg7f1zzpPwY=
X-Google-Smtp-Source: APXvYqx3+8qfu8M9ws+l/h1OyadGPG8eMDdFZyogcvX3TOkHMvD6llRQMY3//CIwM6S1KliMj33B5Q==
X-Received: by 2002:a62:2ccf:: with SMTP id s198mr65174554pfs.216.1568570316407;
        Sun, 15 Sep 2019 10:58:36 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v43sm9624028pjb.1.2019.09.15.10.58.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:58:35 -0700 (PDT)
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
To:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
References: <20190912112938.2292-1-jiri@resnulli.us>
 <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
 <20190914060012.GC2276@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f32dc69-7cc1-4488-a1b6-94db64748630@gmail.com>
Date:   Sun, 15 Sep 2019 11:58:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190914060012.GC2276@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/19 12:00 AM, Jiri Pirko wrote:
> Fri, Sep 13, 2019 at 07:25:07PM CEST, dsahern@gmail.com wrote:
>> On 9/12/19 12:29 PM, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> I was under impression they are already merged, but apparently they are
>>> not. I just rebased them on top of current iproute2 net-next tree.
>>>
>>
>> they were not forgotten; they were dropped asking for changes.
>>
>> thread is here:
>> https://lore.kernel.org/netdev/20190604134450.2839-3-jiri@resnulli.us/
> 
> Well not really. The path was discussed in the thread. However, that is
> unrelated to the changes these patches do. The flashing itself is
> already there and present. These patches only add status.
> 
> Did I missed something?
> 

you are thinking like a kernel developer and not a user.

The second patch has a man page change that should state that firmware
files are expected to be in /lib/firmware and that path is added by the
kernel so the path passed on the command line needs to drop that part.
