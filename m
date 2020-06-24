Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6D2073A4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390889AbgFXMol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFXMoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 08:44:39 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DB7C0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 05:44:38 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id u17so1534175qtq.1
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 05:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K+GGZXKgpzdCsUctXsT0qtaMFmUhAglO46kKwDBE35k=;
        b=ADAC9Nm+AjdV8L4TTS7PIGLMY15VNal3PX2tkETlMZKLDRFTA5Zq7fyeasnJFbp8aQ
         u35RXtvdaqiOl2B34/rDKVfk/KU5yGbvLGjLj5uBbsgbgxlieYKMYe61G7Aa3nJSqNsJ
         aSS1D/M+o9/ClQ8ZDo9o+Cm+Ywc+anYTuJfGUyz91nsTQAtPlOnm+eEintzNQG/V67me
         duDxwZV4JBFW67bkT02/tyvtt63LcTnGQu03PsWedd0d7bGH4vD2mrADYMwcQpgn8Tw9
         CBSjxkARtflMFT8a0pxLNB3Ihb+pE571AonOVTeiVD9S+18zwm1RX5bPUeYKjJEuo3Om
         USUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K+GGZXKgpzdCsUctXsT0qtaMFmUhAglO46kKwDBE35k=;
        b=YymvmALbzjOTYfn+aE468fELvDRn0rG5ogS+nfX9Mg/7oGHwkaGkgcKKcufCWWM2Fa
         oy/3Q/yF/wVw60egdXdlLZJ7novJd/krr8nXIT77ktPKWE6MXye04AJn7p9uHiilrlua
         5Gp26d8tTt2fd1FAyaP0KoYThO4mJfnbSpIPMlx+pgZe60bIJMIjN/+Wq2wdiDsIz5MX
         W1rNT7F3GMSTnmCdkHoVmsScN2CR93H+mxyI/OjfzWX2LuDqc0j7kbvR0TfW/bOpgI2g
         xRwi3FWx1WJgdoTcHYUhsRBFedWXRXoVICbsxNkxXyUpUDhN9T9npsIjZZCW1UyopwqM
         TwUA==
X-Gm-Message-State: AOAM533fmIbU6CLwvw2xHLKEeCpbM4kNqvKLNWCCoVGXibNpRzXtEFXW
        hZbcUqVh3j9t7dCzpK3m/NTBtw==
X-Google-Smtp-Source: ABdhPJyQIqA1QaiDwKbaPsVfBf/aqoPaaAgynomS8v8sVwttSlNATi+gb0yJ2j0k/hkgTxeCYTLIeQ==
X-Received: by 2002:ac8:794c:: with SMTP id r12mr26584071qtt.201.1593002677309;
        Wed, 24 Jun 2020 05:44:37 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id f65sm1914390qtd.61.2020.06.24.05.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 05:44:36 -0700 (PDT)
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
References: <VE1PR04MB6496AD2BE9868D72A475935492940@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <18e0ceb0-7cc7-12cc-624d-286cfbd70b94@mojatatu.com>
Date:   Wed, 24 Jun 2020 08:44:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB6496AD2BE9868D72A475935492940@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-23 7:52 p.m., Po Liu wrote:
> Hi Jamal,
> 
> 

>>>> My question: Is this any different from how stats are structured?
>>>

[..]
>> My question: Why cant you apply the same semantics for the counters?
>> Does your hardware have an indexed counter/stats table? If yes then you
> 
> Yes, 

That is the point i was trying to get to. Basically:
You have a counter table which is referenced by "index"
You also have a meter/policer table which is referenced by "index".

For policers, they maintain their own stats. So when i say:
tc ... flower ... action police ... index 5
The index referred to is in the policer table

But for other actions, example when i say:
tc ... flower ... action drop index 10
The index is in the counter/stats table.
It is not exactly "10" in hardware, the driver magically hides
it from the user - so it could be hw counter index 1234

The old approach is to assume the classifier (flower in this
case) has a counter. The reason for this assumption is older
hardware was designed to deal with a single action per match.
So a counter to the filter is also the counter to the
(single) action. I get the feeling your hardware fits in that
space.

Modern use cases have evolved from the ACL single match and action
approach. Maintaining the old thought/architecture breaks in two
use cases:
1) when you have multiple actions per policy filter. You need
counter-per-action for various reasons
2) Sharing of counters across filters and action. This can
be achieve

tc supports the above and is sufficient to cover the old use
cases.
I am just worried, architecturally, we are restricting ourselves
to the old scheme.

Another reason this is important is for the sake of analytics.
A user space app can poll just for the stats table in hardware
(or the cached version in the kernel) and reduce the amount of
data crossing to user space..

cheers,
jamal





