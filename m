Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC46264FD4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIJTwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgIJTwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:52:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ED0C061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:52:06 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d9so5326897pfd.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rHPR8L4fwOWvnH3k7K2SXIfnt2etT+dtL9rtS7MBv4Q=;
        b=fqpqzw1EDtaemfoCLaD8YOGfLE4BASOqqWTV32x5oo4mq+FsjxOjAfGE9+IAr+9AQJ
         +kvZBF9qKvFvEpjienYvf1/cQOlLiBWTiVcXtlJA7eN4DDROAFpiiKurE0UnHSX9A3yY
         hogRl34gBZlro7ZNIwM4wESffIDuwKbf67GQ1TOuVPbAxR19dMcfXFmASEsbsMvvjKGn
         H3423Ik5oOV+94WLN2qbRAUFYFiweN2rMOJyjwjha/UuLCwb0PJbod6RouSEM11lKeNa
         07idHVkFvCcyoE8Xve6JhIU5QK5zGW8iBOIxS5pxlPLtLQjwM5gQWb+xL5mu8Gf+MOuW
         srEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rHPR8L4fwOWvnH3k7K2SXIfnt2etT+dtL9rtS7MBv4Q=;
        b=BZ58ncwbb7WBlkcifqSBOURN3zeiDm721E+S2SDmJ1ngKo53e/2n/WYlGjDH9KbNa/
         ZcaVKniOOx+BYWycUsSUWSkKFl/DlcftsK4rSop0EQm86FIiEtGK2DbDD+JfeCDdcnqd
         eY5HSI6W9b02wSMWX7U9YN1hOvIULCw772bmBYVwMVkxopR3XIp/tJIifkgEAb8WUUbu
         28pQxUCPi/R/6cg7iVZu7Nv4tMrEJSKIglUaCdafP2Yu9dmKxKIeNlG2k7YGvFWeIznU
         tqsL8wfm1xyEIveb3qqFm9GJqkkkk6u1EWEoPA9yMcSvDu3RIqWVusW2yFa9xFeimRaQ
         aipw==
X-Gm-Message-State: AOAM531VG5CARG/CiQ0x37ZMM7J6D4GIRcxMPi6jG8kr7L2RXFEEwfZo
        e+l7EAtlWEcleB/gcaNPHa0VBleQNeY=
X-Google-Smtp-Source: ABdhPJzuGrlFYn5vXQNT6gI4x0HBzWqGLQQjSarUbH9Utfw1chr0xGcMHmnXwnKVg2deuZDKgDXfYw==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr5982808pga.305.1599767525960;
        Thu, 10 Sep 2020 12:52:05 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r144sm7225787pfc.63.2020.09.10.12.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:52:05 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/4] Revert "net: dsa: Add more convenient
 functions for installing port VLANs"
To:     Vladimir Oltean <olteanv@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200910164857.1221202-1-olteanv@gmail.com>
 <20200910164857.1221202-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <179dfb0e-60d5-5f49-7361-32cd57edd670@gmail.com>
Date:   Thu, 10 Sep 2020 12:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910164857.1221202-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:48 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit 314f76d7a68bab0516aa52877944e6aacfa0fc3f.
> 
> Citing that commit message, the call graph was:
> 
>      dsa_slave_vlan_rx_add_vid   dsa_port_setup_8021q_tagging
>                  |                        |
>                  |                        |
>                  |          +-------------+
>                  |          |
>                  v          v
>                 dsa_port_vid_add      dsa_slave_port_obj_add
>                        |                         |
>                        +-------+         +-------+
>                                |         |
>                                v         v
>                             dsa_port_vlan_add
> 
> Now that tag_8021q has its own ops structure, it no longer relies on
> dsa_port_vid_add, and therefore on the dsa_switch_ops to install its
> VLANs.
> 
> So dsa_port_vid_add now only has one single caller. So we can simplify
> the call graph to what it was before, aka:
> 
>          dsa_slave_vlan_rx_add_vid     dsa_slave_port_obj_add
>                        |                         |
>                        +-------+         +-------+
>                                |         |
>                                v         v
>                             dsa_port_vlan_add
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I would be keen on keeping this function just because it encapsulates 
the details of creating the switchdev object and it may be useful to add 
additional functionality later on (like the DSA master RX VLAN 
filtering?), but would not object to its removal if others disagree.
-- 
Florian
