Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61A617BE7C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCFNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:30:18 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37483 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgCFNaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:30:17 -0500
Received: by mail-il1-f194.google.com with SMTP id a6so2038617ilc.4
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pg0E53f1mAa6g/1NYUXksaRgV81W69zTft5+Yoc7gDE=;
        b=Kg8VgctwJ9sl2bTG3rzATydWCYvJWQCE+ermdWX2W6/tL1d4ooTTXJuxucMeR5HrSO
         1VngudrsPSy6SvXBIf+Y/JC/ayTGHJ6fpURzkse7qM0P31kiOutuJ53gCTgm/4fdXO2/
         ZK+7UJ0oJ/wyIe0y/TWHPMUsTI7K+WDqulCZDNtCBHys0966gt2n/kZXpPgrDhE1Gfvo
         87Sp3W/lmVrl6Us1lh/ZORqWtpxOgMOSPZkKnPn6LSXxHmrLaIOR6aGQRitSaxpWzlV7
         H9ejUcou5Kg7KhqSbUzlR6JhKfG+b3GJnyRWoC6D1Z6JI/nPhmrbV+jmjMERQGj372X0
         Pt8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pg0E53f1mAa6g/1NYUXksaRgV81W69zTft5+Yoc7gDE=;
        b=d2tAeyNdjXq/qgpAthihZ9eRR6VM4WP9gpYFxpPKzzaQLqeNTXUZuC2eSer/M6ozD1
         WXrM8yGbx/daM8XUaIA874qfE73Xi8teizwnQdJHVUq27lhRuw6Qj9ecNqs0b8MZVdLo
         cDyQAzPAlccDoRhJNLet6b9cg+71WR4H89UId69pK7sbSjZckEYWgf+PWLbh0eNXfC4C
         U06rySb/crLS9DdP32v2o9BkkAPsIumvQQtmjfq7H0qBshvEahG9feuD93pW5YSxoEWv
         Ezcu1ro3m1jaXDhZpiNNXPEo9wpzuhVitLOfBZ22nQPNpCvRJqMKQsPSOEb0CLXypPcL
         CPIQ==
X-Gm-Message-State: ANhLgQ1jQnuNqcpTg5cSaeQK0kNI/xh4b8YnCw4v0PYkNcfr9JL8VRyX
        YR53FA0Z5y9IBCnTEeyq4jvM+Q==
X-Google-Smtp-Source: ADFU+vtF7Sgabzn4gBNF+Q1WL6hlfCT9H3OiBs3TKH16d/VuIJCgyEsSlOKmaSfuT4a7s2taCKtlBw==
X-Received: by 2002:a92:d9c4:: with SMTP id n4mr3077709ilq.124.1583501415806;
        Fri, 06 Mar 2020 05:30:15 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id x6sm7019573ilg.42.2020.03.06.05.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 05:30:15 -0800 (PST)
Subject: Re: [PATCH v2 01/17] remoteproc: add IPA notification to q6v5 driver
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200306042831.17827-1-elder@linaro.org>
 <20200306042831.17827-2-elder@linaro.org> <20200306114941.GO184088@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <5548579d-179d-b099-afa9-6b76e9fa5a89@linaro.org>
Date:   Fri, 6 Mar 2020 07:29:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306114941.GO184088@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 5:49 AM, Leon Romanovsky wrote:
> On Thu, Mar 05, 2020 at 10:28:15PM -0600, Alex Elder wrote:
>> Set up a subdev in the q6v5 modem remoteproc driver that generates
>> event notifications for the IPA driver to use for initialization and
>> recovery following a modem shutdown or crash.

. . .

>> diff --git a/include/linux/remoteproc/qcom_q6v5_ipa_notify.h b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
>> new file mode 100644
>> index 000000000000..0820edc0ab7d
>> --- /dev/null
>> +++ b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
>> @@ -0,0 +1,82 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/* Copyright (C) 2019 Linaro Ltd. */
>> +
>> +#ifndef __QCOM_Q6V5_IPA_NOTIFY_H__
>> +#define __QCOM_Q6V5_IPA_NOTIFY_H__
>> +
>> +#if IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY)
> 
> Why don't you put this guard in the places where such include is called?
> Or the best variant is to ensure that this include is compiled in only
> in CONFIG_QCOM_Q6V5_IPA_NOTIFY flows.

I did it this way so the no-op definitions resided in the same header
file if the config option is not enabled.  And the no-ops were there
so the calling code didn't have to use #ifdef.

I have no objection to what you suggest.  I did a quick scan for other
examples like this for guidance and found lots of examples of doing it
the way I did.

So I'm happy to change it, but would like an additional request to do
so before I do that work.

Thanks.

					-Alex

> That is more common way to guard internal header files.
> 
> Thanks
> 

