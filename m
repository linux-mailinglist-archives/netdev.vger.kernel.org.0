Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8F4559670
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 11:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiFXJYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 05:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiFXJYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 05:24:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E3B527CF;
        Fri, 24 Jun 2022 02:24:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so2261387pjz.1;
        Fri, 24 Jun 2022 02:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p14Bfq9lY4E0mMUKXgjLwooAfP080X4T8JGy7RTxKZM=;
        b=lHDIN4xQd45EmpZM7fq4IL9dsmpTHiI8Zc/DJNtgSUrfmKxhW0GgUEzB/hyZ3jBY5G
         lXCLmxPj38MqXU2j3mWBFl7R4CfEfEb5/4GG0onF9h81SalHOJg4oYvZCNR5OxVAC46y
         B1oCha0DaN1abqTpotJ9CgIk3KaydpAcZzeUKvTFpjDq3SlqQVjnsLXlNCCdHL5GtXW1
         ORwNLUEJ5lc+UqvP6Riemu5U3stAEDbxAEE2iU5mt331AOO0xTFeOjUSAj8jdbwV0hiV
         0lFiuhdxdU720+fwoLj+AgD3Xc9g/2DIWv+YfndlvPj0pNNjWK4XNau6xb+PpZw30Fd9
         TGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p14Bfq9lY4E0mMUKXgjLwooAfP080X4T8JGy7RTxKZM=;
        b=Gp1xSQ2yfrS2EMlA/Dz1G/yjDkTCApzssBKDAAaI6qui81xTdNpMylRbF7pjZom/KR
         FxEiexXqogpLvePwqz1RNg/Tidd+kC9TDQHBQlBSbyMDRudlAvZH8Y4wgxENpur1P+I0
         iXO/MgzjmAbxPAjrAXyz6144mxGekUJCKW0/Ofv2tgZ9hRw5SFpNDBCxufxP6iIrX+Lf
         zW+rl1YmrOFcmWSjOLeey1+RPFj1KcTdf7pXXnyF4s4k4RpBmuEctuUuTPaBQ06AHnVV
         VPR93avESdJ4KRmtXrQULxNQCEDYmkzvelrjwyqCJ70H3lhfkBUdh1d+zfPN3SWGsUk2
         oNtA==
X-Gm-Message-State: AJIora+dziA+TiKWMboLValzCESTb332HBX/+SUOrN7OSyWbMeizt+7i
        v1F/gTBD5baIUDxE3ZPUpCNkLOENzq4Xxl+GlHw=
X-Google-Smtp-Source: AGRyM1s94mr/vCjmKyIpDLw/LlzwwUyBZvmU+bavLdyTktJk7cdNYN4G0wPiDr6/y8zQCBcfaNl5lw==
X-Received: by 2002:a17:902:b597:b0:168:d8ce:4a63 with SMTP id a23-20020a170902b59700b00168d8ce4a63mr43813256pls.57.1656062646212;
        Fri, 24 Jun 2022 02:24:06 -0700 (PDT)
Received: from [192.168.178.136] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id w4-20020a17090a780400b001ec732eb801sm3492056pjk.9.2022.06.24.02.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 02:24:05 -0700 (PDT)
Message-ID: <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
Date:   Fri, 24 Jun 2022 11:24:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related
 functions
Content-Language: en-US
To:     Paul Cercueil <paul@crapouillou.net>,
        Franky Lin <franky.lin@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220623124221.18238-1-paul@crapouillou.net>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <20220623124221.18238-1-paul@crapouillou.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/2022 2:42 PM, Paul Cercueil wrote:
> Use the new DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr() macros to
> handle the .suspend/.resume callbacks.
> 
> These macros allow the suspend and resume functions to be automatically
> dropped by the compiler when CONFIG_SUSPEND is disabled, without having
> to use #ifdef guards.
> 
> Some other functions not directly called by the .suspend/.resume
> callbacks, but still related to PM were also taken outside #ifdef
> guards.
> 
> The advantage is then that these functions are now always compiled
> independently of any Kconfig option, and thanks to that bugs and
> regressions are easier to catch.

Reviewed-by: Arend van Spriel <aspriel@gmail.com>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
> 
> Notes:
>      v2:
>      - Move checks for IS_ENABLED(CONFIG_PM_SLEEP) inside functions to keep
>        the calling functions intact.
>      - Reword the commit message to explain why this patch is useful.
> 
>   .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 38 +++++++------------
>   .../broadcom/brcm80211/brcmfmac/sdio.c        |  5 +--
>   .../broadcom/brcm80211/brcmfmac/sdio.h        | 16 --------
>   3 files changed, 16 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 9c598ea97499..11ad878a906b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -784,9 +784,11 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
>   	sdiodev->txglomsz = sdiodev->settings->bus.sdio.txglomsz;
>   }
>   
> -#ifdef CONFIG_PM_SLEEP
>   static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
>   {
> +	if (!IS_ENABLED(CONFIG_PM_SLEEP))
> +		return 0;
> +
>   	sdiodev->freezer = kzalloc(sizeof(*sdiodev->freezer), GFP_KERNEL);
>   	if (!sdiodev->freezer)
>   		return -ENOMEM;
> @@ -799,7 +801,7 @@ static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
>   
>   static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
>   {
> -	if (sdiodev->freezer) {
> +	if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {

This change is not necessary. sdiodev->freezer will be NULL when 
CONFIG_PM_SLEEP is not enabled.

>   		WARN_ON(atomic_read(&sdiodev->freezer->freezing));
>   		kfree(sdiodev->freezer);
>   	}
