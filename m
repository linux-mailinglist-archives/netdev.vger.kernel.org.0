Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A00490B5C
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbiAQP3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiAQP3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:29:04 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACDDC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 07:29:04 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id bp39so19458126qtb.6
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 07:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+FwShu7TA/7mlfKDg9dqfG0Z0pL4Dn5mDufbLh4AWSQ=;
        b=yKQMP0rZ67i7ubXXoHPYRWgc+s1ZuulxqVVughYoO91UVN4EB/CdC2SSihVYgkp4ql
         opmNax0k5hkgNFEDIzoc+M/LOOgCZ1cX6BPWk5d37E12XYtRaCAeUKdu4cXIXb24X5h9
         5+w8tcHbN/Lb7yJ4GgjEU0gA9pByUGnF9aHCh9jt57BupElqJPMOGcAyRVg6CRwH+E9i
         Mrk36Dp+YKDZ7FyMbkO5QAc7NpO7Oyu3bcJ95QdgNJyTwHxr5wnbupSn+DNS7rILsLTJ
         wtJhP4ggedF6FnI5EqVWYs86y0zrRakhM5DbpkJhoqkzCAVs0zuCx5KvU7yKwEIzoL7m
         5QzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+FwShu7TA/7mlfKDg9dqfG0Z0pL4Dn5mDufbLh4AWSQ=;
        b=qkN0midkl+ASnqzPfusjW9OJ0K5BWbg+ZyS1Lek9WTLF7KF7aDQa9bx6BjYCO2mMqe
         zfY2ewMOMIXYP4NYibr2+E8q6qa8o3dQ/RqTOXezNPvLNpbxR/v8/o4wm0zHd251446Q
         h/cJRojPLAI/YuETBUEAL8spf4ICiHsN3UH1bMLT6dQqzQdG/b6Hwc66WqKd1RCu8ist
         Nsr4iGXdePuDD1QMHR4545nbeN2lyI5nWJtD9kSKTiwukmndI+8HZ2XAZpIwY1TEdXwN
         LQQgUvH0HgGgEQa4XhDnR5rxGsf7K2ersCe2t1AMgye4evEfxl8A/RRqWxKlIz82alOl
         OMuQ==
X-Gm-Message-State: AOAM533m8Xej9D1fM/9dViTkIWnobDVvKF7ZFHTR5fFw5fUjO+YE4UE1
        6j/zTu34le5EF8anj3MpMLROpg==
X-Google-Smtp-Source: ABdhPJzaTC4dNDEUq0lZHsiQ/O39VcIpnmLjlpsdV65j04AB4eMuEdxh4kEOvoeMVy3GvXkFsG/BPw==
X-Received: by 2002:a05:622a:180e:: with SMTP id t14mr9752815qtc.595.1642433343805;
        Mon, 17 Jan 2022 07:29:03 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id bk14sm2151311qkb.35.2022.01.17.07.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 07:29:03 -0800 (PST)
Message-ID: <e8e78f5e-748b-6db4-7abe-4ccbf70eaaf0@mojatatu.com>
Date:   Mon, 17 Jan 2022 10:29:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, victor@mojatatu.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
 <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-16 18:18, David Ahern wrote:
> On 1/11/22 10:54 AM, Stephen Hemminger wrote:
>> This patch set makes iproute2-next main branch compile without warnings
>> on Clang 11 (and probably later versions).
>>
>> Still needs more testing before merge. There are likely to be some
>> unnecessary output format changes from this.
>>
> 
> I think the tc patches are the only likely candidates. The
> print_string_name_value conversion should be clean.
> 
> Jamal: As I recall you have a test suite for tc. Can you test this set?

We try to push, whenever we can, to kernel tdc tests. The Intel robot
should catch issues based on what we have there. If we make part of the
acceptance process (incumbent on people who create the patches) to
run those tests it would help getting cleaner submissions. Not sure
if we can have a bot doing this..

Punting to Victor(on Cc) to run the tests and double check if we
have test  cases that cover for these changes.

cheers,
jamal
