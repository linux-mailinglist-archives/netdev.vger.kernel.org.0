Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E78321031
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhBVFPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhBVFPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:15:12 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED627C06178A
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:14:31 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id j1so846032oiw.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=if7us0iXNAHgcRHj++6Ki3wtcEIVCF6JJOGxRCaa9aA=;
        b=qXkP4UrB6TAh87yHscIj+jKfxtlWwDxepTTZr7j6nai8onHRec6ULgei675gZVVjBy
         Hz+Yt7wdurqx8klMqq5xuqjHNAUjJgYsrlM65DhgLpff5aP0gQIeJFfI6tjYNGe6hErj
         45ELQb/e5ExD48hrdlBgdw3naEeWlBAtQsdVzXzgxabg8U70W7Ym3NAdYSNsXh8KVPXx
         nQIv//5JMNk9Ku2leK7lE1aI367Y/yT/pugyXS7h1ZVB5stq+WaOLGoHFYgmpTgL/LEq
         XaFSUkphkYspZW4JcOKbiZ4YjWCXPalDDVwiZIus9NCcnEhgoYmW+Qv9x3dvGeSeQdFC
         t46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=if7us0iXNAHgcRHj++6Ki3wtcEIVCF6JJOGxRCaa9aA=;
        b=Eg9p2WVgKrzpUT5AO4hfsv/o4ufdx8jgw/57HIZDQ+aiigEs5pKrq0JIXuPqQ5iX2v
         cU6DOdzjsbuYL47tLAJyrc0XJavwwMChcMfWJ4Mz1eh28gj0libatSG3wq8s3Vs3WzFe
         h4DgvM9WjM8/oIRU1kHr9QmZKdoEqATm70ntUw1bZ6PHFfslHzG/Bb1stgM+GC7RGXRC
         uRa6TiZNFX8dMAgh7LLHhazXE84htcJlmudU3Q2p2eBCQtKVrgUMsHSFEmnsrIy9Sa4P
         7fJsuBV/gx2sDUKTnmIU1TxJw2d70pOXVEOjlkp0M6ztnsEOC6HQOV0UyWOTZiYs5vrX
         TScA==
X-Gm-Message-State: AOAM533f8uhKiBmFKKFt/cV6/vwYNsmo9inhkXxxFe6AwhwDvmGg/7o6
        fCRNmaBqDzRnUnpz2E2ukss=
X-Google-Smtp-Source: ABdhPJzXVOQzUn8c+0hGjWWLpuruczmRcG650VwjeM5CwQIsD6laoZC+xiB/EVgV8EnkCWfn5diD1Q==
X-Received: by 2002:aca:b286:: with SMTP id b128mr15022011oif.126.1613970871419;
        Sun, 21 Feb 2021 21:14:31 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id j100sm3455536otj.66.2021.02.21.21.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:14:30 -0800 (PST)
Subject: Re: [RFC PATCH net-next 05/12] Documentation: networking: dsa: remove
 TODO about porting more vendor drivers
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
 <20210221213355.1241450-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <69c5ab4e-1947-d68b-bb99-fb035402d7a5@gmail.com>
Date:   Sun, 21 Feb 2021 21:14:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On one hand, the link is dead and therefore useless.
> 
> On the other hand, there are always more drivers to port, but at this
> stage, DSA does not need to affirm itself as the driver model to use for
> Ethernet-connected switches (since we already have 15 tagging protocols
> supported and probably more switch families from various vendors), so
> there is nothing actionable to do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
