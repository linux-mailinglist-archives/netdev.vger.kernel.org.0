Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80083D7E1B
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfJORrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:47:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45761 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfJORrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:47:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id z67so19966201qkb.12;
        Tue, 15 Oct 2019 10:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jnflpavPjf+Ft2Pf7r24Ekpvxd/hEtSiZphraBwK8G4=;
        b=hnGiE4qmcddwCKP25rnEIQGmKrSuCVKoZRxrhUxgLRKUrb5MVZcLlsr3L9/qKCzaGf
         P+g5fb6ReBfuv4KKPj3X1mFmaBG1xwwz3FTUyzHRFOtF7z2rEbVAP4mwolzpFMDx83zd
         1k4pIk8dmYpuXWJZEJBWc8y44gFFvgmtVVS7PuiCKqhB8kDcH1bTIUFR+nUeWFRt9eQr
         oORXFN7mDDB55uMIeIPLhQvAfWlMsfY/Sz14ZGYUoCUV14hNI5GLO0BzzeoKiVi+bsBZ
         b5dCx/S9CJingFjwUj42LyMwdGv5RvcPu3J8i/RZRFBElDG9q3iuXAKhb3EVbrFEGjuF
         f5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jnflpavPjf+Ft2Pf7r24Ekpvxd/hEtSiZphraBwK8G4=;
        b=l/rYtMT014KmEFPOudp9BMyHnToqUGCGCbAJ4KEOcGeSiEHOkg1f6VH47RfVcvQNvt
         tEV/WZFCm7tSlj73RkKkN6e8WIt4KvMC70xcR43HVdWqnyaJ5DSB4sBTiU1Uh5JV0/ts
         tRqeePUesh97BH+uxzylgERKciZCptE5med9SHHuqVzOeyTABuN6kCJgH+Hyl0u64u6e
         6Rk/1gQfaxU/qBswOhJOtRJ8e3JkOl6WEcRyGqbP46COgGWU62DzNrbg1/zKtgbD6yz5
         tduqj1TQkeVAM/w341drPLebJMAmSlyAxUedH2WQV+5TWQdFj0MQQV+u7nF6G3Pzgrdd
         s9TA==
X-Gm-Message-State: APjAAAVAk+h5xrlyfQOJb2wOmlDexUCTaHfoo63Yidjbnam/IFmvt2yK
        3/E7C2iFC1tulznbAlEX9QY=
X-Google-Smtp-Source: APXvYqzcNDloZ57H2ek7q2C8DW1bg1ahgqE5n9y84l475SysQqninUVaRAjLcEaDs8rZ49WaFsWl6Q==
X-Received: by 2002:a37:6789:: with SMTP id b131mr37687223qkc.358.1571161653540;
        Tue, 15 Oct 2019 10:47:33 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10e0:57dd:4e1:54d8:dfbe? ([2620:10d:c091:500::2:5709])
        by smtp.gmail.com with ESMTPSA id q44sm13884054qtk.16.2019.10.15.10.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 10:47:32 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: fix RTL8723BU connection failure issue after
 warm reboot
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20191015101909.4640-1-chiu@endlessm.com>
Message-ID: <30809d50-a9ba-881b-1d3b-f3582c14cf79@gmail.com>
Date:   Tue, 15 Oct 2019 13:47:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191015101909.4640-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/19 6:19 AM, Chris Chiu wrote:
> The RTL8723BU has problems connecting to AP after each warm reboot.
> Sometimes it returns no scan result, and in most cases, it fails
> the authentication for unknown reason. However, it works totally
> fine after cold reboot.
> 
> Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
> for cold reboot and warm reboot, the registers imply that the MAC
> is already powered and thus some procedures are skipped during
> driver initialization. Double checked the vendor driver, it reads
> the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
> during initialization based on them. This commit only tells the
> RTL8723BU to do full initilization without checking MAC status.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 1 +
>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 1 +
>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 +++
>   3 files changed, 5 insertions(+)

Looks good to me! If this takes care of the warm boot problem, that's 
pretty awesome.

Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Jes

