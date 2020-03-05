Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93083179C97
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 01:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgCEAFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 19:05:24 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33640 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388425AbgCEAFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 19:05:24 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so1844924pfn.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 16:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ovze5HfNXTKcSnyKmCH8v6ewSvuCSjQBDWK2ldmHyO8=;
        b=l8vcb162DxPzSEDixfB4hqSrkyIX+04H9SHk8arXvCQJxA2QoNSXt4+P2ZMz2/8R6B
         yGvq6kI0Ca6yW4reK02Y5MO2NFZ/9SFciuTIWnngAHB2+eez/c5P0UYt3bkNXNAUZTMN
         YVQ2tnHYwbP9hV7f28MCNWcPXHrsML8MgUeYYAB0ShPBstaOh7H0S/2aKm5lQnb+Xawm
         Bf3aCsNFRCYSpRR7laGMOuPvg5fEU+jROucBaGMUQv0FgdoFf7uXHsObnKCGuiaWjOel
         wMpTq0oqj7nvZHj16fPM+iVvZxyjimWPTdxeXnLf13aZzG/awzEARXT9wLvKko1dOPwv
         9T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ovze5HfNXTKcSnyKmCH8v6ewSvuCSjQBDWK2ldmHyO8=;
        b=eaLwQa+lmWThUVFfcAfXedJNVze+LdbMJsmt7XRz3B1fF9+YOrA+y44XVQylF7I1Gf
         ZFF2NEJ4SCE0lRdm9aEFcqyJFTcaGUlk5xEGouoZg5EK3YAFQm5/RCz0dzDLlBBJZflR
         ujVIZ6lqUQpwDaaJAtriBYtWHCRlaHHwN8hh+b3O+gn7dEqvfWw1A682znfonPW8wCQJ
         f/WEaaILuTBCmgN45T4ieiGnUE/jp3BdB+aXXUirzcTA9qatT7qlPSqNvIsRWHf0xiqC
         cXjcVUotJN21bTK/o62Sp7KptXtNznSgkNsP1I68mxfNRV8TbBDOQFdFmDR+1bnIqHba
         ZZVA==
X-Gm-Message-State: ANhLgQ2EIfp3Rn2Mhg1DQBscOQt1BwwzDtKk+Jd/iGeh/mzxmWNkhP6k
        JKVyWoB2dU25BhDPhjUuh4pvGgAUItI=
X-Google-Smtp-Source: ADFU+vuTrDKOuyRlyKEvtoMUsE2uScjM8GBu8WZcgX70b1DxEWaXsOio4KDkafcfuFNqLoNIndKknQ==
X-Received: by 2002:a62:fb07:: with SMTP id x7mr5451628pfm.125.1583366723167;
        Wed, 04 Mar 2020 16:05:23 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d12sm7116469pfq.87.2020.03.04.16.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 16:05:22 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/8] ionic: remove pragma packed
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20200304042013.51970-1-snelson@pensando.io>
 <20200304042013.51970-3-snelson@pensando.io>
 <20200304115420.2824655b@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a684ff03-9e17-52da-1ff3-aa06b27f4281@pensando.io>
Date:   Wed, 4 Mar 2020 16:05:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304115420.2824655b@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 11:54 AM, Jakub Kicinski wrote:
> On Tue,  3 Mar 2020 20:20:07 -0800 Shannon Nelson wrote:
>> Replace the misguided "#pragma packed" with tags on each
>> struct/union definition that actually needs it.  This is safer
>> and more efficient on the various compilers and architectures.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Ah, I think I missed this pragma in original review :S
>
> nit: I think __packed is preferred

I was hoping to keep with the __attribute__((packed)) format, as I found 
in other kernel headers, as this file is shared in places that don't 
understand the __packed shorthand.  However, with Dave's added urging, 
I'll fix that in v3.

sln

