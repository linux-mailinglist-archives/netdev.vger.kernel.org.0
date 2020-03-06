Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB9B17BA27
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 11:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFK0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 05:26:43 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:38735 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCFK0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 05:26:43 -0500
Received: by mail-wm1-f42.google.com with SMTP id u9so1771842wml.3
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 02:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1TkTXlrqCFBt1ZCBFTNizoJKac/Tis9Rlqb217tQR3c=;
        b=C15mMDDHadZyGow7pvWTAH5pAfFmytLPx4n7eV57T4jdpwAp7t8F8x3pZ40ScywI/K
         cquKL4Im3JHJcIfDzi6BYTQMBIp4Nd5Y954+CKCA+0Dz2YoWz+vqBxZe5evbsboZIG4C
         Km4a5RleZ7eX4QPZ8x/oK6mBK1PfKS/3Ak4SA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1TkTXlrqCFBt1ZCBFTNizoJKac/Tis9Rlqb217tQR3c=;
        b=NEDW3eN6w9rYDDegT0KxQ4vf0fLiVttUFvUd9CDgzWsKRuCACNDdrTQmaRRBZdXMSh
         bx7G4xBJmmeH4/i++70O/h4TJREuBxCMZHdGQKKFrlNRU6NPDdfbjyJZs9sv9XSTQ9Y4
         FZwFIWbi/vF6+Yn7oGu4PNuuQAe8X3n30xsSowgl9Sx1bPHZ2xlyfqbCodKcyjUfLNzw
         t5UDNnwvlz4cU9YJKJfzi7zPs6ZgTV61Cm9Zy5NaZH5xbIWAv7VuQd52IFyKmCCTd953
         O4sNWX0dksmKYxfHkPRhbPN+N7qMj2RNy+5h/LEhb+ZAiDzLNuz1C1SMRblMZdq4qShu
         gqsA==
X-Gm-Message-State: ANhLgQ1r++RXiaMjnK+GSTzii9G1FMtLihFTNZuPJ1CUkteomQxOlrbO
        EHWfZwWeEHBwQ2Ga5028X+URaw==
X-Google-Smtp-Source: ADFU+vt1tUvyLCtmdeVcHSF24DEToOTgTGyEt0Dv6iOwSMTBxZfgSSvG9xANcOqRRX3AZyoCRD28mg==
X-Received: by 2002:a1c:f610:: with SMTP id w16mr3261404wmc.136.1583490401318;
        Fri, 06 Mar 2020 02:26:41 -0800 (PST)
Received: from [10.230.41.113] ([192.19.215.251])
        by smtp.gmail.com with ESMTPSA id v8sm13988795wma.28.2020.03.06.02.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 02:26:40 -0800 (PST)
Subject: Re: [PATCH][next] brcmfmac: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225020804.GA9428@embeddedor>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <170f7087-1f70-941e-9e6c-749eaf3978fe@broadcom.com>
Date:   Fri, 6 Mar 2020 11:26:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225020804.GA9428@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2020 3:08 AM, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:

[...]

> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h | 2 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c     | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
