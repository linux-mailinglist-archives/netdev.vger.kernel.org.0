Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DECEADB1E
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 16:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfIIOYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 10:24:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43145 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfIIOYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 10:24:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so6590090pld.10
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 07:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lbfN6bb/Cab8FhmK5hvUyGyJpQngTjGaLYzqkqMwwaw=;
        b=EQ4hPfczVhylUYRlafgNbmIAVyWADkVHZnQxtGRIDwglF0ej4vEUlQs4ZeqXnwPEVT
         2ItoFqyzus9e3C0nBj3hom99xV4k3T0CnheuBynGqH5sQvEQ34XAQhBwBybwtiIy3DG+
         HFo0UykNjE7Ogp1fggKxfUNxUCAKcjjkDu/pIKDyQPDwrQnl584WWKljk91zf9jF9t5J
         UxmGqAlEc3+ie2cousgkn5X6twTsNaKVgxb19X0CRygS41KNfbTazoD6PnAzvMvCjZsx
         LwVP7Jkc348TE/OgZywMPCJfjkGWRz7YH79hq1nFdZgYockykF0oLyiXdECXQXnwNcbi
         Cjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lbfN6bb/Cab8FhmK5hvUyGyJpQngTjGaLYzqkqMwwaw=;
        b=QpM4XE2jrOE/+DyD/SIQVNhIUTlwo+Q5xi3QMupPvaFgYCwq/CYsIXzUcy7fujNWlc
         9WE1XuSnUNv8vUIPv3fTTGGcGqnvWKk5/EN4Zlka14wcNGtghti7Yb7E+4SkhmDSNvVb
         lm4kqKE+f9WvbNWvHjRYYDIgFbSGIoD8AVPht49d7vALDRov0zo9wj8lbljJxjlBsDXf
         uZRk0T0guiL18pG+NuAF4I1xlKCzf66NTVuURBeoyxyIuoWWoGJVH3Ml80YNQx2t1GVa
         36pfoV68NXSv/lVWew5udajHKOPRKsykEJjsQsS2B8ct0DhKlZWEDWop1LkfUyg1dXHF
         rAAQ==
X-Gm-Message-State: APjAAAXhhrSpIlW5L78JGfdFweW8xBi6Oq42RcontZdamKcicaQumgdq
        cpCSZAlWAoWdiYnkucxuCv84NA==
X-Google-Smtp-Source: APXvYqyjDridxJhQUEYdPB5+tEjPSrzcb2ywbeHXAAUKunZY07oQ/lp8Rm8oyeLdMgC3OJ/Z3wtddQ==
X-Received: by 2002:a17:902:a615:: with SMTP id u21mr23375821plq.4.1568039071132;
        Mon, 09 Sep 2019 07:24:31 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id z21sm16010682pfn.183.2019.09.09.07.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 07:24:30 -0700 (PDT)
Subject: Re: [PATCH v2] net: enable wireless core features with
 LEGACY_WEXT_ALLCONFIG
To:     Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
References: <20190906192403.195620-1-salyzyn@android.com>
 <20190906233045.GB9478@kroah.com>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com>
Date:   Mon, 9 Sep 2019 07:24:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906233045.GB9478@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 4:30 PM, Greg KH wrote:
> On Fri, Sep 06, 2019 at 12:24:00PM -0700, Mark Salyzyn wrote:
>> In embedded environments the requirements are to be able to pick and
>> chose which features one requires built into the kernel.  If an
>> embedded environment wants to supports loading modules that have been
>> kbuilt out of tree, there is a need to enable hidden configurations
>> for legacy wireless core features to provide the API surface for
>> them to load.
>>
>> Introduce CONFIG_LEGACY_WEXT_ALLCONFIG to select all legacy wireless
>> extension core features by activating in turn all the associated
>> hidden configuration options, without having to specifically select
>> any wireless module(s).
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>> Cc: kernel-team@android.com
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org # 4.19
>> ---
>> v2: change name and documentation to CONFIG_LEGACY_WEXT_ALLCONFIG
>> ---
>>   net/wireless/Kconfig | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
>> index 67f8360dfcee..0d646cf28de5 100644
>> --- a/net/wireless/Kconfig
>> +++ b/net/wireless/Kconfig
>> @@ -17,6 +17,20 @@ config WEXT_SPY
>>   config WEXT_PRIV
>>   	bool
>>   
>> +config LEGACY_WEXT_ALLCONFIG
>> +	bool "allconfig for legacy wireless extensions"
>> +	select WIRELESS_EXT
>> +	select WEXT_CORE
>> +	select WEXT_PROC
>> +	select WEXT_SPY
>> +	select WEXT_PRIV
>> +	help
>> +	  Config option used to enable all the legacy wireless extensions to
>> +	  the core functionality used by add-in modules.
>> +
>> +	  If you are not building a kernel to be used for a variety of
>> +	  out-of-kernel built wireless modules, say N here.
>> +
>>   config CFG80211
>>   	tristate "cfg80211 - wireless configuration API"
>>   	depends on RFKILL || !RFKILL
>> -- 
>> 2.23.0.187.g17f5b7556c-goog
>>
> How is this patch applicable to stable kernels???

A) worth a shot ;-}

B) there is a shortcoming in _all_ kernel versions with respect to 
hidden configurations options like this, hoping to set one precedent in 
how to handle them if acceptable to the community.

C) [AGENDA ALERT] Android _will_ be back-porting this to android-4.19 
kernel anyway, would help maintenance if via stable. <holding hat in hand>

D) Not an ABI or interface break, does not introduce instability, but 
rather keeps downstream kernels of any distributions from having to hack 
in their own alternate means of dealing with this problem leading to 
further fragmentation.

E) Timely discussion item for LPC?

Sincerely -- Mark Salyzyn

