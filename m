Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159702E79A1
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 14:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgL3NWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 08:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgL3NWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 08:22:19 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB01EC06179E
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 05:21:38 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id b64so13794472qkc.12
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 05:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DiKW6kn9xhWzj8pGVjJbHM5laaOWiHgnfOrQhi/+dEw=;
        b=yPbNWNIujU98p8FqUMNJqpEC5Ikdh7AOH0Rug7KF4R/bQHyWPIZvXytjtYCSbnMQS1
         L2nNfd2Ft3VLmCf1sIsGVckwbfV+DQdMc9AT1qOtETAtDndsz5Lq7f5A/w/aYA0eDRai
         qdHlS0/htIDRjxyL0V17Jh6yHEZ742Kv0uByj/vBIGBu9H0Bm/z/VRpn8xb3Ujek0F5T
         R+sviMzyvYanOHV5gTo/C4EVvSHgWfw8WD4yxnOq8+jUp2IyUnQXB+gnxhZezibC3goY
         zvyufQ1+qPkMbdJnuNlNmTS0ZViS5O67Du6tjdzhwSXP2dA8C9aCRKYhZGqZkUrCLRwX
         CwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DiKW6kn9xhWzj8pGVjJbHM5laaOWiHgnfOrQhi/+dEw=;
        b=BsJG+Ub7JKJvd/xg/6f+I9rIrOMzyVaFbqSBM9Vf9ffSBhtYm0kJ0hRZBeMhZB98a7
         E9RIEKkzKh4guT5RtKAmqzaEFzkAqMH/3N4NCaIxeKWWY59Cjd2VBHPs5snaeYxfRGCI
         RSslTjxO2SCu81o66OVqgwInjGor/qGuZYIztKI0GQ7DZPK6ZPua20MsVl9zinT4BhhD
         kkSYzgqlYh3JW5dmjisj2U+MI0BL7bFvHAtt317I1uCfXJoJFf/gPEO+V0fwA96wUtoU
         8W6mrQprvaqZ1tS+6NLbUeYEZX71BcwJ13VjlcIQvhJJU9DhghmZNrlHEf4P8WzIvKak
         vqSQ==
X-Gm-Message-State: AOAM532L2zHkEkHKz+d1MxCf4D4Hmf4LjR/ADsFlreNuciFpXnbRMpid
        PA8ZXjy2MJlc8NxHTWrmMB3OpQ==
X-Google-Smtp-Source: ABdhPJyI4saX0gdxJdnD4Bf3YFY/cQY8QsgzyJ7q0uukmiS6+O3U3JS55RVZqQebkxjPEwMhuZlJOQ==
X-Received: by 2002:a37:6846:: with SMTP id d67mr23625271qkc.219.1609334497299;
        Wed, 30 Dec 2020 05:21:37 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id c8sm27308643qkc.12.2020.12.30.05.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 05:21:36 -0800 (PST)
Subject: Announcing Netdev 0x15
References: <193eea01.AUkAABw1d3IAAAAAAAAAAAKSBpUAAYCsBU0AAAAAAAwWzABf6RC7@mailjet.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, lartc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Forwarded-Message-Id: <193eea01.AUkAABw1d3IAAAAAAAAAAAKSBpUAAYCsBU0AAAAAAAwWzABf6RC7@mailjet.com>
Message-ID: <2e1f6717-715c-c63c-ba60-676c986f9876@mojatatu.com>
Date:   Wed, 30 Dec 2020 08:21:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <193eea01.AUkAABw1d3IAAAAAAAAAAAKSBpUAAYCsBU0AAAAAAAwWzABf6RC7@mailjet.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


While we bid goodbye to 2020, here's some good hopeful news for 2021.

cheers,
jamal


-------- Forwarded Message --------
Subject: [NetDev-People] Announcing Netdev 0x15
Date: Sun, 27 Dec 2020 15:54:31 -0700
From: Tom Herbert via people <people@netdevconf.info>
Reply-To: Tom Herbert <tom@herbertland.com>
To: people@netdevconf.info

Hello Netdev'ers,

On behalf of Netdev Society, I am very pleased to announce the Netdev
0x15 conference! The tentative dates are July 20-23, 2021 and the
location will be San Francisco, California, USA.

Our current plan is to hold an in person conference assuming that the
conditions around Covid-19 have improved, however if conditions
warrant we do have the option of holding a virtual conference again.
We will try to make a definitive announcement about this at least six
weeks before the conference date. Additionally, it seems likely that
even if we do hold the conference in person there will be a hybrid
component to accommodate remote participants that wish to opt out of
attending in person.

The call for papers and workshops will be made early next year, so stay 
tuned!

Thanks,
Tom
_______________________________________________
people mailing list
people@netdevconf.org
https://lists.netdevconf.info/cgi-bin/mailman/listinfo/people
