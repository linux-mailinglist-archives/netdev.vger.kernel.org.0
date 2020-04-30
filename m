Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A67D1C03A7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgD3RMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgD3RMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:12:40 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E348C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:12:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w6so2095027ilg.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuPRD/LyHJsGk1Xp4qc1ApJFqyKBP30De09F6ApYN+s=;
        b=iUXH3vT9mN1OnpBOi7UQ8uZ/JSjFWhettuBetCaAfC2s+oHCQYU6agUvFnNoksrIxn
         UuJXmDPdeKDCcP1OblEIMXaHV3vpmUVVpp42tP7pzfWR/8QbmI3y4I8+EobjlynAeY6e
         xIYjNtCKY7uXuurw1JDzvFwOuJNb7+aElu6dybI2lzqhp3cp9NG4SurmsdcG/5biDNzd
         mFxGKtpEhDVUnPW0HvII6qQdn/XueryJY4LG0JD+rsZKq7Efa527g761iRJ8dWn4+M7l
         aZ06aezXYBn68q7ZI9KtJjSK58l6rix5oqX7OeNzFfWIOXo7AzPVl8VAYMu7+NCEo11V
         BmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuPRD/LyHJsGk1Xp4qc1ApJFqyKBP30De09F6ApYN+s=;
        b=PecVzSaSFgD8sM6TiVSX+KS3D7dg8Xgb/bPvvPN93EyK0fKt8xWjmFf55rtD01OS4w
         5/Y8XTMDujsuRXftirIIzT+lQA1779CA3wqklrqHdSr+K5vOWFaJA6YsA7m4xTrJc57n
         v9kp/MSPpNc4/AlQXIvhu3dhb41LA6TzBbo0vwr6WNB6UvNuAa2t2NKxUpivHH7vY1Zz
         iRVEziszoO+6CqkKKfIv7RdloHOPn9qRAek7gHdVNK8wgmccTvY1+LSWzJy7VirCTf9a
         KtEmvmkqggaapixOVXLjcv3/zOFa4grtDeUtn6uzbIOaNzESkThOB7PbAS7YaQV3sCbD
         pCrA==
X-Gm-Message-State: AGi0PuZl2b472q62rS/6agxbD8w6hMAVjTjqsol+Sl+WaNJthbBN8R6t
        S+OfRCxVuo9jfH3UZ+JbSS8=
X-Google-Smtp-Source: APiQypLmpzC8vqdOfAZPVahCJIxYaVqAvlRNyaRQSjQNaMHmh3s6jOpRuxg5ArtfsdXe2WAj/akMAQ==
X-Received: by 2002:a92:390f:: with SMTP id g15mr3117516ila.72.1588266757672;
        Thu, 30 Apr 2020 10:12:37 -0700 (PDT)
Received: from [10.67.49.116] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j2sm49909ioo.8.2020.04.30.10.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 10:12:36 -0700 (PDT)
Subject: Re: Net: [DSA]: dsa-loop kernel panic
To:     Allen <allen.pais@oracle.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
Date:   Thu, 30 Apr 2020 10:12:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 11:24 PM, Allen wrote:
> Hi,
> 
>   We ran into a kernel panic with dsa-loop.
> Here are the details:
> 
> VM: aarch64 kvm running 5.7.0-rc3+
> 
> $ modprobe dsa-loop
> [   25.968427] dsa-loop fixed-0:1f: DSA mockup driver: 0x1f
> [   25.978156] libphy: dsa slave smi: probed
> [   25.979230] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on
> port 0
> [   25.980974] dsa-loop fixed-0:1f lan1 (uninitialized): PHY
> [dsa-0.0:00] driver [Generic PHY] (irq=POLL)
> [   25.983855] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on
> port 1
> [   25.985523] dsa-loop fixed-0:1f lan2 (uninitialized): PHY
> [dsa-0.0:01] driver [Generic PHY] (irq=POLL)
> [   25.988127] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on
> port 2
> [   25.989775] dsa-loop fixed-0:1f lan3 (uninitialized): PHY
> [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
> [   25.992651] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on
> port 3
> [   25.994472] dsa-loop fixed-0:1f lan4 (uninitialized): PHY
> [dsa-0.0:03] driver [Generic PHY] (irq=POLL)
> [   25.997015] DSA: tree 0 setup
> [root@localhost ~]# [   26.002672] dsa-loop fixed-0:1f lan1: configuring
> for phy/gmii link mode
> [   26.008264] dsa-loop fixed-0:1f lan1: Link is Up - 100Mbps/Full -
> flow control off
> [   26.010098] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
> [   26.014539] dsa-loop fixed-0:1f lan3: configuring for phy/gmii link mode
> [   26.021323] dsa-loop fixed-0:1f lan2: configuring for phy/gmii link mode
> [   26.023274] dsa-loop fixed-0:1f lan3: Link is Up - 100Mbps/Full -
> flow control off
> [   26.028358] dsa-loop fixed-0:1f lan4: configuring for phy/gmii link mode
> [   26.036157] dsa-loop fixed-0:1f lan2: Link is Up - 100Mbps/Full -
> flow control off
> [   26.037875] dsa-loop fixed-0:1f lan4: Link is Up - 100Mbps/Full -
> flow control off
> [   26.039858] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
> [   26.041527] IPv6: ADDRCONF(NETDEV_CHANGE): lan2: link becomes ready
> [   26.043219] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready

you have missed an important detail here which is the master device that
was used for DSA. The current code defaults to whatever "eth0" is, what
does this map to for your configuration?
-- 
Florian
