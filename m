Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC8E483DCA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiADIKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiADIKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:33 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997F3C061785
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 00:10:32 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o30so20168272wms.4
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XtZPNg5BQ2lnjrzwucV2YutRAMLHihSI4hljd/dvjjQ=;
        b=UIEksoicnTnbSAoKcrAyVcpWdKN+T7XDY3vxn8ND3Bj46J/5DgwNNmbOq4zUyTfz1i
         1cZhrodOO1N3Xt1bL1wqT006VJvBlsl1PvJY0ELWL/IZ792SaBU2WNUjsdlgcQNfyWZB
         wE1KcLgPRf1mxJxiGohnYPnD7EheF58ExKmf34RQODJDRe+tFXl2mSxZfaCnijRp5W90
         5WTFpiwvnbz0E3N3zb5AijS4CAbWecjwhE/hlBkhEmbsWNgDkKUayPBFVrygmVCZnCno
         ojXqhbvYk9+OxyLWWstRO6e651xKN/Meruc+yaqNuHKQ2ct4pF3sTw78hixHVhMNHfFc
         gVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XtZPNg5BQ2lnjrzwucV2YutRAMLHihSI4hljd/dvjjQ=;
        b=MBM5hu2qcGxxUTorl0WSyY5pENFVpVX6nJw6wdlwXTF0FzoOHRFn4cWPGOVy8wweCD
         tM/OkadXpRQBgOU2/fky1NADDNMa3hmKiytHF6ZJQB/lyelD1IpM2jqE/Wlid0opMJ31
         fNxJpvdY9AQvS/78G+lZABGN3XCxYd4fgI1/+rYAG5KwBg//a1V0c57OIJSvKfvFlq4h
         1jsd/IK6gB9/0DofumqyeK+iGOomf1AAXVIKTH8tBxbYE0ZW/nzsB8HVSc1Jr7rQhQE8
         /hrqUHoHUhh1kGsCWnJ8egc4mXNrVDL4Jtg4zKWzyu8B4RFKoYra5AwYUQjLa8A1mhSZ
         oXjg==
X-Gm-Message-State: AOAM530rxXOkp9hqL42o/KXdnW6LUsU5yfJt4MQAbX1rCgT48E5ipzvX
        MfJ/LeopUZweFSnXst2QR55scw==
X-Google-Smtp-Source: ABdhPJzVm6KI+SLycqoUEYxG88WD4gSOy9bPBwev6wkRs2Miuna0OdrNAxJvQoB+x6en4DT9qz+0xA==
X-Received: by 2002:a7b:c357:: with SMTP id l23mr41519598wmj.35.1641283831093;
        Tue, 04 Jan 2022 00:10:31 -0800 (PST)
Received: from ?IPv6:2001:861:44c0:66c0:f6da:6ac:481:1df0? ([2001:861:44c0:66c0:f6da:6ac:481:1df0])
        by smtp.gmail.com with ESMTPSA id l16sm42009745wrx.117.2022.01.04.00.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 00:10:30 -0800 (PST)
Subject: Re: [PATCH 0/3] ARM: ox810se: Add Ethernet support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        linux-kernel@vger.kernel.org
References: <20220103175638.89625-1-narmstrong@baylibre.com>
 <20220103200637.0b9d7e4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <151bbcee-2f3b-4454-4244-523917cd4900@baylibre.com>
Date:   Tue, 4 Jan 2022 09:10:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103200637.0b9d7e4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 04/01/2022 05:06, Jakub Kicinski wrote:
> On Mon,  3 Jan 2022 18:56:35 +0100 Neil Armstrong wrote:
>> This adds support for the Synopsys DWMAC controller found in the
>> OX820SE SoC, by using almost the same glue code as the OX820.
>>
>> Neil Armstrong (3):
>>   dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
>>   net: stmmac: dwmac-oxnas: Add support for OX810SE
>>   ARM: dts: ox810se: Add Ethernet support
> 
> Judging by the subject tag on patches 1 and 2 and To: I presume you
> intend this series to be merged via net-next? Can you please repost
> with patch 3 CCed to netdev as well? It didn't register in patchwork.

It was on purpose, I planned to push the DT through arm-soc, sorry it wasn't
explicit in the cover letter.

Neil
