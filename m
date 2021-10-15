Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD50D42FDEF
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhJOWO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbhJOWOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:14:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA14C061570;
        Fri, 15 Oct 2021 15:12:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t2so28753115wrb.8;
        Fri, 15 Oct 2021 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Zw4hHOyRi0nLRM8juyCHho35C6rylEb93NkGLQjKtk=;
        b=CpaNiIj4t6zU70wY6P1PJpSopESDjMOAkejSkehdpBJg1WOVRHslUlXnYB+12L0gxJ
         ghZki0iSEgEevMDwJ4ot1JoQdJHZFBjzHYTliD0cDAYOHeJ+TZ9Kvo3xyQg5CFI1BDV2
         SaHBOMNXqEvoU4gulqULJCWMHjL0qNttN6vsA1sTgl3BYVqpes8sx2E79g6qo3XoESt4
         UX9fpGTvtIjvHkCaqa7KYjzhdBk8ybfZqUraqVRt2WFDsKd2Oo8eu3By1vkBgBWtK0av
         CN0Y6SGC9yq00dXY7RsirnIcpLDsTFq0g2+laUX3Aui9vrF6GGgyGsd/vsOPhp+ne2zG
         N3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Zw4hHOyRi0nLRM8juyCHho35C6rylEb93NkGLQjKtk=;
        b=Rlc8TH46ie89TXVNuqfsiJeIf7OKN8BwxcUwPNWpO3plVFzbcl65xw6dOp7YMqcT4n
         SVP2QqNclhjxfA/CKHHx7ZFtbyoOh6WmBOzeBLWB8rjlGy/NQGpvIpRsrJpfc7D/qX/l
         KU+oE0gLJHGDp+79E0TrBFEFl1ApBHKMFRhy81lAjlQPtv6f1Kp7btyknjCaoUdqxbWO
         7PINkxQDh4gfNEEtIgFlfZsx1STHizy/RwElAOQ9DfjSD7ryhOBbrXN3OddiQq0ZTQCR
         b0ghzqwZq1UzmADBWqRxMdGMkCO+pdTVin48gJ459TzTeYNdh5hpulozvcfePGnMWUl0
         NdOA==
X-Gm-Message-State: AOAM5307RFD9CosPso/Dth2Nh7HvBM1l3nYw3upWYnEsoE9rO9LkCE7+
        NI8mLku3sEcGdZYFVdaFB3U=
X-Google-Smtp-Source: ABdhPJwFQCk6fViYQH3XJn1mNLyZuOQ9HIGUhWyUsc9anVzh0zcbDCeIe1MBe00rpt9powWjPcO7cw==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr17972370wry.207.1634335930337;
        Fri, 15 Oct 2021 15:12:10 -0700 (PDT)
Received: from [10.168.10.11] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id e8sm8497159wrg.48.2021.10.15.15.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 15:12:10 -0700 (PDT)
Subject: Re: [patch v3] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
To:     Wei Wang <weiwan@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20210924235456.2413081-1-weiwan@google.com>
 <CAEA6p_CSbFFiEUQKy_n5dBd-oBWLq1L0CZYjECqBfjjkeQoSdg@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <6c5ac9d3-9e9a-12aa-7dc8-d89553790e7b@gmail.com>
Date:   Sat, 16 Oct 2021 00:12:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAEA6p_CSbFFiEUQKy_n5dBd-oBWLq1L0CZYjECqBfjjkeQoSdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei,

On 10/15/21 6:08 PM, Wei Wang wrote:
> On Fri, Sep 24, 2021 at 4:54 PM Wei Wang <weiwan@google.com> wrote:
>>
>> TCP_FASTOPEN socket option was added by:
>> commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
>> TCP_FASTOPEN_CONNECT socket option was added by the following patch
>> series:
>> commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
>> commit 25776aa943401662617437841b3d3ea4693ee98a
>> commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
>> commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
>> Add detailed description for these 2 options.
>> Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.
>>
>> Signed-off-by: Wei Wang <weiwan@google.com>
>> ---
> 
> Hi Alex,
> 
> Does this version look OK to you to apply?
> Let me know.

Sorry, I missed that patch.
Thanks for the ping!  I'll try to have a look at it ASAP.

Thanks,

Alex

> 
> Thanks.
> Wei


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
