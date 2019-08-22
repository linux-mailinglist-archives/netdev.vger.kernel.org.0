Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820C79A34D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405292AbfHVWwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:52:41 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:51801 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbfHVWwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:52:41 -0400
Received: by mail-wm1-f49.google.com with SMTP id k1so7147859wmi.1;
        Thu, 22 Aug 2019 15:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=05zJrRULPj9O9zDjNH7kXRlLGYjkAvYL/aN4lh3LN+0=;
        b=WAiq8qF5Hc5vqopLX9vJZzvIVpaM/s7Oa2DrkJHDvUt7z3m+Xab8veqONGrYrXbmYp
         BcxixBeFqXL1w28oym+vMJP83ogrtLWcSobuinz3NTDjvMZK4r6K2bQUNVxeUH8BDKQl
         amk7t/MMr/qIVd04DJ7m/vGmgVGrv0xHJNGnIYJ14kGGEGgAmbsfX/XKsr1vu4QGYFOZ
         JThEdRjcNR/lR6DckRTOs+UqtkEfnZc6tTSGOcx2pVMISnAzNvY2LkZoYSlUXwoeIl7a
         zQn8/EXOXDMM8+nzGQqzSlohvmA/ZA+I5HndXZ4nfJbRpc7UHSU3xPI4bTFAY2pbTAMD
         DAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=05zJrRULPj9O9zDjNH7kXRlLGYjkAvYL/aN4lh3LN+0=;
        b=jCngVNTmCnS1YIf0yMNg/hCPYj/pBhoxCxZflZ/Ow55LGTmkeCnH+4GCSJqECd9uvV
         sFxt0D2jgDroIpzIRObGIm5dIelgyeykQ2L1J7t31vUXxnHt0AFyI/KALksGzQBk10+N
         TLNf1a14481x9Su9dtgknRF3ae9bi1N4ZS76IJYioYzohWmJ30sbJILUmdGnifZH4fZw
         p7p/b8ufuSobplIzhp4jOx5FpT4bgQh4Gy3+vXhkGinTaCDZZibry2kLvHkXOjaAbyw7
         9FKvgyZB17L3Eqh3YLMhz0HTeD4ru3WLlIxi+bwsTVblo54muVpdFFabcmEpANhOYPjr
         vEmg==
X-Gm-Message-State: APjAAAUnlxYcKYyH6QfbSuhh//pnWq65wRnCP6XpOA4RXsvPtMsDPKU7
        GhLHMil+nXfiCWaEQ6zGg3LhOGnv
X-Google-Smtp-Source: APXvYqxmsaTyglWUEPUS0yRkW+gm9zXTCPcObnyjmJ6xdS8+nMAMsKf9HxatvILjaznElS5HgEJ0Fw==
X-Received: by 2002:a05:600c:225a:: with SMTP id a26mr1319350wmm.81.1566514358751;
        Thu, 22 Aug 2019 15:52:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:3853:c94b:1882:d6b3? (p200300EA8F047C003853C94B1882D6B3.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:3853:c94b:1882:d6b3])
        by smtp.googlemail.com with ESMTPSA id z2sm664422wmi.2.2019.08.22.15.52.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 15:52:38 -0700 (PDT)
Subject: Re: r8169: regression on MIPS/Loongson
To:     Aaro Koskinen <aaro.koskinen@iki.fi>
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org
References: <20190822222549.GF30291@darkstar.musicnaut.iki.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d76b0614-188e-885c-b346-b131cc1d9688@gmail.com>
Date:   Fri, 23 Aug 2019 00:52:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822222549.GF30291@darkstar.musicnaut.iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.08.2019 00:25, Aaro Koskinen wrote:
> Hi,
> 
> After upgrading from v5.2 to v5.3-rc5 on MIPS/Loongson board, copying
> large files from network with scp started to fail with "Integrity error".
> Bisected to:
> 
> f072218cca5b076dd99f3dfa3aaafedfd0023a51 is the first bad commit
> commit f072218cca5b076dd99f3dfa3aaafedfd0023a51
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Thu Jun 27 23:19:09 2019 +0200
> 
>     r8169: remove not needed call to dma_sync_single_for_device
> 
> Any idea what goes wrong? Should this change be reverted?
> 
Typically the Realtek chips are used on Intel platforms and I haven't
seen any such report yet, so it seems to be platform-specific.
Which board (DT config) is it, and can you provide a full dmesg?

> A.
> 
Heiner
