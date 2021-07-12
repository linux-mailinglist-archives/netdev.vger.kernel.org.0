Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E933C5B1F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhGLLFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 07:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhGLLFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 07:05:31 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F3C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 04:02:42 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 9so17501138qkf.3
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 04:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C6NcBH3JZ6eK6QArJo0y33EQcW17suwtnIeGIcgQByg=;
        b=YRz+bfkq7fBp3sFP63zMWOOcc4fIKG/u2GvxpcpvJX43XQxDv95/kV+bSoffbICPln
         6fTno4NCMEBazke+jDr0bfGWXDZIByfSRXiUkNAkEhtv4bHOSf8n11kL6Lrw3S3CxdgP
         0jMDwQ53OVi0rxoNx4raYfchuPzYNHcVz66p/PL8ksILTbVAAaMw6dttDmIm9+el/Trq
         2JWE0FKQ/7x+Ke/18HMbnE+pMGQ69WRXLo6ii2S226Rs+H3K1dAjCRziRF7hIUxtrKoV
         YIy/dl8KYUtU7ge+qW+vcwQsrUAaJK1p6Kh5zAeghYrd4TsW0J5BVwrqxvW5RDY1y2X1
         5GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C6NcBH3JZ6eK6QArJo0y33EQcW17suwtnIeGIcgQByg=;
        b=jl5e9oBjqg9ZHe2Mba6ZvCVmpUMX3LOBr0YvHR8rCLxHyCjJA9BwCJ0gfi2a0obtXQ
         AMAEVLdAOR0sle4WTqa7R4N6NNDw7IcFTzYrs/uppsjqJxYK0PoGV59eKZYZqXGV81zj
         qbCNQLzlwR2x5f5p13NZv4QaMai2FY/UIzQIvrxKmRsqQf6UTb04/TbxNxtu7WRekJpd
         /cYdjiUDun0zIoUHFCj+tW77BkIs9ROjpHeZz/hA9DRo+bIUM7dw0UCS2AlvA3WEIrxV
         fbcwxlsc4sZ9eu8iIjoN3Xej5hnbRxX4jVZBYmN2uA7wP2YounoVkGTEgUP+Cp11V+wa
         thyA==
X-Gm-Message-State: AOAM533NCD0qEZ2FwcTru19uWeNUeLFPtFMeEyf9zzR2ZPcSr34yJT/1
        DH0FiRKdtJNbvjExJNbsmYloSw==
X-Google-Smtp-Source: ABdhPJzy0E2ftqYDnAToJPyRRyQkFObXcDrk6AyTCx0wIr4F+PEHBv0bB41UAuVq8QY8KKdwZcAwkw==
X-Received: by 2002:a05:620a:15da:: with SMTP id o26mr28328153qkm.285.1626087762030;
        Mon, 12 Jul 2021 04:02:42 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id h4sm5676027qti.0.2021.07.12.04.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 04:02:41 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     David Ahern <dsahern@gmail.com>, Roi Dayan <roid@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
 <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
 <37a0aae7-d32b-4dfd-9832-5b443d73abb6@nvidia.com>
 <db692da0-680f-a6a9-138b-752e262bf899@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <5324ca9a-6671-2698-f6a4-4ac94ad7bc26@mojatatu.com>
Date:   Mon, 12 Jul 2021 07:02:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <db692da0-680f-a6a9-138b-752e262bf899@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-11 12:00 p.m., David Ahern wrote:

>> ...
>>          action order 1:  police 0x1 rate 1Mbit burst 20Kb mtu 2Kb action
>> reclassify overhead 0b
>>
>>
>>
>>
>> -       print_string(PRINT_ANY, "kind", "%s", "police");
>> +       print_string(PRINT_JSON, "kind", "%s", "police");
>>
>> -       print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
>> +       print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
>> +       print_uint(PRINT_JSON, "index", NULL, p->index);
>>
>>
> 
> Jamal: opinions?

Looks good to me. Roi please run the kernel tests to make sure
nothing breaks.

cheers,
jamal

