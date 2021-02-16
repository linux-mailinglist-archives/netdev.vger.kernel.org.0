Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D48231C534
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBPB5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBPB5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:57:09 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641F0C061574;
        Mon, 15 Feb 2021 17:56:29 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id c16so7788397otp.0;
        Mon, 15 Feb 2021 17:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fsoS79UAUEsj2whbEqmwbdZUAILldiyj6LftGCkz3OQ=;
        b=rzFdSre8F983JDdzADOPwhg8/o5Zzy65m5Qqk/QrxcqVC5Y5FSLuDzKWROFm9mq6Ko
         SuFXT+pG4ZMqTVRG1dPHEmvndE9nUOqqynIipc+QqqgfONklvwNyoivOabUZlNgHKVvV
         OPT6VVW7sXKAPZCs+4kSZJtKVVPfiz9m81BHqfbV4qlz39SRX85sRXcZIUEdjTZ5SYCh
         IBHckpkVtpajmk3/c+w0+Qe9dOrFlITcfUFrgd08VIhw3FqDcfNRVeuwgy5629Kfo2Pb
         8JQZrf+1QQXaaLWV5layHTxaQeV960o8/2iSZQ09lDpGGbMHgltkFzDMHXOqbi5T+lsO
         0zPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fsoS79UAUEsj2whbEqmwbdZUAILldiyj6LftGCkz3OQ=;
        b=AemwIMPD1LDatcfV7iG3HCeujml07nRBQclrqWVxQxkIhQE5TBJLPysO2kxlu3rzXl
         wF13t28Zm/b52YvzYyHvu5OXQQMHQ/wPP6YCXLkw+U/TlCnIbcavM/uoeFhtTc1bp5mQ
         8RBjotnBrK2yQMdL3epe5YKamrz7jr1RglCMh0DPfrTvSU6vPz1qc5ot8sv1U5U+joEw
         6YvVluhH2RI4vwzG5sbb6d21jOSsGMKamNMq2on3D50cEEXA6Iv055KSUVUMuK7NEcjw
         7l11pyhM4RBhtGcCuD49TCAXpRHKxJJEDRWj3KWBSJhv9MiyQpBkLaumHcKwqfNRD5T1
         5Nqg==
X-Gm-Message-State: AOAM531dfBYMBTOLY1O1Bli2QNZGYnrEOaopJSc7DhpO8aiHDFirweKf
        lU4o1eNz0iB9PYP68EflznMRXr3RDdg=
X-Google-Smtp-Source: ABdhPJx8ylU3UbdeRczl5rzGlX7rI2TYTyzz6i3EV6xva8I8SfXosmoOYkYXDH54b05WXjuodyoqmA==
X-Received: by 2002:a05:6830:4d0:: with SMTP id s16mr13100480otd.271.1613440588718;
        Mon, 15 Feb 2021 17:56:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id c10sm691009otu.78.2021.02.15.17.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 17:56:28 -0800 (PST)
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20210214083335.19558-1-leon@kernel.org>
 <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com> <YCoJULID1x2kulQe@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com>
Date:   Mon, 15 Feb 2021 18:56:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCoJULID1x2kulQe@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/21 10:40 PM, Leon Romanovsky wrote:
> On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:
>> what does iproute2-rc mean?
> 
> Patch target is iproute2.git:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/

so you are asking them to be committed for the 5.11 release?


> vs -next repo:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/
> 
> How do you want me to mark the patches?
> 
> https://git.kernel.org/pub/scm/network/iproute2/
> 
> Thanks
> 

