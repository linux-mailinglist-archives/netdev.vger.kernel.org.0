Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B3B25A19B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgIAWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgIAWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:42:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61872C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:42:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k15so1679107pfc.12
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 15:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nSn7k/CPrQCE94+YhNAF5xMJxHeWruYbMGGaqBwaUYA=;
        b=IrHF5I4Y3EhVbEEk7dn+W9uq54nH7LkgdEoGAc1O6y5/lp5uATsEwIXc9kvwAcTCyc
         ijO6LbnwoYhOHw8HR0f9I52xWzSWwA7t/yDWo42yCzRGGQCnBQssreiFW4sIJOMxG5cw
         geb6UbqZO32zl47/LjYb0UtoT+D4CHC6ZpdoAifPEvYwDEPEp492xZ9U1yjtNLyT/QQC
         m8VUoP213ebbhKPL+KKEF8aliG1vFSP9wuMuyHkMc4NmHcVL/7+2AQuso19mhhyL5n0P
         Ry6gFLK2FO3taMpCRCDIGuz2VEzYojS2lxMV72qcylQbnnwkG3Zt1RtIC92hkboChcw3
         oweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nSn7k/CPrQCE94+YhNAF5xMJxHeWruYbMGGaqBwaUYA=;
        b=EHlRCNCkuWsdb5h8R2o+qTqktuKlhDLb+YVFnZ9ain3lZCKbmwPpzlaxYl8yOX8LiU
         wouEebQPurC2p+Zc5o1j21dRkksQntaX1B3umK9Z3nLo+xvwe0zLSIbu+rn9zIIMjN6F
         DyUUNKab6SgSfzo9i6qvidYyEjrdPlf3C0x0WzrIPDTmoQh6YlAuLRAqyPxCr2MJabE8
         cX0aV1kPNczsiuDQbCotQBbYj5xse9fzSvw6TfZz+GOPgO+QFWGydl/XUySYRyfFBaun
         2vROhoyAy7CV1opAVzIj7M2TWN3vUPoDPu+4Syr4prOhOQuEZs6+WsGY1Zr8pr1XtV3O
         4iQw==
X-Gm-Message-State: AOAM530GJWIkhBkE/DU2QJ2zuZ67L8/MzvQkyKXXUXZ7fUnk+cG7toPC
        yxR1yUnheWfgKazkotGCSKjENuU2xoM=
X-Google-Smtp-Source: ABdhPJy3NuKoQG8ZuMJyNYSg0+cjhGva55bstQ8wiznNKLJjqt0pgBo74dsLbwibfhxwBemE0T41rQ==
X-Received: by 2002:a65:64d9:: with SMTP id t25mr3524961pgv.70.1599000162708;
        Tue, 01 Sep 2020 15:42:42 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z26sm3124076pfa.55.2020.09.01.15.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:42:41 -0700 (PDT)
Subject: Re: [net-next PATCH 0/2 v2] RTL8366 stabilization
To:     David Miller <davem@davemloft.net>, linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200901190854.15528-1-linus.walleij@linaro.org>
 <20200901.153959.1284935680059177248.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b3f4f867-3395-a861-936a-43463812ce06@gmail.com>
Date:   Tue, 1 Sep 2020 15:42:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901.153959.1284935680059177248.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 3:39 PM, David Miller wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Tue,  1 Sep 2020 21:08:52 +0200
> 
>> This stabilizes the RTL8366 driver by checking validity
>> of the passed VLANs and refactoring the member config
>> (MC) code so we do not require strict call order and
>> de-duplicate some code.
>>
>> Changes from v1: incorporate review comments on patch
>> 2.
> 
> Series applied, thank you.

There was a v3 submitted about 30 minutes ago, is that the one you applied?
-- 
Florian
