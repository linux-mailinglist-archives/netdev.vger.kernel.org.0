Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8B178F1F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbgCDLB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:01:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32769 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387626AbgCDLB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:01:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id x7so1865544wrr.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 03:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7VAuibKPBhN2uJqWnuUvvNEBoYBZb16P8KUvfES61I=;
        b=1x56J9CUsAYJXSE1sf0DrXveAczocZDDOIrtlPu8Yq23Yue37Rn8VpRwu/DFV2EU7P
         MlW6hcvYfljEnEzgyMHfIsJF6RAjxmuSaicZ6mZK8HmbGAj42CLlgelskZU9jTVkizjm
         jbIg7ks1w7M26dVnRTmxMmXL5NGzLiHKVuF0rJf2ojnn2FmtjAnoKq9QmLTdQiA1SpKU
         8ACNazh9pYuD1uqkAa7afdIdgZxfwHGQ8hVqQWigQytetxH9531TVxlATNxBLUPax9SX
         tFswM5kuhBUVcx206nXOjtUFW0B73HF7bigkqHstsLXJvdr5FI73yEkI5kdESrkjb+F8
         A5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7VAuibKPBhN2uJqWnuUvvNEBoYBZb16P8KUvfES61I=;
        b=kciV8wdZ397SnLnD+svhbNOvny041ygdDoeejrSBQGEh6XKIJ4rbyLCP7epi5SLIj+
         Fz+Ruv8UoGi4OCNdLwE/Xwt1DmQT5fO5nvlpDpk9ftbXKwR4CCH7kShzZl7cROtRR1l3
         PHYwb3gYWl02Zkh6bfe6vPvHqCZLGSEZmbjcc46x4jR0oUNP1aV9X9WCYadbh/xP7nkJ
         gG6oKUtM+k8jTWlVFBmZlK8X5pGXdB77qhnNxsya9qG59J4WuubpHGzDU9jUpbbnOBGI
         e5rTAN3aLjEcmwd01ZvxPcoxNc48D9Tos+sjpxFJe10Awvkz3upicTcmFy9wAL31Owjy
         wNKg==
X-Gm-Message-State: ANhLgQ0KhBAKZRhdavDsm3hgQuB+5XUd2IGWl59JU+58JzrngWzE+W+u
        Fv8ztlFN4/HqhSuBZdHvpv33fQ==
X-Google-Smtp-Source: ADFU+vvIubRuJGB2bM/u1dS8qc6ALu9xpFLmKcfFsNhquPiOHFkfvLZRluWbV5Yn1JwyGwz+byG5hQ==
X-Received: by 2002:a5d:4384:: with SMTP id i4mr3543182wrq.396.1583319686173;
        Wed, 04 Mar 2020 03:01:26 -0800 (PST)
Received: from [192.168.1.10] ([194.35.118.106])
        by smtp.gmail.com with ESMTPSA id w16sm4723354wrp.8.2020.03.04.03.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 03:01:25 -0800 (PST)
Subject: Re: [PATCH v3 bpf-next 2/3] bpftool: Documentation for bpftool prog
 profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200303195555.1309028-1-songliubraving@fb.com>
 <20200303195555.1309028-3-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <8580cc30-e5d6-861a-b9e5-1542faac1d31@isovalent.com>
Date:   Wed, 4 Mar 2020 11:01:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303195555.1309028-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-03 11:55 UTC-0800 ~ Song Liu <songliubraving@fb.com>
> Add documentation for the new bpftool prog profile command.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks for the changes!
