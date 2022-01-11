Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB548B77D
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiAKTlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbiAKTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:41:49 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C4EC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:41:48 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id e9so210487wra.2
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=rL0uwXVH0wZKObRjJstx/qdINlP47rbHAnqHdJwRHE8=;
        b=i6g+m+cxIazjaD6/iLQfI/Oq/Xaxv52l91IHOGb3TEFNqXeF1fZ0MTwN5cN6AY/DHq
         6GmhFru9qqAHdQ7oUhyRoSabLpjsLtfUdlJWJfniQPBf3expK1VfpOpgvYTCxJqc6hgw
         qMHeMF+TzriwLvav780fW2HtAnoq1YbCuglpICC/RqW7p8h7cUwSzqbZkza5KiKyNdjo
         e0L1/VJSv4juJrh029sj9SHGRZnIgGuiOY+1AteDYSP2fprU06NqI15QQGloiTJ5yfUR
         vR4uTKjv/I5pDRFDcZgc63C/9XqQ7OoUYqqoLSwhsRGoyd+dzqK7jqli4njd1xf9EmnO
         M1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=rL0uwXVH0wZKObRjJstx/qdINlP47rbHAnqHdJwRHE8=;
        b=DnoJIkWXRbsfzMo2flHHbYg1S528wHWZ8LAA6CGW7y+aPulc5AQcYMHXQPNy0vR9Td
         wfdPNs9fpiNL9/V640AN/jBJVTTJpVNZnr8ma8BVeKf8OQlHMCGHntuLULqRamzZgpQc
         J7zBIMqAlgoiZLnJdvgYwmNfo6DUAEFovz/sWtdXJi7+1vKuKRaCIi1uf8VLE0JmYIO+
         6wwHTJ0RyNyDGY3BNc9MyFdinak1pdwcmYGaM3TDYnS/IzyjBXRdlVna3AFNuBMd+FFM
         7yXx25Ve67VzJ9cofbUHQH5q6ypvZyC1MDeeJujaDBow9Ld+scZXXcl81jcJk4tK3dBO
         89+A==
X-Gm-Message-State: AOAM531W0ps23MsIATSDthg+chqJwROoVGoDZmZQg7RDhdxwkmnqoKRw
        kp2kcFy0/zXF0PaWHcrRgEMBWBruETM=
X-Google-Smtp-Source: ABdhPJzF/9L1q4Df3DE8YV/OrN8HOgdNuXVK/a2L/OmjY4TQX/ovD2r5HQlk5jIeD2WwzWZ7JZhshg==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr5036327wrp.178.1641930107299;
        Tue, 11 Jan 2022 11:41:47 -0800 (PST)
Received: from ?IPV6:2003:ea:8f2f:5b00:946a:ebae:eb56:7988? (p200300ea8f2f5b00946aebaeeb567988.dip0.t-ipconnect.de. [2003:ea:8f2f:5b00:946a:ebae:eb56:7988])
        by smtp.googlemail.com with ESMTPSA id q3sm10123344wrr.55.2022.01.11.11.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 11:41:46 -0800 (PST)
Message-ID: <6d6ff22c-df69-36c2-4d42-03ed7f539761@gmail.com>
Date:   Tue, 11 Jan 2022 20:41:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>,
        Vijay Balakrishna <vijayb@linux.microsoft.com>
Cc:     Netdev <netdev@vger.kernel.org>
References: <f7bcc68d-289d-4c13-f73d-77e349f4674e@linux.microsoft.com>
 <CACKFLim=ENcZMk+8UUwg87PPdu6zDC1Ld5b54Pp+_WSow9g_Og@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [bnxt] Error: Unable to read VPD
In-Reply-To: <CACKFLim=ENcZMk+8UUwg87PPdu6zDC1Ld5b54Pp+_WSow9g_Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.2022 22:15, Michael Chan wrote:
> On Mon, Jan 10, 2022 at 1:02 PM Vijay Balakrishna
> <vijayb@linux.microsoft.com> wrote:
>>
>>
>> Since moving to 5.10 from 5.4 we are seeing
>>
>>> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.0 (unnamed net_device) (uninitialized): Unable to read VPD
>>>
>>> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.1 (unnamed net_device) (uninitialized): Unable to read VPD
>>
>> these appear to be harmless and introduced by
>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0d0fd70fed5cc4f1e2dd98b801be63b07b4d6ac
>> Does "Unable to read VPD" need to be an error or can it be a warning
>> (netdev_warn)?
>>
> 
> We can change these to warnings.  Thanks.

Since 5.15 it is a pci_warn() already. Supposedly "Unable to read VPD" here simply means
that the device has no (valid) VPD. Does "lspci -vv" list any VPD info?
If VPD is an optional feature, then maybe the warning should be changed to info level
and the text should be less alarming.
