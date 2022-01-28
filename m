Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757B549FF93
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbiA1Rao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242181AbiA1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 12:30:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7FC06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 09:30:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k17so6726533plk.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 09:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=awz6EipQU2fZgJnMEMkn6YHHN5Z72TRdxUQ+fR1WCOc=;
        b=kDH10+UNxLtYGfmDetEjNCMBwURilYLgsdpadRJQiIavHFn5HmSBHoe/f1AlgCK77h
         7I/q1dd7GnDF0F73nldpZcJDpJ6APnfUVsIcAyaCl5qgbDPUybxzea2ZzmXuloyilcXO
         jJ63Yb94DFpqRjB9wnugi+UcFW0byGKnK4V6o519FKvxfbXTF2YKl72g5ZvB1fJvIomP
         6/kfgC5ozVjoWE8qSwQq6hxoAZyMQrzjsNuWPZkbk8a5KmUjPfrnPyMfYg5CuWlUadd2
         nlK59t5komggvR/FNYWf2BTIfHfodPe1Dy4FkCPEQLsjJ35al1k8LtvfTK94c7WtSEei
         QPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=awz6EipQU2fZgJnMEMkn6YHHN5Z72TRdxUQ+fR1WCOc=;
        b=b9atr0JuTp3BOgZ0cgODL5TQBQluK3Cs9t/yBnoZOQFWQOtK83b+qXDmdaUszuHSUV
         t92evBORt4vEyKEf6AlccXZU5sd/S4U2x983hYsNhnbppLq3IL2bx4LoSlKvuLgPOcL5
         g0Ne6qmcItzZCC1fQdec5s+n95xCFxmPeyM5Rlw/DAF7kg6bKU2tso6NDhahd4QJzyAx
         3ggP5IJ4F0YPTvhueeHL3UEPcpnVNgnbLYPmOy7IERE82lcGkZ/TFQ8E7c9FcsEX3uPp
         7PUMfHJqywkEcc3Kejs7QKyersx1uLxmLIsJ07cLdeKvuaiesMuLv5pyfJLarTUDMxNV
         jK/A==
X-Gm-Message-State: AOAM531WFFRzeVI7Z+9LUbH+pmYfHpT96/7TPkC0oD3hxaHHp7nMoRZM
        ePVX6lLF+N3rBGTIzlz3abg=
X-Google-Smtp-Source: ABdhPJz0BGvkb9+ZhKkk68XFS5DxJzl5Dhe5CIfIadXH9du5Ak7z8bYvn2NbyjOPW5xlrHD/CQBFiA==
X-Received: by 2002:a17:90a:eac5:: with SMTP id ev5mr20861934pjb.147.1643391037034;
        Fri, 28 Jan 2022 09:30:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c6sm10306788pfl.200.2022.01.28.09.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 09:30:36 -0800 (PST)
Message-ID: <b6d47735-c638-3121-f66c-f08b4350f329@gmail.com>
Date:   Fri, 28 Jan 2022 09:30:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org
References: <20220128170544.4131-1-arinc.unal@arinc9.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220128170544.4131-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/2022 9:05 AM, Arınç ÜNAL wrote:
> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
> properly control MT7530 and MT7531 switch PHYs.
> 
> A noticeable change is that the behaviour of switchport interfaces going
> up-down-up-down is no longer there.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
