Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3FD1398F2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgAMSdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:33:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52820 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgAMSdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 13:33:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so10913958wmc.2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 10:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q0bGSICAx1pbHYHOWbJKg+AmvJvz7a95IIUv+bSd8t8=;
        b=PzLsRu3GFLOX7/ue7FryDfE7Mk8OEf3gDqM9GZykAJJj6G7bhQA0uTHsKJ2bGWi+oP
         9GQH2BW622LsEXN+3MuB3vfA0YEx1P1MVDAkT13hE6Si9AWi9NNU6vqsMDy/s58jQIFE
         4wwNZP1L2dgc9v7N9kQJxWRXQcqutNM8dBasZ8JrN2oDkxnjitDTaeytyC0SZjECeBOr
         Co2HmXdzJeJuvPmcvDjpijP5xD3/Zjhu/4nU3ffN0YsP3tYfME6/FhoiUhVBlE8LlNZK
         TlZbCGsClqv8rqsDZcL73rYCZ6JYmBDS4xjIDsuxhjAL+3p8/8QvFusYLLYFTud/+cmq
         TcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q0bGSICAx1pbHYHOWbJKg+AmvJvz7a95IIUv+bSd8t8=;
        b=P7V/kLy+pU6GoBAP3SeKXVpC8pKEWSvpXnlSUWiP7ThzA+Qtrglzpy8iKhGR+MbFaR
         geYwSRBTl+X3Vf2OuvVcuD+lPNnse7/TP+Bct+QIm9w9isYFje7alF/uwcENZN9OKwGC
         /vwkFw6FUgPrqZUIngc6+K8o3Ucz9VW4hdnzkCrh6NVkGhiDw2rULr4PgACvkk6yFbLZ
         ZyC5rnF/8r4U/bhRqoKkZi7DYwAG4wsSp/1UB4pnS0qYJ/c8hygBReMkBLsmiLqvcG/k
         BkG1NQPT6LEMCirdbrUkZucM73IyGOA7bz6VrWFS4nVtE8HoHwN4aBZT7b3tA5GFAW5J
         qiAw==
X-Gm-Message-State: APjAAAXktV0JP4r92eRc2uqU36FDT/OLTJNxsfBD6eeUAcH1kS10zA6s
        YiqWGHn3sJi8loEb4V6lY3o88A==
X-Google-Smtp-Source: APXvYqxTlk0OM7uUYKbqgVlUyukyACPvaxoGgFYVC1T8cELvN5V7CCyWv3a0VVhAmGydFG33+AeuCw==
X-Received: by 2002:a1c:2394:: with SMTP id j142mr22589527wmj.25.1578940385846;
        Mon, 13 Jan 2020 10:33:05 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id t25sm15317639wmj.19.2020.01.13.10.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 10:33:05 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:33:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Alex Vesker <valex@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200113183304.GI2131@nanopsycho>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200112124521.467fa06a@cakuba>
 <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
 <421f78c2-7713-b931-779e-dfe675fe5f53@huawei.com>
 <20200113033431.1d32dcbe@cakuba>
 <28bc8945-6c55-2ad3-963a-156efe616038@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bc8945-6c55-2ad3-963a-156efe616038@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 13, 2020 at 07:16:51PM CET, jacob.e.keller@intel.com wrote:
>On 1/13/2020 3:34 AM, Jakub Kicinski wrote:
>> On Mon, 13 Jan 2020 09:39:50 +0800, Yunsheng Lin wrote:
>>> I am not sure I understand "live region" here, what is the usecase of live
>>> region?
>> 
>> Reading registers of a live system without copying them to a snapshot
>> first. Some chips have so many registers it's impractical to group them
>> beyond "registers of IP block X", if that. IMHO that fits nicely with
>> regions, health is grouped by event, so we'd likely want to dump for
>> example one or two registers from the MAC there, while the entire set
>> of MAC registers can be exposed as a region.
>> 
>
>Right. I'm actually wondering about this as well. Region snapshots are
>captured in whole and stored and then returned through the devlink
>region commands.

Well, driver does not have to support snapshots for particular region,
only live reading. Yes, this needs to be implemented.

>
>This could be problematic if you wanted to expose a larger chunk of
>registers or addressable sections of flash contents, as the size of the
>contents goes beyond a single page.
>
>If we instead focus regions onto the live-read aspect, the API can
>simply be a request to read a segment of the region. Then, the driver
>could perform the read of that chunk and report it back.

Yep.
