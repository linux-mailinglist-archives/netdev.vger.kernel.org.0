Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6C3425CE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhCSTJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhCSTIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:08:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE501C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 12:08:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hq27so11428833ejc.9
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 12:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oQmQSS60x65z6dWBIVnjzdQBp74/xdyS/baf8xqTOg8=;
        b=BPNm2fv9LQTjwZtcDwgbOS626Q+CvkD8ZVslZjs4D5t3BaWmnNvHMtvLF1BGHS0EVm
         WHqQM7hmn2+wJqXewrkUf/vjFHL6Ir3DO3HETn6/oBzni0T9rJkUlEtO4wseK3wCAsOl
         OefVbEiobJEPSp9KAmp8SdkaPOnr3mSHFco5fH3G/KQUW08LZJzY64CXy09r0CS7tc43
         8uYiJkfPwN5RWl6ea4mcT7Z9fq3XNkV7WRqz/+YZXtN0tMu8OLlpSkGMpsI1egsGLx16
         RdwPtAPca4Rqkta3HZRlPLqkl1z8iusNWtilXhfxnF1WK2mjFsecnxrpC5HFBNfx42Rt
         omDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQmQSS60x65z6dWBIVnjzdQBp74/xdyS/baf8xqTOg8=;
        b=W5ln2AV2bnCoSfP9+ZkzU6R0wWdJDL/R++iNOoOldabWsf56P1drdUaI3nbf0xvZkO
         V/Vnntmgi8tKTfj3jFWUI9nB1+VjTCIVYofC5AdMjTGvCktv+hdPBjJQUqsJX2ml/8d1
         aFasyTH37C+fwID/CLz/x5AjwRxTHYyOs9AdKNxsryt/XCAE7loGTHogyKASMJtAty03
         1dYN/PvlV+6AirLMW6L571M/EsLK9U/2RncRmYQly2WodYP8zn/oN5njnvUktJpHHsB7
         fUfnbGtBGWoKlgsNptpMqLkgJ47WN8llYLaeHTMmKKShfr/ofpn3tQhFVlGUOLJo1JDG
         4QFQ==
X-Gm-Message-State: AOAM531lOau02bF/0sUknyvsI9azjIKkNSa2CKba6Bw+r3jC5EdZhJ6r
        9SWx2ejEJQaXYTfq9k/I7M4H1smx6jsbyw==
X-Google-Smtp-Source: ABdhPJzWS2Oi5G5CdkXBVohcpYMv4dzZY/i/Ecl5ydSp5NeXM4ANqpsCRkulBV93ajqSy980nqu7BA==
X-Received: by 2002:a17:906:8147:: with SMTP id z7mr5930344ejw.436.1616180921711;
        Fri, 19 Mar 2021 12:08:41 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:9d6d:4da8:8a04:dafa])
        by smtp.gmail.com with ESMTPSA id sb4sm4186625ejb.71.2021.03.19.12.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 12:08:41 -0700 (PDT)
Subject: Re: [PATCH net] mptcp: Change mailing list address
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        mptcp@lists.linux.dev
References: <20210319183302.137063-1-mathew.j.martineau@linux.intel.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <0ef86230-bb2b-a35c-3bd9-341d2e7de133@tessares.net>
Date:   Fri, 19 Mar 2021 20:08:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319183302.137063-1-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mat,

On 19/03/2021 19:33, Mat Martineau wrote:
> The mailing list for MPTCP maintenance has moved to the
> kernel.org-supported mptcp@lists.linux.dev address.
> 
> Complete, combined archives for both lists are now hosted at
> https://lore.kernel.org/mptcp
> 
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Thank you for the patch!

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
