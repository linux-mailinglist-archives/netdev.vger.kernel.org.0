Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA39C2BBF
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 03:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfJAByd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 21:54:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46504 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJAByd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 21:54:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so8466121pgm.13
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 18:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rTG198avqUudOdJvNS7+5NFwmrkw4LJQyvU4/hRNwO0=;
        b=hjMeVkCFkaC0PN0FkK+zvBmhYlMCQ5CpXtLvRqF1IdJJ809dq7vxXseZAgBst/QeKe
         Ih02Bss6TRxpwY32PsSbiR8D0kVBlKRhZ32wb12JF6fPszx3RNcz4YK3hSg46nRNKx4Y
         wB2LmtTNks0L3gUHiBUQ8Ynz2w5j+0QyEuAh5xyX1mk7gcAGFY2SmPWbFsuCNfy0UUXT
         DM25ErQEX79dSiAiSV7aYlVGA6p2ouGjGArMzR0H+5wkQsiRSjHoui96ILsti+4QJbaC
         uA01onb8r2YneN+sNvdD+UtjRWJ2ROwbLSsfRnqnVF16JJnXmA3Uleq8gb1oDcdQ+peR
         O0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rTG198avqUudOdJvNS7+5NFwmrkw4LJQyvU4/hRNwO0=;
        b=pvL6rU6i7u246TQICAsoG6/sg3HxHIZOc4lxqmVRGO8yvHH3oV7SmouLAByuIWNF1f
         NmEOsneXelHmJkn1unrVXFVWeEZ2n3xZWZxj4IT4l+9NWzkUI9Wfc1YGK6IgFGYmZhz0
         pHbbcX4mdFXXfy+iLxjlDX7InrUYgoB41VSA9Zrgg3Yv3y5KrhomLY1dU8LuFcquCqjT
         zrbA1ltG/SChMZUu+WwexfLmaLlEEwKwgpSTJ9jkhXNVfxzKbFambh7SWeEWfeQRxWnR
         qYUxqxUqy4sXUKtlUcrF8MkHzy1KPKgQU7+lGRBVXRm+jzKfyHbJtI5RkbhDgrD68A4M
         cpFQ==
X-Gm-Message-State: APjAAAWeyjbNA4cEW+U39m2zwRFf3vjPzVJjbRJs3yIq43iqp2pgvpxy
        4e0IUuOx+Ys6sw2XVohG7/JPfPw0uy3Fig==
X-Google-Smtp-Source: APXvYqwjKWUXX+usLdxmEmB2onvKfWUBTcKBmuheiowaPz/fM0DODGyExGHXNSoZG83onaB5g09MbQ==
X-Received: by 2002:aa7:8750:: with SMTP id g16mr24357484pfo.190.1569894872170;
        Mon, 30 Sep 2019 18:54:32 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i74sm17943414pfe.28.2019.09.30.18.54.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 18:54:31 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/5] ionic: driver updates
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190930214920.18764-1-snelson@pensando.io>
 <20190930.164857.1326063600782757885.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <134a674a-4d66-e00b-9f74-935e7728c8f0@pensando.io>
Date:   Mon, 30 Sep 2019 18:54:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190930.164857.1326063600782757885.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 4:48 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 30 Sep 2019 14:49:15 -0700
>
>> These patches are a few updates to clean up some code
>> issues and add an ethtool feature.
>>
>> v2: add cover letter
>>      edit a couple of patch descriptions for clarity and add Fixes tags
> I agree with Jakub that Fixes: tags for cleanups really doesn't fit the
> character and usage of Fixes:.
>
> Please address this and the rest of his feedback, thank you.
Sure.  I was on the edge on those Fixes tags as well, and only added 
them in as a last minute thought, even tho' I was only aiming these at 
net-next.  I'll clean those up.

sln

