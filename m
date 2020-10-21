Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE17294B86
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 12:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439005AbgJUKyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 06:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390849AbgJUKyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 06:54:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC6C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:54:14 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id t25so2489578ejd.13
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HfW34gsf7g1g/Ty9vqXj5/WoQ9OW8/EuoLSIxqDJrBw=;
        b=BAx9KIFOKJ3zL+agOvEbRnKvR+kquRN6xghHcsGlLod/LB+2PUFRGIpt+fyQdMkhCE
         cA+JP/1VPJ4zra/4AP6f7d0uYLDDcVi221bFKH0jTUfcC57PvDbxNcXxA8uSdrRmSq6k
         BYGIqEFRzFegZoEklykvXGbeNygK1/gesH4fa+e3ZOYPXMgH7nU81/AOooK5bxYnr5YI
         pIdygi6DVhdGpGpkvtLOBZLBpdGgXhSX5bg/5Hp8q9N6alD9ARzn/wrP5mW/tw/UWMk4
         DyEVLWKBakdCha0x6tMdSQLep5J7KAgUluUoIwvhyGpYBcQcQm/7o2fn+vrsFbizwA6O
         jDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HfW34gsf7g1g/Ty9vqXj5/WoQ9OW8/EuoLSIxqDJrBw=;
        b=nUyn3CmW9PnruMpidKE2GFfyroVgJsE3YepPFnInAeNIiIQTJCmt6Qu30CYEVCyfMa
         aTGdMJ1XWpHEB0JEIEXc30feiuGjCwcwgQmNjmsjIUCq5Yjp0IPM2AP7LwVAgGLEPERT
         sb3e+jW3xcHuEVJXKixUG/rNmQ4jp20oGi1+WN7MoOdP44yjKuIKngcVveSj+zOklbCH
         VC6s94ZZLL/SIWl6J19PK15UZ0tYT2iJQ56prFG7XAzt311bIV1w+T/VsDlGCJzCG444
         lfXDyL85VOw4TQpQHJNEvhxWPA+Jdb07Cw6EQBGZf9FAM1pmk6fWxqCtlQKW+42g/shM
         7s8w==
X-Gm-Message-State: AOAM532FgKWtCCRMZIxtxYyLqhtJ8+KWFo1+52LvtuDt2thXRbNGddCW
        5jDB43zfZm/0/i/2T1NhFivrqotAf6fOq98D
X-Google-Smtp-Source: ABdhPJwLxqM2i3gZnaB2H4ECV6ww6BmzkBlev8VYw0Ieio7hGbJv6GHRneJUXwOMJAAz+uHYD1JHmw==
X-Received: by 2002:a17:906:b1a:: with SMTP id u26mr2796253ejg.23.1603277653004;
        Wed, 21 Oct 2020 03:54:13 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:9bd7:d012:64eb:ce81])
        by smtp.gmail.com with ESMTPSA id g18sm2073166eje.12.2020.10.21.03.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 03:54:12 -0700 (PDT)
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20201020073839.29226-1-geert@linux-m68k.org>
 <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
 <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMuHMdW=1LfE8UoGRVBvrvrintQMNKUdTe5PPQz=PN3=gJmw=Q@mail.gmail.com>
 <619601b2-40c1-9257-ef2a-2c667361aa75@tessares.net>
 <CAMuHMdXUs_2DodcYva8bP+Df979TMrmRD=+LUiVVzdH0zmxK1Q@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <f414539c-1370-1636-137e-38c735f449f6@tessares.net>
Date:   Wed, 21 Oct 2020 12:54:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXUs_2DodcYva8bP+Df979TMrmRD=+LUiVVzdH0zmxK1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 21/10/2020 11:52, Geert Uytterhoeven wrote:
> Hi Matthieu,
> 
> On Wed, Oct 21, 2020 at 11:47 AM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
>> On 21/10/2020 11:43, Geert Uytterhoeven wrote:
>>> On Wed, Oct 21, 2020 at 5:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>> On Tue, 20 Oct 2020 11:26:34 +0200 Matthieu Baerts wrote:
>>>>> On 20/10/2020 09:38, Geert Uytterhoeven wrote:
>>>>>> MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
>>>>>> not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
>>>>>> is done for all other IPv6 features.
>>>>>
>>>>> Here again, the intension was to select IPv6 from MPTCP but I understand
>>>>> the issue: if we enable MPTCP, we will select IPV6 as well by default.
>>>>> Maybe not what we want on some embedded devices with very limited memory
>>>>> where IPV6 is already off. We should instead enable MPTCP_IPV6 only if
>>>>> IPV6=y. LGTM then!
>>>>>
>>>>> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>>>>
>>>> Applied, thanks!
>>>
>>> My apologies, this fails for the CONFIG_IPV6=m and CONFIG_MPTCP=y
>>> case:
>>
>> Good point, MPTCP cannot be compiled as a module (like TCP). It should
>> then depends on IPV6=y. I thought it would be the case.
>>
>> Do you want me to send a patch or do you already have one?
> 
> I don't have a patch yet, so feel free to send one.

Just did:

https://lore.kernel.org/netdev/20201021105154.628257-1-matthieu.baerts@tessares.net/

Groetjes,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
