Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7C32FBB9
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 17:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhCFQMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 11:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhCFQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 11:12:17 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F41C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 08:12:17 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id l11so1184870oov.13
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 08:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tW1gHX3gSTz0GPVLpavmnO8eGOz65fyOhx30z8m2Pck=;
        b=fV00oRQHKfKxnGmRqSFSplTeVj5lv3LrCAlIq81F7iB5sHvGvrv4Y9IqUce4UVXm85
         Ips9P8voFRDnF783/quNtUCxNDU1LVsA555XfodSv/3jDMUj2NyTYWTkpYyWVuP/qWaI
         x966LkVjI36A9n+hJ/bSIxSxyNkNaQMe9PgrUbuBX9dprh/nRC4FAQuhT8LLoSSkfQyT
         rI6XCSZZctEM1WklF1CBN6+kfPHRLof3vTy6sv/Sk65NSOEhDO0RJfb0qzBaNptmK01L
         FMPb33jecHIKWS9QqnJctSaGDIqeexOAxhzbSdT7Bu2ijjJrDip/LFEdH0sgBQEi6kEx
         b9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tW1gHX3gSTz0GPVLpavmnO8eGOz65fyOhx30z8m2Pck=;
        b=cHWi7rjM2v3jZlhc+2qwn1sanby8UyzAp0BLkoR4+8YqEx7BGTSxAaBPyKfJny2Zyc
         7/HuP9ZTRbCeK2xyJdxt//oUq4gXXeeQro8tCpdUxNAvYwLJ80CPsIj3hFI2vw2xhm3f
         PHx2cYokkvuFYi7x5NmhM3IjxyCYp3Vhjo7MVTonSCwwmhMjYDVwxbYDKX+tks5utRm5
         SKO8B7SJahjTEN4n5Paq/xbYu/1iDASSuBTm6EU6vq7AFzTzUmtpjg4qcBuWb+W1NVdj
         9Vs4YWitpGopqDPp/nEIKdDnodmHVsmqqMszQ8WPOjBClnoolSEFAudPHdp6Gg9ovhKq
         Cl9g==
X-Gm-Message-State: AOAM533T1bN40aSb9fAl1nYlSi0HN+JkbBPvECise3OipCdDQciETLh5
        gR0cN4/0GdCz2QfyZxu0PAdpw7f6qhw=
X-Google-Smtp-Source: ABdhPJzeTqkfSr8kPpHf5jMgKyfBvoARq5AdjkGFP/QKuTdSExArTD0uNDG5Wv1h+xgodK4+pPb/Rw==
X-Received: by 2002:a4a:c592:: with SMTP id x18mr12046907oop.9.1615047136888;
        Sat, 06 Mar 2021 08:12:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id k68sm1373538otk.28.2021.03.06.08.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 08:12:16 -0800 (PST)
Subject: Re: VRF leaking doesn't work
To:     Greesha Mikhalkin <grigoriymikhalkin@gmail.com>,
        netdev@vger.kernel.org
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com>
Date:   Sat, 6 Mar 2021 09:12:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 3:57 AM, Greesha Mikhalkin wrote:
> Main goal is that 100.255.254.3 should be reachable from vrf2. But
> after this setup it doesn’t work. When i run `ping -I vrf2
> 100.255.254.3` it sends packets from source address that belongs to
> vlan1 enslaved by vrf1. I can see in tcpdump that ICMP packets are
> sent and then returned to source address but they're not returned to
> ping command for some reason. To be clear `ping -I vrf1 …` works fine.

I remember this case now: VRF route leaking works for fowarding, but not
local traffic. If a packet arrives in vrf2, it should get forwarded to
vrf1 and on to its destination. If the reverse route exists then round
trip traffic works.
