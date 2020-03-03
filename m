Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F9177D33
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgCCRQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:16:55 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:40560 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgCCRQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:16:55 -0500
Received: by mail-qk1-f176.google.com with SMTP id m2so4144197qka.7
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 09:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XWljNw2SBST46AldIQEIaiS35XiIpPpEVhzt0ZW808E=;
        b=TE1aTETStaIYvGK/gYxcOri4uSGJF5tJvHXSjt6Pr+bVEVAdQ9kIeoUFWnQzbO1o/k
         hFDPijLlyS6i9xN/MC4aoz+kPvbgakK7rP+NsuFBVfSv/CsgMTc5TAmrR7rLdaBGGoHX
         tJZW1B0OucvAFkQh9Hyw4zX64f6VgGV7yVM7hoK6e6gEFxgKixS6ppj0vVSWV3Q0qm8n
         N5kCsGaMDddCAfdYPrQmFXYletOpwKV5buU4dHOsDas+O1hiRW5t5UmgIS9JeH8U8l6C
         I6Y3D8SSz0WvXTFzaweciQf4TgLyMW4lm7jbMXvFb9P+L+YmfEhDVA3nvwlBhDMKc3BT
         BnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XWljNw2SBST46AldIQEIaiS35XiIpPpEVhzt0ZW808E=;
        b=Ij0BDbtrChQMz60BFEqcomDb8UuAgaFS0g7ewxTC2JbM/zhar8Bv0L6O30/Yor0yX9
         no68kgHsapdcqCIauQaZbdoB/KdFTJS4HThqEosoYEZS5M8QhEvVaXp4Mlp4KvWnoPHF
         uPjWoORlX5RMfau0uIzFkeK3J1KtSHMB7CuTYPcArh103DjgOjIS0WDQhlBJfocYddAu
         72ckRvlbyaeAwNNmVqHGoZ9JAZYN7lo28JhCKz5CC97tW8y4/Q61pYt1qgC/E9D6Jyyb
         l7p3tzTZiFHE3FpFGVaAz0j0CL5WUpc3HjI642d0MB8OP55ruslOj2ZB2p/SlxGyKlHk
         RtxQ==
X-Gm-Message-State: ANhLgQ06HhBXVJnzTeP9VcHBP/48vm+wTGzDQcmhO41trlTKcMf04b1+
        vE2YfzmXv0rqeZm+pOJ0KC8=
X-Google-Smtp-Source: ADFU+vv2Os1lkOr1NUBJH74TSd7j3eXnw1d3vIPORm+Swj21uBNgBEnKEWKtWbPVkrbO7EJ5dGznBg==
X-Received: by 2002:a05:620a:8c8:: with SMTP id z8mr5338678qkz.205.1583255814553;
        Tue, 03 Mar 2020 09:16:54 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.googlemail.com with ESMTPSA id n138sm12396170qkn.33.2020.03.03.09.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 09:16:53 -0800 (PST)
Subject: Re: ip link vf info truncating with many VFs
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>
References: <16b289f6-b025-5dd3-443d-92d4c167e79c@intel.com>
 <20200302151704.56fe3dd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ff51329f-9f01-53c7-8214-96542321400f@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eba65074-375b-6536-6e29-9d4bb85a3cfd@gmail.com>
Date:   Tue, 3 Mar 2020 10:16:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ff51329f-9f01-53c7-8214-96542321400f@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 4:21 PM, Jacob Keller wrote:
> On 3/2/2020 3:17 PM, Jakub Kicinski wrote:
>> On Fri, 28 Feb 2020 16:33:40 -0800 Jacob Keller wrote:
>>> Hi,
>>>
>>> I recently noticed an issue in the rtnetlink API for obtaining VF
>>> information.
>>>
>>> If a device creates 222 or more VF devices, the rtnl_fill_vf function
>>> will incorrectly label the size of the IFLA_VFINFO_LIST attribute. This
>>> occurs because rtnl_fill_vfinfo will have added more than 65k (maximum
>>> size of a single attribute since nla_len is a __u16).
>>>
>>> This causes the calculation in nla_nest_end to overflow and report a
>>> significantly shorter length value. Worse case, with 222 VFs, the "ip
>>> link show <device>" reports no VF info at all.
>>>
>>> For some reason, the nla_put calls do not trigger an EMSGSIZE error,
>>> because the skb itself is capable of holding the data.
>>>
>>> I think the right thing is probably to do some sort of
>>> overflow-protected calculation and print a warning... or find a way to
>>> fix nla_put to error with -EMSGSIZE if we would exceed the nested
>>> attribute size limit... I am not sure how to do that at a glance.
>>
>> Making nla_nest_end() return an error on overflow seems like 
>> the most reasonable way forward to me, FWIW. Simply compare
>> the result to U16_MAX, I don't think anything more clever is
>> needed.
>>
> 
> Sure, I alto think that's the right approach to fix this.
> 
> As long we calculate the value using something larger than a u16 first,
> that should work.
> 

Another pandora's box.

Seems like there are a few other places that set nla_len that should be
checked as well - like __nla_reserve and that bleeds into __nla_put.
