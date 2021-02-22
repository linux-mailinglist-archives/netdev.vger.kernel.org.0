Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4610B32102F
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhBVFOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVFOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:14:32 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B7C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:13:52 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id r19so3616715otk.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VVNhv6u95Oxqj4wGXwUXEsmlopWwB0aRgDd2GLtzd0M=;
        b=N4dmFN/PxU6sS1fijpLrnwMHVnN6esr7IB3/m66wlBaoogCz9tFBrQUwqtBxSc63r/
         OtMsH/lt1kca9F0gGgsPN07cPYm6vO8PsFzxvYGojskiWYWwCI3jgwOQh2vmKM5Iq18l
         QaLwLB0vW4Slxt1DhWJv1n4vsElyfzFwl/L3quTWPiROmNM8jQi09oy/C7f8JeHtwrRO
         8n2LDKhgGqNL08c2mN7fkfhXA+/4aQ7XGKctEniCB8Wt6gd4JdvW7itmHj04HZa2xl2c
         GvhPjMbe25Zfa1PaJfGmmH6QPl/ovpF/ZIfR9bPoxUxB4tECrnSzm0qp+UWxemw4nQBB
         ymKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VVNhv6u95Oxqj4wGXwUXEsmlopWwB0aRgDd2GLtzd0M=;
        b=M+8zsU+ngiLGRBqptDGXEAs+l8JwSEHf1Nsa6JrCAclSvjVtkhbMTBxYBSGmbDZJtP
         Fbg36+qgQW2SMvvIHddrXMwkLK7/bGVrEfoaShqBeHPNSIL8GnPk61SGo9eZSym2KkTN
         n/Pc6n9VL0RQtyRmL0vpgt7KBLA7vwTFNmsoAZvUR+4gKGUgtppBcWh29F0KJmocUqdF
         Pd9/ADOFuqqqoj4IS4baTjazBxBuYKifLw5Awm9V9/2Npgn/FD0VAhJl+HfPKGVv63Xm
         YIM0p0LQaM/5SJRCUqiZn+vhUk5f0YiTpL6BE/OHHeEGyFU23lcFhC74PBEsuBECJD9L
         lxpg==
X-Gm-Message-State: AOAM533x1YdmS+aNtluItkYwJeVUeCrkzcLt7wJec3LbkVscSVheOF4y
        yBRG0IcuTC2SDja8SUy0b/k=
X-Google-Smtp-Source: ABdhPJz5KSd8sc8xlTBAtvVTKLi23B3yBLF+FYmFf2l2mob5Qxs1F014D4VVRSTiHDdSbSg/s0k8+w==
X-Received: by 2002:a05:6830:1f3c:: with SMTP id e28mr15743315oth.93.1613970831885;
        Sun, 21 Feb 2021 21:13:51 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id x207sm1129337oia.30.2021.02.21.21.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:13:51 -0800 (PST)
Subject: Re: [RFC PATCH net-next 03/12] Documentation: networking: dsa: remove
 static port count from limitations
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0d58d186-5c9f-3b46-e1e8-c15935a2fd7b@gmail.com>
Date:   Sun, 21 Feb 2021 21:13:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After Vivien's series from 2019 containing commits 27d4d19d7c82 ("net:
> dsa: remove limitation of switch index value") and ab8ccae122a4 ("net:
> dsa: add ports list in the switch fabric"), this is basically no longer
> true.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
