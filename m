Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEAA1AF263
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgDRQgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgDRQgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:36:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FAAC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:36:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j1so1215355wrt.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QXZjjGdj94Q6jmXyjC2XhVfmUAWdFFKOnsdjNyV+kbU=;
        b=QxGT81HTVbaP+kPmC1fmIKGXBPG3vCBOFXve9mj4+VW7Qm2Rq4GGHxNTLFHvbY3eJm
         F5saC5d2wf8GkNfRwzQHpl2AY7H2cdTdfhPSMjt4P695mrSjxDc5CUrkDojUO6SMOhsk
         i2oRhwuVn6hk4nev605TIzrQHL1FmZM4aTwSu3p/FrwYRXSMGxQ0OzdQhhSc/Wlu6PEK
         YyTB8vvhFFwyc/QfMnVT+UZE4Q5G6a4KTLJ787+uQbOYU/fPy/x3UKOSYFq5mRJQXX4t
         rqCiT6j7L+bns67h9xL4XTLsvW0yZARdcOY5VI98X0lblwPJvA8/l9U3FxqdYzisq2cq
         pTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QXZjjGdj94Q6jmXyjC2XhVfmUAWdFFKOnsdjNyV+kbU=;
        b=PJis16bs1SfI0UrG4ptT8VzSatY5qlUIRC50CEi2eNQXXuZ/imFvQxHDpMnymb/mrr
         GHyw845rbsXRBtwXQ62XkhkPioBk4y4Lw16hSFazxAhB78cHVtZlghIM58Ml8+JTT3LK
         i5dtshMgyaz/dwe+yyajk2AzHSTfMlCG+jLJyeEbFc1+oJ3VIlKsvRiFMGAU5Sw5Q9+/
         xMG1fi8AECgMvAMfzxSn5q7T5rf74P5IT8LOZSiRd+jPR4TyIhBbvPMKAy3clcujpCOP
         WH1CduVYuB+M8UgFvykvBUDtjh2VWNxbD6N72ZYjVgJhEOOIwAqKV135nDgVX5OWkIa6
         SogA==
X-Gm-Message-State: AGi0PubUQQ0Jv8M212XZjdofYf8+ayKqFYPnYlcK+h1Z8+3LfoGfarOo
        i6ZhlyCqf1TzHqNHMf4fBBaGo1+cCGM=
X-Google-Smtp-Source: APiQypLA9TWANXHwiN/DNbMVet+Soxo1orScpqJ/wFWzbcz/V8sPYK1hL3vbuW+fWd1WFi1u3fFvNg==
X-Received: by 2002:a5d:4306:: with SMTP id h6mr9252972wrq.234.1587227795368;
        Sat, 18 Apr 2020 09:36:35 -0700 (PDT)
Received: from [192.168.0.129] ([86.125.28.12])
        by smtp.gmail.com with ESMTPSA id h188sm13155514wme.8.2020.04.18.09.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 09:36:34 -0700 (PDT)
Subject: Re: [PATCH net-next] enetc: permit configuration of rx-vlan-filter
 with ethtool
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
References: <20200417190755.1394-1-olteanv@gmail.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <e1f30b6c-6ac5-c234-400d-8ee92190e9e9@gmail.com>
Date:   Sat, 18 Apr 2020 19:36:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417190755.1394-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.04.2020 22:07, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Each ENETC station interface (SI) has a VLAN filter list and a port
> flag (PSIPVMR) by which it can be put in "VLAN promiscuous" mode, which
> enables the reception of VLAN-tagged traffic even if it is not in the
> VLAN filtering list.
> 
> Currently the handling of this setting works like this: the port starts
> off as VLAN promiscuous, then it switches to enabling VLAN filtering as
> soon as the first VLAN is installed in its filter via
> .ndo_vlan_rx_add_vid. In practice that does not work out very well,
> because more often than not, the first VLAN to be installed is out of
> the control of the user: the 8021q module, if loaded, adds its rule for
> 802.1p (VID 0) traffic upon bringing the interface up.
> 
> What the user is currently seeing in ethtool is this:
> ethtool -k eno2
> rx-vlan-filter: on [fixed]
> 
> which doesn't match the intention of the code, but the practical reality
> of having the 8021q module install its VID which has the side-effect of
> turning on VLAN filtering in this driver. All in all, a slightly
> confusing experience.
> 
> So instead of letting this driver switch the VLAN filtering state by
> itself, just wire it up with the rx-vlan-filter feature from ethtool,
> and let it be user-configurable just through that knob, except for one
> case, see below.
> 
> In promiscuous mode, it is more intuitive that all traffic is received,
> including VLAN tagged traffic. It appears that it is necessary to set
> the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
> also temporarily enabled. On exit from promiscuous mode, the setting
> made by ethtool is restored.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

This patch is a good candidate for the net tree.

Thanks,
Claudiu
