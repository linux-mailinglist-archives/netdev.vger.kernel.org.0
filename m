Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF79A28FC7B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404303AbgJPCnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393825AbgJPCnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 22:43:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B34C061755;
        Thu, 15 Oct 2020 19:43:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so613893pfb.4;
        Thu, 15 Oct 2020 19:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1NyZzbpG9N5rPLWl37uRaSuAT+xCLnbOLTe5sPgeKOo=;
        b=CLcTNQnW5lLVwWDEo20N7pFD9YR6oAgipCO6XWF8mFzQayY3Xbnv23ga2u++2j+AQz
         3qGMdnRJdmYCUW1jKoNlKGflzK5k0rg+CucU8O/N0ikDBC4LaDM7SEQaeIFhDwm2NQQD
         d0skEKzHqZ3ES/pyxsaOhEZ8p7tms/ZUxVVQlHSvcAiwOCac2llNqG2H9gyA8ykA8+VD
         Mwz6URox6K7xiJveqgaBoAUij8chyLKSZfJRW72tqm66xFMIjPnZOVKJgQu/cxVUCGL1
         2vzg+ImS/V0HkY14T10Ak63IUgyK2GXy66bX26MI3oGYghFvEOJaxJm/boeFE9pE+Tf3
         4Jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1NyZzbpG9N5rPLWl37uRaSuAT+xCLnbOLTe5sPgeKOo=;
        b=kkxis5hjPOYphcs0mjGFAr4DrjJ5ysZzPJbwVvPhh4FfBCozeilOf7x6tpa+3jfvF5
         OTpicc8YdpH4QGfa33GI+1XOPLSe84ZahNoZkIillcsVSqQdnYmZOo7iHEzuAj86cCG3
         Cl0V4uhRgAk0yPm0fIBmq3rsRCyyGWwqi6OtWau0UOhRDkWMDM/2P5kK5rXLdjNEaKy+
         XYUdj6ZIYuJ3RaWDjOsSHM6FXdySv0SNK9B++hE2gax6flB+wxdKTw9TtTY2wU2yn96V
         2Ump18NOel0AR3bmx1o4JvkGs92HsbuB5Vc2g+02FAkVaMj2rK8aSoTToC8yqpPrs8s/
         EIBA==
X-Gm-Message-State: AOAM532wKxiJ6FPDhTlbYiMLDq9DJuojwZLpIJiF+np+nS5Z4jdVIaUX
        /fEW0VuYncsnhQ1kS/h+mweuIjmeqGo=
X-Google-Smtp-Source: ABdhPJytwECvwYP9JeoZ/EnUlWPUMpBtTpolpv3oO6DK/J7P1K4l5UtmbW5Y/ZLYYPTnRFxY9TzIFg==
X-Received: by 2002:a63:d80e:: with SMTP id b14mr1289918pgh.114.1602816223153;
        Thu, 15 Oct 2020 19:43:43 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t20sm695413pfe.61.2020.10.15.19.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 19:43:42 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Drop old
 bindings
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-3-kurt@kmk-computers.de>
 <20201012184707.GA1886314@bogus> <87r1q0c6ks.fsf@kurt>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84db948d-f253-8d27-72ea-466eadade162@gmail.com>
Date:   Thu, 15 Oct 2020 19:43:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <87r1q0c6ks.fsf@kurt>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/2020 12:05 AM, Kurt Kanzenbach wrote:
> On Mon Oct 12 2020, Rob Herring wrote:
>> On Sat, Oct 10, 2020 at 06:46:27PM +0200, Kurt Kanzenbach wrote:
>>> The device tree bindings have been converted to YAML. No need to keep
>>> the text file around. Update MAINTAINERS file accordingly.
>>
>> You can squash this into the previous patch.
> 
> OK, sure.
> 
> @Florian: Should I send a v2?

I don't think that is necessary, I will do the clean-up of arch/arm/ and 
arch/arm64 and merge your two patches and submit everything as a series 
once completed. There is no rush here AFAICT.
-- 
Florian
