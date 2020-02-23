Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574441697BF
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 14:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgBWNZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 08:25:00 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:35298 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgBWNZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 08:25:00 -0500
Received: by mail-lj1-f177.google.com with SMTP id q8so7057831ljb.2
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 05:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kd+cJgeFqcMOy4ak2OVFmkgg/wkZeLcdrbvrkc+sT4M=;
        b=lBeCcYZfnQakTyxOz4gY7LAUSI1XV1OPsXh6JUcCWsgM/zBy/zf0wuKE+HPbMXGuQI
         C958sr2K7aWkySCvVrxYOu4BJfdIrGWAM4Tr0CXX2ujEwjcDqPj1GdjJihB4izH4lODy
         yR+4Cjijx+Y5HaTk2K96zRiD2JzpKu0ZDg07OvuZBDin6XjYiXXL8ZWAUakSK70x7nI/
         TnpKnswq8LsYQy9Hg2O/MqyjMcQaVqBD5RN4nRX9iiTJOZyl8tgu3MQ7m5t9R/gZYI1j
         m4btLy1HYXRtoKln1Ku3eEvfJtdrdaSBK8tXLqot3C34Mg/B47QMaKx/WACFwgvCVG+X
         ZNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kd+cJgeFqcMOy4ak2OVFmkgg/wkZeLcdrbvrkc+sT4M=;
        b=MM1jfhE9UcdA3taIernt1E/Yixno4z8n9rK6naQv/1stVjSY2aygqmiTLjZ12MPfQt
         0UT1trvMtDWxiJv/lhaRnzXu2Gn7ECrPhUU5hV1puoIqy2npAdFBxhKYeGxRHY9256Ao
         4JIHwirSMnXtUNgg8bQmvfwEisEY8lGuWpWrVKRjHOOuXt0BBdH2lhXSVW6RWDqI8sAB
         Z3MrSWhqjuSmKU5DeuuE1ML8ebcFewSEEk0xAxhqulqPCtEvqr0pN8v4q5E1U+Ql3/u3
         sW0CjAx0F3/odImyUAUxdkMSpsnn7XlWCJO/bC9e3EGj5DxkmpPnZEbeLE3gi4Ra8IqK
         Mxgg==
X-Gm-Message-State: APjAAAWZoiEDYKJh39q6abDQo+YFlXrKhDO0a3GULGzKdhiPG/GcMX3D
        UQPbXwnNHqh3TMatNHj6GMCTeLaU
X-Google-Smtp-Source: APXvYqz3EHfI7sXBf7Wgm6WWfvdbnzxzp9RESDZyE+qK9LH0oTzrvQXbpMlu8vyJj7U9LqPQqxbGHw==
X-Received: by 2002:a2e:a553:: with SMTP id e19mr27417762ljn.64.1582464296796;
        Sun, 23 Feb 2020 05:24:56 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id c27sm4413839lfh.62.2020.02.23.05.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 05:24:56 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
 <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
 <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
 <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
 <11c9c70f-5192-9f02-c622-f6e03db7dfb2@gmail.com>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <49a18ff2-a156-f2af-fa70-ca9657382a73@gmail.com>
Date:   Sun, 23 Feb 2020 15:24:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <11c9c70f-5192-9f02-c622-f6e03db7dfb2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-21 23:01, Heiner Kallweit rašė:
> OK, thanks anyway for testing. I forwarded your testing results with Realtek's r8168 driver to Realtek,
> let's see whether they can identify the root cause of the problem.

Just a sec.. did I had to apply that single-line patch AND use Realtek's driver (r8168-dkms package in Debian)? I assumed not..?
