Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0342666BA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIKRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgIKRb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:31:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6A6C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:31:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k15so7876665pfc.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jqwV3m1IM1HIr2J64SKNvmshCNyp+LRMpLkoAkVLxxk=;
        b=u3xw6xiaa+e5XxgoYx9pLToSaBUmOK41oynbe/4NB3jwDO2grNMS+2/4zgUp5U+xWw
         H3Q8LjmqFspZzDekUtpAZJS2DqToNhezP2kmWpqSYKyAxwpT6WIaFQXA2Y67GYaLXiQs
         hqP5cW0EKQMXcAjFSXduHFLJv33M2ND5xZb7cVn6wItbDsqcPdpQdiwgKvg+ziEpD8lZ
         A1ij0ruIQjZDgRZTqPPtFis4fqTKE+4gZC9Ige07g+ykXSm7fgVOGFCPs/FB8ziT9gsF
         a8tR1blTEYbMj+oP5Ew16ImbqfysnUY9vxR8CZjY7PKA0cTDLt4/r4eNcmpOiZGNy15X
         n45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqwV3m1IM1HIr2J64SKNvmshCNyp+LRMpLkoAkVLxxk=;
        b=i0HzCdMKh45KpMWjPxe+H9Wft8lYMoWXt3O/YUOXP45xfkZxYR4lTwz/BEnB6aLAg5
         0eqtMRjwtEdEeEIDQpkFlL+Y4J7oOkkdBjLxl3z3L3/lLTPDs+ZWRTU5y2Bt9+x1QoLb
         rJZTY9AtuT+SuDrWLOszdKb37ss2EgQEuUaCSYJPfLzHwe8sDUO7bCfJuF2rrvkrOnpQ
         Iz9/YPAMJAhn6NW+GE9rcgSQogocpsEjUgF4dQidH5i28QVQ70SCwlH2xclFC2FtkAlK
         rJK9Fk2EiYaambykp7/2fuPEcxdXs9leKJT6jKmIWAzCGu0ZIb09VZ/rX6ov+nUFHwMH
         taIw==
X-Gm-Message-State: AOAM530VyHQPVSfDx6eJVdwx1oS7xvwyUi1H9R8WLpMageetY3W5vktK
        MsrCH3e/MjAhfUd7LKOByH4QHjWFXmE=
X-Google-Smtp-Source: ABdhPJzDDJeO3Rj8W+PBTs1dlchTqRbxpaTvuEZNBwA5TB/XreHI36y0LJrVE1wiTT7RqlNcjcxgFQ==
X-Received: by 2002:a63:6503:: with SMTP id z3mr2434369pgb.421.1599845486681;
        Fri, 11 Sep 2020 10:31:26 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm2362547pjb.48.2020.09.11.10.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:31:26 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/4] Revert "net: dsa: Add more convenient
 functions for installing port VLANs"
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200910164857.1221202-1-olteanv@gmail.com>
 <20200910164857.1221202-5-olteanv@gmail.com>
 <179dfb0e-60d5-5f49-7361-32cd57edd670@gmail.com>
 <20200911173026.rsjiqquhrue2viio@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0df2db4d-a7c2-2ce7-6f37-1061a40eb6f6@gmail.com>
Date:   Fri, 11 Sep 2020 10:31:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911173026.rsjiqquhrue2viio@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 10:30 AM, Vladimir Oltean wrote:
> On Thu, Sep 10, 2020 at 12:52:03PM -0700, Florian Fainelli wrote:
>> On 9/10/2020 9:48 AM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> This reverts commit 314f76d7a68bab0516aa52877944e6aacfa0fc3f.
>>>
>>> Citing that commit message, the call graph was:
>>>
>>>       dsa_slave_vlan_rx_add_vid   dsa_port_setup_8021q_tagging
>>>                   |                        |
>>>                   |                        |
>>>                   |          +-------------+
>>>                   |          |
>>>                   v          v
>>>                  dsa_port_vid_add      dsa_slave_port_obj_add
>>>                         |                         |
>>>                         +-------+         +-------+
>>>                                 |         |
>>>                                 v         v
>>>                              dsa_port_vlan_add
>>>
>>> Now that tag_8021q has its own ops structure, it no longer relies on
>>> dsa_port_vid_add, and therefore on the dsa_switch_ops to install its
>>> VLANs.
>>>
>>> So dsa_port_vid_add now only has one single caller. So we can simplify
>>> the call graph to what it was before, aka:
>>>
>>>           dsa_slave_vlan_rx_add_vid     dsa_slave_port_obj_add
>>>                         |                         |
>>>                         +-------+         +-------+
>>>                                 |         |
>>>                                 v         v
>>>                              dsa_port_vlan_add
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> I would be keen on keeping this function just because it encapsulates the
>> details of creating the switchdev object and it may be useful to add
>> additional functionality later on (like the DSA master RX VLAN filtering?),
>> but would not object to its removal if others disagree.
>> --
>> Florian
> 
> Hmm, I don't think there's a lot of value in having it, it's confusing
> to have such a layered call stack, and it shouldn't be an exported
> symbol any longer in any case.
> Also, I already have a patch that calls vlan_vid_add(master) and having
> this dsa_port_vid_add() helper doesn't save much at all.

OK, I am convinced:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
