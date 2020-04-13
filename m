Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A61E1A6531
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgDMJem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 05:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728050AbgDMJel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 05:34:41 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2020 05:34:41 EDT
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20029C014CDB
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 02:28:13 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id r7so8032843ljg.13
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 02:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ip4c8oMB6zLrxQmN7g56mTf/l58JOv7zXW7fVSjwi2Y=;
        b=0VwxCXPn+5bgHby9Q3FFSKBvV7hBIT8d/+D7I26kql00sZa5cj746RRY8MnN3gHZxL
         CnQHo7pn/zh74R4NIxJTpPxajy5yINQpMDmpue8JcihZ/AdeaO5oJMXyVbBRnw4eVa3v
         vpXscbulqgCfK57WwdMOCLXgm5AFfwMON4Ia3LQyTN4dy53Ew9UP3kHnWKX+xOCg72dS
         Sj091UHMG4E1kc3X67dSIFGVdKty5oaMdv7hXyeitEL6mCznas8mAcaEUSNKegpmRuf/
         KVh44IB1WqJRS8Adf8KJ+EKs1J7XI38tqHB+gZ+qGe6nijyLxu9zmxOC61hy9jVcl4Me
         +ROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ip4c8oMB6zLrxQmN7g56mTf/l58JOv7zXW7fVSjwi2Y=;
        b=lnPKKFb6OpOPIuDtvKgUA/6AcsgiRC3g9T47sf40BftCVvYG2YauM0vbJyGC/HaJUV
         mdRC+6fa60wKJNMdWZ5hudJLE78kevtT5KItBUfGW3biQnM/zFVQWKZ2GgBIs9KTavEi
         FP2LKwTYh97AhIRTzKrUIik1nrJQQYLXb5Aoq6G1M7pVRw9tRR4fGCAp4h8XIL1unF5m
         7qcCRvdxGmgKHVabbBETTYiXxcC0mFlIG+8ZojIi5w1okgjbShdoXMT0z8iEVD9A7fuS
         6ME02D+by3aN0VJv55y7Ofog77btwoFmjc/UuIxPNvbkb2Iev4tzrTiPOHSU7NM4U4xp
         Csow==
X-Gm-Message-State: AGi0PuZ2fhoLCy+S2p/mb4/VPC1mHtCt2wJDLtw4qoOCUNyGzwJluFKI
        Ymy6iXnOfWcJiSMcTVbyG0c/JQ==
X-Google-Smtp-Source: APiQypJR8TjV6IWsg8EiMXe3krO1G/5b6CF9U5LvrsXZTZVvbMldeYb8RHCe3x2zah4N0e0GQJUrtg==
X-Received: by 2002:a2e:9209:: with SMTP id k9mr3264368ljg.230.1586770091507;
        Mon, 13 Apr 2020 02:28:11 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:449a:6c6f:9d43:1ad8:e18f:9ec1? ([2a00:1fa0:449a:6c6f:9d43:1ad8:e18f:9ec1])
        by smtp.gmail.com with ESMTPSA id u19sm6782092lju.83.2020.04.13.02.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 02:28:10 -0700 (PDT)
Subject: Re: [PATCH 4/6] Better documentation of BDPU guard
To:     roucaries.bastien@gmail.com, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?Q?Bastien_Roucari=c3=a8s?= <rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
 <20200412235038.377692-5-rouca@debian.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <cb424879-0d4f-4fc6-3afe-e43f5676093e@cogentembedded.com>
Date:   Mon, 13 Apr 2020 12:28:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200412235038.377692-5-rouca@debian.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 13.04.2020 2:50, roucaries.bastien@gmail.com wrote:

> From: Bastien Roucariès <rouca@debian.org>
> 
> Document that guard disable the port and how to reenable it
> 
> Signed-off-by: Bastien Roucariès <rouca@debian.org>
> ---
>   man/man8/bridge.8 | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index bd33635a..9bfd942f 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -340,7 +340,18 @@ STP BPDUs.
>   .BR "guard on " or " guard off "
>   Controls whether STP BPDUs will be processed by the bridge port. By default,
>   the flag is turned off allowed BPDU processing. Turning this flag on will
> -cause the port to stop processing STP BPDUs.
> +disables

    Disable. And why break the line here?

> +the bridge port if a STP BPDU packet is received.
[...]

MBR, Sergei
