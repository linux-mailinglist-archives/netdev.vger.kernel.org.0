Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307412ABAB
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 20:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfEZSmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 14:42:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36941 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbfEZSm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 14:42:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id n27so7786473pgm.4
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OLaJRa4hCtuEEMwKNtUZMZ+QEafCBrmCJfsSQcoxk78=;
        b=ZpKF+rNte3zJzdktFMth5dLBIMKQN/Wi/DOrVKbWsETZufYdcs05WlRw8s4ebyKPOa
         vfTyk7yEeJnMKF7ehV4l8z0/1vQvx8YEkx2rBH+Izid83ssvISnn8ifLJs5FyKEQJ0UQ
         XEXVoZcGBn/ZoT/UAu1KKsgnLnmQSZiSvQhSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OLaJRa4hCtuEEMwKNtUZMZ+QEafCBrmCJfsSQcoxk78=;
        b=QZQdJetd44LJE9RImufb1MLnaABn6L7RGXRmWMFwIxDi/CGJCLej0yUbhWdPMTDr+F
         CcQNjMTk5cQm5bFmkaUmWScP716vLPwv3LkA+LaZDbMnvHM8hPNja+echX0ZOR7YS14f
         U0ZqQSmgi7xiJTBLBJDNu1XZyRXSYBEfugCojBC2PNZM3dariXCd35hm1hRJHx0b+tIK
         wFB+BfOKcfIo9v+2FlRUndzzIPykj5tx+PSVG2R47eCxrg75cOxkDIVThExEOg59qf7R
         waD4wHmYOWCYldOhcHpI7mutNHWEIiHUQc9uRQf7+Fnt+Ei0uqtS5zP6VJJ3G/b/zuH3
         ojYw==
X-Gm-Message-State: APjAAAWTpBtM1kzmSdvYsOw2LgoxVoY0t+k0Irpg44PDlsJ4PqCdwnRi
        HeN6lKKVJM3WJVyCsb1BqwwdA9XBMCv2FeE7lMl6nQ9akwmyxZvD8xPWSms3v6SBcpsmvDlcrFr
        d7rV7PkVEQnogb1QOELmkn7JwwZlFKqugmUax+dKB324uDZnv4U1g8RKHFM1Yfz/XuYZMz+0LVD
        d37XI=
X-Google-Smtp-Source: APXvYqy+Z0E8VktDWKwW+/AEDsqgzRsoImYfM8kS6UqnH5p2lHYy+Bm32NEhHRGz1iAfShMpVEIPeA==
X-Received: by 2002:a62:fb18:: with SMTP id x24mr65735472pfm.76.1558896148261;
        Sun, 26 May 2019 11:42:28 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id d6sm8297881pjo.32.2019.05.26.11.42.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 11:42:27 -0700 (PDT)
Subject: Re: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc:
 sdhci: queue work after sdhci_defer_done())
To:     Brian Masney <masneyb@onstation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     ulf.hansson@linaro.org, faiz_abbas@ti.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
References: <20190524111053.12228-1-masneyb@onstation.org>
 <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp> <20190526122136.GA26456@basecamp>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com>
Date:   Sun, 26 May 2019 20:42:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190526122136.GA26456@basecamp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/2019 2:21 PM, Brian Masney wrote:
> + Broadcom wireless maintainers
> 
> On Fri, May 24, 2019 at 11:49:58AM -0400, Brian Masney wrote:
>> On Fri, May 24, 2019 at 03:17:13PM +0300, Adrian Hunter wrote:
>>> On 24/05/19 2:10 PM, Brian Masney wrote:
>>>> WiFi stopped working on the LG Nexus 5 phone and the issue was bisected
>>>> to the commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet") that
>>>> moved from using a tasklet to a work queue. That patch also changed
>>>> sdhci_irq() to return IRQ_WAKE_THREAD instead of finishing the work when
>>>> sdhci_defer_done() is true. Change it to queue work to the complete work
>>>> queue if sdhci_defer_done() is true so that the functionality is
>>>> equilivent to what was there when the finish_tasklet was present. This
>>>> corrects the WiFi breakage on the Nexus 5 phone.
>>>>
>>>> Signed-off-by: Brian Masney <masneyb@onstation.org>
>>>> Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
>>>> ---
>>>> [ ... ]
>>>>
>>>>   drivers/mmc/host/sdhci.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>>>> index 97158344b862..3563c3bc57c9 100644
>>>> --- a/drivers/mmc/host/sdhci.c
>>>> +++ b/drivers/mmc/host/sdhci.c
>>>> @@ -3115,7 +3115,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>>>>   			continue;
>>>>   
>>>>   		if (sdhci_defer_done(host, mrq)) {
>>>> -			result = IRQ_WAKE_THREAD;
>>>> +			queue_work(host->complete_wq, &host->complete_work);
>>>
>>> The IRQ thread has a lot less latency than the work queue, which is why it
>>> is done that way.
>>>
>>> I am not sure why you say this change is equivalent to what was there
>>> before, nor why it fixes your problem.
>>>
>>> Can you explain some more?
>>
>> [ ... ]
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
>> sdio_claim_host() and it appears to never return.
> 
> When the brcmfmac driver is loaded, the firmware is requested from disk,
> and that's when the deadlock occurs in 5.2rc1. Specifically:
> 
> 1) brcmf_sdio_download_firmware() in
>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c calls
>     sdio_claim_host()
> 
> 2) brcmf_sdio_firmware_callback() is called and brcmf_sdiod_ramrw()
>     tries to claim the host, but has to wait since its already claimed
>     in #1 and the deadlock occurs.

This does not make any sense to me. brcmf_sdio_download_firmware() is 
called from brcmf_sdio_firmware_callback() so they are in the same 
context. So #2 is not waiting for #1, but something else I would say. 
Also #2 calls sdio_claim_host() after brcmf_sdio_download_firmware has 
completed so definitely not waiting for #1.

> I tried to release the host before the firmware is requested, however
> parts of brcmf_chip_set_active() needs the host to be claimed, and a
> similar deadlock occurs in brcmf_sdiod_ramrw() if I claim the host
> before calling brcmf_chip_set_active().
> 
> I started to look at moving the sdio_{claim,release}_host() calls out of
> brcmf_sdiod_ramrw() but there's a fair number of callers, so I'd like to
> get feedback about the best course of action here.

Long ago Franky reworked the sdio critical sections requiring sdio 
claim/release and I am pretty sure they are correct.

Could you try with lockdep kernel and see if that brings any more 
information. In the mean time I will update my dev branch to 5.2-rc1 and 
see if I can find any clues.

Regards,
Arend
