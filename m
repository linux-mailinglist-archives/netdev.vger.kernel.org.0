Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA24129F84
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfLXJCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:02:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55035 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfLXJCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:02:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so1856769wmj.4
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JpIUPsCQ4mUZV8clqM6x3//3zxhuxnyUCEItvWS4lIE=;
        b=EJ2m8BgGEtcQm8iSYsrb6jbllbscoKNSW55IMHI0wPcev4mLznd5VMRKwg2/sTmJx7
         6B0CFsO0Hi5zcoPBFR5UJazH++6qulEdmR+LgsQTpX43ge6h4U8J8ZJNVTYRJqa9zOoX
         KHYdGmdBFl3qmjTINlKlX73vsGbpXDplIawOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JpIUPsCQ4mUZV8clqM6x3//3zxhuxnyUCEItvWS4lIE=;
        b=c3SjrhDjhGX4Onr0Csu+U3hW+gqDEGRCgG1fa+jJ7rfuHc0tk1Bt9x/N/QvoXFCW/r
         XZxqPHAEzoPPB05v8OaTjKvUKS4cZoszmL6VrHKfUaJ89p2bnExgvHCjxw9bPk+Z9bVp
         e5chIGCffZ1E9zc8PCDzYwPa40VDuRA7XMqhXIO4LaWKzw/YEc7P/uiMDT1KwmoRmAJd
         9yXV+j13QRXAwb1rkBrCHZLRaIWHrlXacfHr8nzzsXmVq0kZ3EGMNkPu6xMALp6dE/Kt
         h1AOW35evSR3cYA/9dGKqscQ1DiN0glNyMQKdsuW2qPXyvt+i8mQ7cxnEHVf1XdW/lRg
         /HJA==
X-Gm-Message-State: APjAAAU6aatEAXiDuaqw6/OgpNPzB7KpKOdcH+tln541eeZLVud46hsY
        P9E4p2BxmcV7CBWDDygltKD5QQ==
X-Google-Smtp-Source: APXvYqwaDJpckqJ1JrVbZPbh8vFZ6XADgxx76CNzAlm8TnNSIoHONxdbgCmk6gW2sYiAbh73ok449A==
X-Received: by 2002:a1c:4b01:: with SMTP id y1mr3010277wma.12.1577178118405;
        Tue, 24 Dec 2019 01:01:58 -0800 (PST)
Received: from [10.230.41.59] ([192.19.215.251])
        by smtp.gmail.com with ESMTPSA id v22sm1942400wml.11.2019.12.24.01.01.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Dec 2019 01:01:57 -0800 (PST)
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     Christian Hewitt <christianshewitt@gmail.com>,
        Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
References: <20191211235253.2539-1-smoch@web.de>
 <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
 <cb3ac55f-4c8f-b0a0-41ee-f16b3232c87e@web.de>
 <47DB71CE-ACC4-431D-9E66-D28A8C18C0A4@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3c42d6de-670d-fee8-aa81-99f44d447e87@broadcom.com>
Date:   Tue, 24 Dec 2019 10:01:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <47DB71CE-ACC4-431D-9E66-D28A8C18C0A4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/2019 5:35 AM, Christian Hewitt wrote:
> 
>> On 19 Dec 2019, at 2:04 am, Soeren Moch <smoch@web.de> wrote:
>>
>> I guess you need similar enhancements of the board device tree as in
>> patch 8 of this series for your VIM3 board.
> 
> Wider testing now points to a known SDIO issue (SoC bug) with Amlogic G12A/B hardware. The merged workaround for the bug was only tested with bcmdhd and brcmfmac may require tweaking as the same issue exhibits on an Amlogic G12B device with BCM4356 chip. Testing the series with Amlogic GXM (older) and SM1 (newer) hardware to exclude the SoC bug shows everything working as expected.

Hi Christian,

Can you elaborate on the "known SDIO issue"? Is it an issue with ADMA or 
something else. I am asking because there is a workaround in brcmfmac to 
avoid scatter-gather lists, which may or may not address the issue.

Regards,
Arend
