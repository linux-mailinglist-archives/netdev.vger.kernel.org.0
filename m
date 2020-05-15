Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262DA1D5532
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgEOPxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbgEOPxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:53:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7BAC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:53:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f6so1142673pgm.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=72G75aIp4Goaada7AdaZdKJE2+pqmHcCOD5pX+/0kWk=;
        b=gazK00S5kZeylVhj3khumqjLjuQWBDjeQvNZz2KhSWubHudxb8I5lhIPlL5N+q++9S
         l8lG7JF28kICpSQKsJAI5IyButpEuEvqmZLh/L9V0rYlmSGMfHI0Jd6xS6SkgrFlfm+T
         7u9qjeQDgD/C7FLpRNVwlNpIMqKJl5pYq3aMkG8Ov0qlMHtj8XsobzPFVUMz04JRzclq
         +9FlOckeDaAPAwo+ZL7dAewWYMCifTTvih5BSluWSj2ge96cq1mEJFDCJhd6g4Ufqxb3
         R1tlBZbR9kK7bmmYyV8K6rzD2y3uSnxoP3cZAWclKROiGhyOaHVCuDIxZA4wGKvRpx0+
         Q/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=72G75aIp4Goaada7AdaZdKJE2+pqmHcCOD5pX+/0kWk=;
        b=Gw/D0QvbRXhk4CkBmgFvhFXRsUr8ed+OytmDMWK2bIOPYALhyPZjZ1PlOGrbNRtPaF
         nD+20IjhuBtOubVpfHdDop21v4/HAh1S120HK3nAQY8eJT/ye+8R4HOltl2UhLmNtVzf
         H8pL3zLUk4FATSbh94vmEJ/bC9BLwgrOajEC5PNWK92xHz2YAF3nLNxfe1ESlDeSxfYk
         ZX2eAXRJFnnlBKvVFQ9KGVkaIogFQgJUP1e3+USWDtpft9jY9lCSWgMV29Wsvq1kVKWw
         /JKotm7PHewCw+/zscND9iF4QdW6Bs24A4qbTSAxcKGcVPtn0ymEBfVC/YwlQ97MDDnY
         x4cg==
X-Gm-Message-State: AOAM533gXls+m/yrrTvUeMxDUtWEnld90WpztnapgEPV29nA1CibZphd
        L8jDRrN3GSN094t26+iAOtQ=
X-Google-Smtp-Source: ABdhPJwCwiIqVfjuqi1st1PqRPjUah2ozGeGLKwpeNc/Tp82B997GEE+gTteQWMTwioY9wCZQOlOjw==
X-Received: by 2002:a63:554c:: with SMTP id f12mr3819927pgm.163.1589558020438;
        Fri, 15 May 2020 08:53:40 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v64sm2271247pfb.20.2020.05.15.08.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 08:53:39 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: broadcom: add support for BCM54811 PHY
To:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20200515052219.GA15435@ns.kevlo.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b2f12255-83a6-9de2-c82f-ebdc6b0352f2@gmail.com>
Date:   Fri, 15 May 2020 08:53:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515052219.GA15435@ns.kevlo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/2020 10:22 PM, Kevin Lo wrote:
> The BCM54811 PHY shares many similarities with the already supported BCM54810
> PHY but additionally requires some semi-unique configuration.

This looks mostly fine, just a couple of nits:

- the patch should be submitted against net-next, since it is a new
feature/addition and not a bug fix

- you need an additional entry to support the automatic loading of the
PHY driver, that means adding an entry to the  broadcom_tbl array.

With that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
