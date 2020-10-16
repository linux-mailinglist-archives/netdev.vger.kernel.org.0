Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDECC28FC71
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393788AbgJPCiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393780AbgJPCiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 22:38:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD18C061755;
        Thu, 15 Oct 2020 19:38:02 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so606968pfb.4;
        Thu, 15 Oct 2020 19:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0TuHxCA8pR0v59g98Y4cASFZIZDcQpxe39FAPO1UrgI=;
        b=L0lVs86czcYYmUK91+ua/qhUFF4egDyhi09/9lg9+Hq/SbxUqweuQbDA7lw+4jEef0
         KpvZYxh+fiCXwjf9X/Uz/aSl8n+ntbfsWZ7i3prjuI8LSUH0oPTvZVZH9UD/R6OKr+Ql
         C0sfpl5PMFxSB7/hqIx3T+ABh0dUyBe6SUmJKqsz9e/XJuXA4u1tvQTLx7AWqncWoTrQ
         LcG41e+Kqxd2jPZU3EC/RmtrKhNj/os3wfONiS9D0pAMzKh+TUmmL/oE1tEXiQDKFyyn
         8EJ+vxNJ9+kG5bxZi80CNuUjyswzJkTSFt0jNKTqsMNbzzIb8SCrfnDYveyd4LVo9nHG
         zcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0TuHxCA8pR0v59g98Y4cASFZIZDcQpxe39FAPO1UrgI=;
        b=FbabARTs55dDc5LDJGOEMQwNK2iMB+JYh8vClL2Idwhr++zWdZq78wfvjQsLb9Ym7x
         g6br65AKNLFJUiQsq+iqTtQuS0SoPgecYmGeRc0FT59clQlFtyry97F1QabS0HLe+NVO
         O4bJj+J16zhVee+jGZhmAzH346RS7z/K6nkDkW7c0wJLrWSyb6H8yNOKOgp4oeLxyuOM
         kzJTlYvVYEO1cqzjL+zCyEy30hbCN2RRTpTkHhHA424j5y/R2jadr5yJmKfKXYtSojNx
         kT4epmOgKQcub8uYd5N3XyQoeIBsUJb+tXitfvcs7alnNQ8CTQZq+BjBnJ/KxDLQLL1s
         xvTA==
X-Gm-Message-State: AOAM5322QZmjVOfoUT5mpmFlf3e4dGKv4+2Sr28CJRBV/Gx73UgoXZvf
        +Vl/gQnOgdbDSMKygnrD/LY=
X-Google-Smtp-Source: ABdhPJx8EIEf4Ouf843MeXYP3lM6J5uJSAxpBrbnYXa6dDpmYEsFGXVMBXZ8Q8/RxoMz7nTkzdiWrQ==
X-Received: by 2002:a63:c053:: with SMTP id z19mr1256223pgi.418.1602815881307;
        Thu, 15 Oct 2020 19:38:01 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i2sm765006pjk.12.2020.10.15.19.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 19:38:00 -0700 (PDT)
To:     Pavana Sharma <pavana.sharma@digi.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Vladimir Oltean <olteanv@gmail.com>
References: <djc@djc.id.au; danc86@gmail.com[PATCH v2] Add support for
 mv88e6393x family of Marvell.>
 <20201016020902.28237-1-pavana.sharma@digi.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3] Add support for mv88e6393x family of Marvell.
Message-ID: <e7658756-ac90-b4c8-40d8-b948024da55e@gmail.com>
Date:   Thu, 15 Oct 2020 19:37:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201016020902.28237-1-pavana.sharma@digi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/2020 7:09 PM, Pavana Sharma wrote:
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

The subject of your patch should be:

net: dsa: mv88e6xxx: Add support for mv88e6393x family

to be consistent with the previous changes done to these files. I don't 
have the datasheet for that switch so cannot confirm if the changes 
appear to be correct or not, Vivien and Andrew might though.
-- 
Florian
