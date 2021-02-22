Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975D1321032
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhBVFQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBVFQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:16:01 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFFBC061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:15:20 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id k13so388015otn.13
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6sRxixSTtldN6wV7WY4hOg11Ti1sKuM7G+LDdST3poU=;
        b=hZAutIvSkM61WmLOU+tz7dFam0bfrbO6PYybfmc6JW1EEaoGKPv01GWPSM552nDiiC
         2FgQWSe3Eam3Zf31CvJvJuDLFdD85suGhfWphbAd+cS6QasD9RgKqlhVcLeTfvKRqDQt
         DxKvUgOPbo4qO7c0UqPeqaF+cVt5SmIblFv+YvVLBLOs6B+PRIPtq20/nTRS5eH4BZ1e
         CELfj9DhhuFejYC+pj009HH7p+o9Xv4Q78VFViRquaF2TOxzmKXnn1l3Gn6chCHOPUvu
         EbRiaCFtVIxRrKFFSSTg/h9b6msMinQHYZCmz9G1ktYuCAl2I3dthJNJ08lN0bN01a1V
         Rg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6sRxixSTtldN6wV7WY4hOg11Ti1sKuM7G+LDdST3poU=;
        b=XX4zO1LimPudpJg5GHO3pv7/mx/6qCtNf7ZBEJfCpMeEpqbOeBl/eVi0SWBLTF9I4r
         Cr1ZWeKZ1soExVvDzR6aSbHDk735C3Dn2z3UoL1fel+exjRIVhtc6mzjuWZjcOreSfux
         NSChWkJbMH8hrxlIvuTppTvJRVKuU+ivZvrp7bE4/s0KbbI3EX66IFe+BkzOORCaC88K
         CXZXNQF2Jk8q+gjjE76rFPVw9Zdx9TR+7kIQmLfy9DWh/dGCRgiAT8159ae7CHCxXfn2
         U7veGwexFcR2OKWAMWAbPtDF6G5jIeL+auFcheXPEuSOdmiImzFNE0dfIk/dnouF0+8d
         nvfw==
X-Gm-Message-State: AOAM531ij7BH1c3DmYclKBnPL0AuuqbUbq1VFRZeCpsFF5+B+/bYxaLi
        gE+tptcxaxYYPZKXiVeF0aQ=
X-Google-Smtp-Source: ABdhPJzZpQqBybqFXaPMIOWP8MyX58yyHzMMgr/VvTs5LS2FBJu+tFZGZ9b082qV3bbY24WUYgABpA==
X-Received: by 2002:a05:6830:113:: with SMTP id i19mr15649005otp.219.1613970920464;
        Sun, 21 Feb 2021 21:15:20 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id s3sm3573885oic.19.2021.02.21.21.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:15:19 -0800 (PST)
Subject: Re: [RFC PATCH net-next 06/12] Documentation: networking: dsa:
 document the port_bridge_flags method
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
 <20210221213355.1241450-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08a8168a-d756-b08f-5fce-be601836271b@gmail.com>
Date:   Sun, 21 Feb 2021 21:15:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The documentation was already lagging behind by not mentioning the old
> version of port_bridge_flags (port_set_egress_floods). So now we are
> skipping one step and just explaining how a DSA driver should configure
> address learning and flooding settings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
