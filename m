Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB14D2B973A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgKSP7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgKSP7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:59:43 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D8C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 07:59:42 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so8609884ejb.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 07:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u2kG6boT1glNrcNWAWZkM0uxC8q8LxoD5latPJj4gPs=;
        b=hTVJl9MFYjhfxxhNiMIGqPKlSOnfufqgN6ctgEulrbu8Qk+0W1gI0yOjhjHgmivk42
         PfctCUbzTqByi2NuCkTcP4JpWWj1foDZzg9PNpX6j07wiAZSNrpaSYPVsX/2CPCgoNn5
         csuXBTGP032hLZTrizTDU7pmqpGBBdCzk+jTe2novFU/YXDBDNQzEJCuTa2PkpGTnr6G
         5g9RUeu+X7chW3Shtgr3mC/zFYVe2cR9Y5cVblaQcPniu/N/AygeUck66JYL9vuWxUMS
         ttL3ncAUwUaTHxAQM/fUeFdmH/lbpG8QTp3xw4o/KeRHJoIHBpHMXm4huhB1a0mAXYX8
         4SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u2kG6boT1glNrcNWAWZkM0uxC8q8LxoD5latPJj4gPs=;
        b=rg7OWF1cZF7TG3jFb9hXl0RZm2zD98LPI0+IETtAuGUwaFWobku21dKV+ppy7mf9Mv
         47Jd1GMDmPr7Qzlqc+S3NzyLGlP/7/DtNunIWG2S0ZddYw0+GCSQnAE5spoJMwYdbXnV
         kLrjU4qRvaFi6qJx2lhJtIWi981ZZz9SEalKjD0p+VKl1pMFFtH6ea10FTVr9TotoCPg
         DaWuKXdLIbHwXyLKjbYDU/3eT5ax03nQA4zjjndcH9prNdkJmerPOp1VHzVoXo/d3QBt
         JNlYXWH2cI6LfP6653q9MCPhMkgMqwAdJbvNeBowiPEwEBAm0L9J/5pRAAVWXEep6kFc
         xRFg==
X-Gm-Message-State: AOAM531pHJEFT44yOjsj9yTNt5aiz7UWeVx5DBD7cA7ouZRQAiruoLy5
        HaWhy2VgY3XexZJete9S+F98vEFCh1A=
X-Google-Smtp-Source: ABdhPJzUt35BzMLpGzMtDMjotc8y2icASKY648wHqyO6PRhMIUFzly8jDj33tInLYIP6uw4JlVDzIA==
X-Received: by 2002:a17:906:15cc:: with SMTP id l12mr27660146ejd.363.1605801581629;
        Thu, 19 Nov 2020 07:59:41 -0800 (PST)
Received: from [192.168.0.110] ([77.127.85.120])
        by smtp.gmail.com with ESMTPSA id i4sm3700988edu.78.2020.11.19.07.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 07:59:41 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
To:     Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
 <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
Date:   Thu, 19 Nov 2020 17:59:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/2020 2:02 AM, Jakub Kicinski wrote:
> On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:
>> This series opens TLS TX HW offload for bond interfaces.
>> This allows bond interfaces to benefit from capable slave devices.
>>
>> The first patch adds real_dev field in TLS context structure, and aligns
>> usages in TLS module and supporting drivers.
>> The second patch opens the offload for bond interfaces.
>>
>> For the configuration above, SW kTLS keeps picking the same slave
>> To keep simple track of the HW and SW TLS contexts, we bind each socket to
>> a specific slave for the socket's whole lifetime. This is logically valid
>> (and similar to the SW kTLS behavior) in the following bond configuration,
>> so we restrict the offload support to it:
>>
>> ((mode == balance-xor) or (mode == 802.3ad))
>> and xmit_hash_policy == layer3+4.
> 
> This does not feel extremely clean, maybe you can convince me otherwise.
> 
> Can we extend netdev_get_xmit_slave() and figure out the output dev
> (and if it's "stable") in a more generic way? And just feed that dev
> into TLS handling? 

Hi Jakub,

I don't see we go through netdev_get_xmit_slave(), but through 
.ndo_start_xmit (bond_start_xmit). Currently I have my check there to 
catch all skbs belonging to offloaded TLS sockets.

The TLS offload get_slave() logic decision is per socket, so the result 
cannot be saved in the bond memory. Currently I save the real_dev field 
in the TLS context structure.
One way to make it more generic is to save it on the sock structure. I 
agree that this replaces the TLS-specific logic, but demands increasing 
the sock struct, and has larger impact on all other flows...

What do you think?
If we decide to go with this, I can provide the patches.

> All non-crypto upper SW devs should be safe to cross
> with .decrypted = 1 skbs, right?
> 

AFAIU yes.

