Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4612EDCC14
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502920AbfJRQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:58:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54897 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502282AbfJRQ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:58:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so6905282wmp.4
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c8eiMxDXShCN/rpNARZ2/Ubg4M2Yb/IT/06Bb2juQm8=;
        b=sdAiDTdIuA9IBwy9NkoRzFpPnge5h8EMUb3V5uWNPmQNrer2xf6kJKnp/mXVS53ge4
         fc4iXXJvIBvwqrWLLbOaSQ8asT23bDLT+H2x/E94I5CGpujF2zCGuK1G1MVfxsM68vYE
         NKAhRwVK47PjeDH0wPvTBzwqLIr1+uDQUW0Mj7VXg7g1Uf5MJqq2ipt8g92YClZLowS4
         vBhqwFMfkmDUgFVHvST5V0SD8sY6R3eMEYPpll0orJdD9mPckG2ByeyNiAgHX6OU3GUO
         ZiimLYeq+Zv2tPWlg9ypnfUKfpnmbntOfzZMbzaX6WveDJ85vsJcdTMfvpyxGErKcRIr
         y1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c8eiMxDXShCN/rpNARZ2/Ubg4M2Yb/IT/06Bb2juQm8=;
        b=WTwaKVMfp8OFu8EBLJjjmrZAleunB6UpuO4urfCiKX/voRFVV/BX+nzwHlP6iMASP/
         7knbAGraNOjzqe6kb1YieIkPQI9Uou9OY+I0HdDsthYqMEyo3alIEjguUJ7sIWS6s5g/
         LCEgct+wgT+GMSfcJrg51NaaMaVTWQKFJEh5QwMYWpvgO4alB0vcTutR9iwyv+wfnTrL
         WRxYlM3gN1CqPHYZLc0N6ITnIcWQs45dyCBC1M5XxNJ4PVxNqlh47CLVp7YcycVnvfr6
         IcTZSdYz+8LWArsm5IYwXxsqFdwSfzYtzfdL9+sg2x8IKSwVLMWmNIlTBLDOqfMNXJiY
         M21g==
X-Gm-Message-State: APjAAAWrwU40u03Cc4Lp7kKUj4GwDmb3bH0kbPhXfdgQDsl4IT4QtC0M
        5fsPm22fcWp7TobMi/WOuPtBmw==
X-Google-Smtp-Source: APXvYqzBhmmcoeoJcEnYlWWkCHQ/FMzIZ9uhIhvuMZKSpbmz42R80xnybt7CECwmEXalhsKz16zxvA==
X-Received: by 2002:a1c:e48a:: with SMTP id b132mr8776522wmh.13.1571417904705;
        Fri, 18 Oct 2019 09:58:24 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id l6sm6964516wmg.2.2019.10.18.09.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:58:24 -0700 (PDT)
Date:   Fri, 18 Oct 2019 18:58:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018165823.GF2185@nanopsycho>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018093509.112af620@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018093509.112af620@hermes.lan>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 06:35:09PM CEST, stephen@networkplumber.org wrote:
>On Fri, 18 Oct 2019 18:07:26 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> +static bool devlink_param_valid_name(const char *name)
>> +{
>> +	int len = strlen(name);
>> +	int i;
>> +
>> +	/* Name can contain lowercase characters or digits.
>> +	 * Underscores are also allowed, but not at the beginning
>> +	 * or end of the name and not more than one in a row.
>> +	 */
>> +
>> +	for (i = 0; i < len; i++) {
>> +		if (islower(name[i]) || isdigit(name[i]))
>> +			continue;
>> +		if (name[i] != '_')
>> +			return false;
>> +		if (i == 0 || i + 1 == len)
>> +			return false;
>> +		if (name[i - 1] == '_')
>> +			return false;
>> +	}
>> +	return true;
>> +}
>
>You might want to also impose a maximum length on name,

Well I don't really see why.

>and not allow slash in name (if you ever plan to use sysfs).

They are not allowed. Only islower, isdigit, '_'. That's it.
