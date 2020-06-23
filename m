Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF3205241
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgFWMRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732613AbgFWMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:17:52 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C82FC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 05:17:52 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id i3so5642311qtq.13
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 05:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rnJX8R4/u0bul7jK+J0G603qpNM/gE9eTBblQOsKzWY=;
        b=I1Gjq66+zBAiX58YdWGXeVVqtkndN9vNMW3N/NugBnOkOFotrNHfQAvhHSSgF8aNr4
         uvRJ+7V4SPcgZd6i+fY+Sr4rLWpA/TPwYf7zzUAmJHaGuZOhBsbjU2MkY8t9AhvzGTJ3
         V2DJwWjYWL814+jeqAAqkG9HqBIAg4NXguiVswxQprtG6pdV4DubpiXaAYuEyTFgZ+vw
         lm2OPmXw8dwvZ0BVwZ/75brpcb4NhczvJyaPbxwFR/ro2wt7mX7AmEW3nShYi3giToiH
         Y7TXQ2uBDq9+rWkZyNeSzvG+iOUQswSnehzycdXUKJ2k9ltq6qQVhYKAK6DHDDMJIz6h
         akSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnJX8R4/u0bul7jK+J0G603qpNM/gE9eTBblQOsKzWY=;
        b=AnYSNa3KvOhwWurPy2WI2gxDTA/mZCx3ycwVGYxSvPiMxxOURgFrSrVRer51FD4Ywr
         LvtCa6GoQ+aa7KKuJ7nl+x7frvCtgrN0mSapuWRExAZ3jdup+kj4LKhVJQ+DOsb4U7cp
         OGHhlb4CMnzvUrSuVcF7FPcl3gBS+Rrfaoix0LyZZKGPzTAN2NZahWtFMZ9HB2I13jVq
         h24K+2758E+XWV5J8mRO6w2M6W+m37xT2rw9YFi6m9vlm2rERkKDDTOyzuntRTa7NfSM
         sZz6aimlK190bYgEgWd71OSt3HtXjHj4LKOuYL7B+LviPsq6f4UleXMLLziMZtmjdsKp
         npAw==
X-Gm-Message-State: AOAM531LK8aNjL+arHZt9K+993fI1pyLu8bBjSVXZACvu33+4mitKNZR
        1FbjNLOiAqBieAHeoefQDktzig==
X-Google-Smtp-Source: ABdhPJw/o04cwm75ceLorlpG3HUxbpqG1Y1BDalbZRqu2xwFfhg/LL70R/ci3xqMynyzdv/RM08grw==
X-Received: by 2002:ac8:3129:: with SMTP id g38mr13445444qtb.92.1592914671416;
        Tue, 23 Jun 2020 05:17:51 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id l3sm398979qtn.69.2020.06.23.05.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 05:17:50 -0700 (PDT)
Subject: Re: [v1,net-next 3/4] net: qos: police action add index for tc flower
 offloading
To:     Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
References: <VE1PR04MB64965F4F28439370BC53539A92940@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a8afb955-b3c3-eabb-7f48-319220e85240@mojatatu.com>
Date:   Tue, 23 Jun 2020 08:17:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB64965F4F28439370BC53539A92940@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-23 7:55 a.m., Po Liu wrote:


[..]
>> My question: Is this any different from how stats are structured?
> 
> I don't know I fully catch the question. Are you trying to get how many frames for each filter chain passing one index policing action?
> If one index police action bind to multiple tc filter(they should have differnt chain index ). All those filter should get same index police action stats value since they are sharing the same hardware entry. But I don't think this is the problem.
>

This is a good thing. What is nice is i can use the same index for
s/w and h/w (and no need for a translation/remapping).

> With index provide to device driver(map the s/w action index to a h/w table index ), user could list the police actions list by command:
> # tc actions show action police
> Shows the police action table by index.

This is also nice.

My question: Why cant you apply the same semantics for the counters?
Does your hardware have an indexed counter/stats table? If yes
then you should be able to do similar thing for counters
as you do for policer (i.e use an index and share counters across
actions). So when i say:
tc action drop index 5
and
tc action ok index 5
infact they use the same counter.


cheers,
jamal

