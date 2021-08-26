Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F196E3F8696
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhHZLiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241887AbhHZLiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:38:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3DDC061757;
        Thu, 26 Aug 2021 04:37:22 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x12so4491362wrr.11;
        Thu, 26 Aug 2021 04:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PVy3x/gpaGlyIL2qP4pHOSUUYbRwv09MHpiWHWZWURQ=;
        b=PLjSL3fyyywCH92vqbI2tusTBrwiymMrmM/Wws2eEV6jYdx9o1SlJPyKZkzLple30O
         WOh7BIMBIb2LhE8coiVeCYE/ybKLAAiROPgq0YYCiQ5YUal/sKNUJNhMQs3WxgbRCEky
         1fYQZ1ArsEURbzYuWdTgTEMLWoP1zWxRITjXDTpQBW/RL0uzMUB4npwBWRRiZV+3ezh2
         hZI6u+5Wbftg/iok+6WHTh8v92YmDYWai3D20jSVrEgRTP9ibJ21mFy3fKaA55fpZ6Vs
         Iw5nZwYWUyZfq3iJePLLBd+TXMoBRYo3/IpfqMt0y1tppd4TN9XwNxkBYybeWBrsbxT+
         OFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PVy3x/gpaGlyIL2qP4pHOSUUYbRwv09MHpiWHWZWURQ=;
        b=QbO+9ZqVm8Cl0z1T5c4ddEYJIEhTm1cNZfnfzi8r5RAxBLALvDlDp62M2QY9kfNj1O
         ReGT5Z0ehuSGGXqYfZuRWQ0N7kbzWko3GMBr2D6doQjhKytx2LHCZnXYMfEYtKqxc24X
         QL7wfut1m8Q2AX9cFTMuugix0dMSqTLB6V87PK+M3X5L6eI5XG+f3Wq1ptk+ltGoyifm
         USu2B7vu49QqYaiS5n5fnJJMF0YytvHMd8E6T1XoOWMNBTdTq/ELOJu1SoyrqQp87ZEJ
         r2YdnOJjovBRAoh/tfxlCooZ6yAHly5addpYlWSyLHFJSv0RmAM/jQMNgvqVCO6U7UaK
         tzlw==
X-Gm-Message-State: AOAM533DedUHXrTjdiot0bzZEPXnhLDJrgpZqo8ziP/WfgWcG/6gKgHP
        W81/ut8/ojxGyPkFbT9flRA=
X-Google-Smtp-Source: ABdhPJyiPAPPK/QKKtI37MIt74tUHsI2gmeuEdCkJGlWux9B5TiRR6goXs66qq1aoMfSta4Xj3Knyg==
X-Received: by 2002:adf:eacb:: with SMTP id o11mr3441381wrn.418.1629977840667;
        Thu, 26 Aug 2021 04:37:20 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8192:e700:d55b:a197:684c:2cfe? (2a01cb058192e700d55ba197684c2cfe.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:d55b:a197:684c:2cfe])
        by smtp.gmail.com with UTF8SMTPSA id l12sm2429237wms.24.2021.08.26.04.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 04:37:20 -0700 (PDT)
Message-ID: <109fb944-e310-4cdd-82e8-367217bfd2f2@gmail.com>
Date:   Thu, 26 Aug 2021 13:37:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion
 on TX
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210825083832.2425886-1-dqfext@gmail.com>
 <20210825083832.2425886-3-dqfext@gmail.com>
 <20210826000349.q3s5gjuworxtbcna@skbuf>
 <20210826052956.3101243-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210826052956.3101243-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/2021 7:29 AM, DENG Qingfang wrote:
> On Thu, Aug 26, 2021 at 03:03:49AM +0300, Vladimir Oltean wrote:
>>
>> You cannot just remove the old code. Only things like 8021q uppers will
>> send packets with the VLAN in the hwaccel area.
>>
>> If you have an application that puts the VLAN in the actual AF_PACKET
>> payload, like:
>>
>> https://github.com/vladimiroltean/tsn-scripts/blob/master/isochron/send.c
>>
>> then you need to handle the VLAN being in the skb payload.
> 
> I've actually tested this (only apply patch 2 without .features) and it
> still worked.

OK and this works because now you always push a MTK_HDR_LEN tag which 
you were not doing before for VLAN-tagged frames, right?

You don't seem to be clearing mtk_tag[2] and mtk_tag[3] anymore, is that 
intended?

> 
> The comment says the VLAN tag need to be combined with the special tag in
> order to perform VLAN table lookup, so we can set its destination port
> vector to all zeroes and the switch will forward it like a data frame
> (TX forward offload), but as we allow multiple bridges which are either
> VLAN-unaware or VLAN-aware with the same VID, there is no way to determine
> the destination bridge unless we maintain some VLAN translation mapping.

There is no "bridge" on the other side from the CPU port's perspective 
on egress, only physical ports, so how does that comment apply?
-- 
Florian
