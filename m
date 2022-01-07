Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F594487AC2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbiAGQyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbiAGQyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:54:50 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AC6C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 08:54:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y70so7860417iof.2
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 08:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aq9C4GYXtfs98XU3/sRQhbhIzym7FYtiMRik5o2WkoE=;
        b=RMr7n0VDqIm/fdZrYitLkINVrU1OiHw00CW3SbDl4urtUqINpifx7B9NRdWIoKt4dl
         euxxZxtyQsAqz+D9OQgyDeGiil/3RpBj9fXnvk/SOP+v9ubI+8UTmZkZDMemP6kIFkOw
         GeJfqtTCbtc7dcdZ6MDYRXfZjW6vd1xoRt+6AOKfDJdAwjZkF2dTFDZQhVuphP06eA4P
         zym1Fl6X1uhbeQiWmrRsfet2rUlyqpuHRBMrkEH8bGun59cw9oea1+zKLRR2y5TfbE4m
         brxOSZ8mss4jGndhUNbkPFAayhFYEOW30FZjye4x4NqdHQDFWhZgwQFjvtdCDeVbNEHK
         K2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aq9C4GYXtfs98XU3/sRQhbhIzym7FYtiMRik5o2WkoE=;
        b=hgC3DY2D5QTGg7nvQ6YGzLgdPf49mQ+bpnif+mhGW2cXbVsT2mUezyZFHIbLUZh6Zs
         dVyS99d3+DHmatsu23nhLBTvbqAagtzAUkhdie0OhuQFJpNT/rh6EW/w4PwwR/iyFg9A
         hTRYPGt9osyDrcShjRC9B88PHrF+UBb4hYSEv1aXaSP2/9Z2v9UUwEwfmivlaRMgaj64
         fgoeTzj5Hl2xkerRRlo2wkryIxRMFZF2+Io9HWvo+YUCFe/B20bJUOTmCsF9CMKW47oX
         jhk0aDLYVBlxrrplV+Z2YiTc5QH7SWIOvo8aDwKMw2ZnSlVPgLh7eFRsrEZT5/ZXDhOl
         xsYg==
X-Gm-Message-State: AOAM533iON3teFzGJwwT8eJbOP6p0DJi/1jVtAUiyah1wR447FcgUhl+
        LsiP8kcHKZ6fgKBHgsn+8dk=
X-Google-Smtp-Source: ABdhPJxVwPnwLSF5ecNOBtS6HsgPGqOXpiM0mFI2+5VS/XgdRhvGEwMsP4O1PUniGJ3Qkjka8aVKoA==
X-Received: by 2002:a05:6638:22c7:: with SMTP id j7mr27074016jat.264.1641574490110;
        Fri, 07 Jan 2022 08:54:50 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d0a1:ff00:8a1b:3712? ([2601:282:800:dc80:d0a1:ff00:8a1b:3712])
        by smtp.googlemail.com with ESMTPSA id l9sm120433ilh.55.2022.01.07.08.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 08:54:49 -0800 (PST)
Message-ID: <7c6ae652-acbd-3d9c-aa6d-ed338dd04fd7@gmail.com>
Date:   Fri, 7 Jan 2022 09:54:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, aclaudi@redhat.com
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220106143013.63e5a910@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/22 3:30 PM, Stephen Hemminger wrote:
>>  	if (tb[TCA_U32_LINK]) {
>>  		SPRINT_BUF(b1);
>> -		fprintf(f, "link %s ",
>> -			sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),
>> +		print_string(PRINT_ANY, "link", "link %s ", sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),
>>  					  b1));
> 
> Break that long line up. Would look better with a temporary variable.

+1 and that comment applies to all lines in both patches.
