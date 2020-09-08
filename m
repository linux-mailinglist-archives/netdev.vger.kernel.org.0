Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6DC260932
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgIHEIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHEHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:07:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0586C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:07:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so7702312pfn.8
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=POkt9AlbLyATNJEbtmdlkTXth4SUjmoA+qFmlAspSpM=;
        b=Tqcxn1dFZVN8LO6x6NGMOroDHfbampgFUOqP2niqHEtLL0wHnhp1V+rYeORyEDG1Gc
         C9QkFfsr9FcnqfzD0ABEIfZEv2QuKIZ4zOqR2l03erk+itgQTtCDTiC7Xx/2/BqVYIBm
         WBEhIrzFlMbwthXo7k9LbVyGwMTFPKHC7S+GW46+Aark4a5Bvvz4p/Ao6lp6hmx7EeAh
         weCln9zmdgPklTqAoh8ol3VdjYl5qQlaS37nwqj6BYc7yNTicVwq2Ql+rbOaHHjBKBMN
         IjnlRkgNclzd5UeGWo+ihRfGGgV5Jgr/jnYBuGxkfyeqSLNCWnd5oWyE/cRPZJK8QlnM
         ojjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POkt9AlbLyATNJEbtmdlkTXth4SUjmoA+qFmlAspSpM=;
        b=myT64nK1AzskKnZw5WHwgWgQ3OwdLl2oLxCkqp866irhqIUOgFOODNHWyYPaPAq7Yx
         /U3HazLJpimvRtHyzxdO+KYrkdFcI6nl0yj6yipzUS3mvDURtj/ji12CS3Ngkdk+dITL
         yk3PBxabIDNc0O0pfnS5dDpzSuJ/GiHmCFbNnhujebcNIouf0Z3PepfQM3HPWLsNQrY4
         +TskFDHtKShJ9b2VtpkJBn6d7pJgWFAMa9wvfsFmLGAsMI92G+qWNMkzetpjEfUUPGe5
         0/B2pFqool7RH2B84WiUhVsaZy/5MKmSlcxBZ1mA4hzGxps+rGS41uRjMEieZL2weMca
         HTsg==
X-Gm-Message-State: AOAM532L08YSOb8ghH42908mQ6aZzz58uKzVHGD2SLW+XrWBEJPRgiwI
        BPjKBiOK/EHWQXnhKnpO1XxVtrFZALE=
X-Google-Smtp-Source: ABdhPJxPgknLmAub/ChF/UjZ/XzGcuQnwu8fY2K9bGW1moP9vYsLB1W0dnV6c5gXOS/9DGFkFhsGGQ==
X-Received: by 2002:a62:77c1:: with SMTP id s184mr4668107pfc.42.1599538074082;
        Mon, 07 Sep 2020 21:07:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w206sm8889263pfc.1.2020.09.07.21.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:07:53 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: dsa: tag_8021q: include missing
 refcount.h
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b79244f6-f114-9e3e-dd3f-52ccff282b68@gmail.com>
Date:   Mon, 7 Sep 2020 21:07:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907182910.1285496-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 11:29 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The previous assumption was that the caller would already have this
> header file included.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
