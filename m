Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F1109386
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbfKYSbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:31:02 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46447 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfKYSbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:31:01 -0500
Received: by mail-ot1-f66.google.com with SMTP id n23so13469740otr.13;
        Mon, 25 Nov 2019 10:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BCZ9ElPD8Y4mMVCJfLlg/SGue6w7FXoSD8+x6lVDs1s=;
        b=eZGAgP/idKZThrSPvrPiCfLyzW5jhcikm8RwTOJBovl2QwxTySqDFf3TdSkwQODWZf
         Z58I2e/pAks8TePJ51X31q/EBjLxiXkAoSoZObXJrcdCU6bw6c6bx/ASq4AraEi+GyhA
         LXvDEkPOSco4x6Nnl24VLv0Mu9wRCXoH6hhLtkivS8jncZ8Mfph2Kp++lmdJrTULv2Nv
         wBl5OFc2zce81jDsDgNbFoqfCJ5TS+Xuc6CwXfvwOVawGl5ougOnvt5+oXShugSKTJEN
         f6LT4tgp1tzhILnN1/8aw+2+6VE+MtUpWtn8gUrg6FDDS32GrMmj4PfLUKLRTERS4Ryo
         pT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BCZ9ElPD8Y4mMVCJfLlg/SGue6w7FXoSD8+x6lVDs1s=;
        b=eYV3CV0CVTOX6/yEmMQnigtnMR7O79x3FTHY/PvtqhD6yKbc8iVphYd5LZQkP1IZRo
         4w23QQgHNsg/bO9oBVYI4R577cZdI9dcdHNoJDeZ4If2ae9icIkDV8+sokR51rH8Bdap
         7Zh3YNF3lizGzZ2qg9jfcqN4OUFE3qG8XLd9HeJKhLk2lKPquCcTvlNcepz3GptMaFz1
         49gUzgiM5NSKerJEdLzQATcnIuB71HOiybXuV5JxqSDf4hG6kDk4bt77VRLYrCKJ/z+X
         hdNr43R+c+FffHK2czznYfFsIJXYbF4eQqxVSglGv/tPTu2qZxvMgQyipb1Z6MdCJ+Xj
         KLwQ==
X-Gm-Message-State: APjAAAU+60lf2dTqn0GFhI4KinZiJHp+c//InH5wo66B0tjD3E3NiUgF
        kc67nJzSA7LfAF11jy9xmvVV17Vz
X-Google-Smtp-Source: APXvYqzwUc7mU5ZKhRAJscRFaWCmTKKzSUWU3snVxFfwS2r440ohfnEsqHgRCDfXTj/JgGh/mY431Q==
X-Received: by 2002:a05:6830:1e7b:: with SMTP id m27mr21520339otr.8.1574706660772;
        Mon, 25 Nov 2019 10:31:00 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id p3sm2667663oti.22.2019.11.25.10.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 10:31:00 -0800 (PST)
Subject: Re: [PATCH 3/5] drivers: net: b43legacy: Fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, davem@davemloft.net,
        keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191124094306.21297-1-tranmanphong@gmail.com>
 <20191124094306.21297-4-tranmanphong@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8eb8d6fd-de20-2d04-8210-ad8304d7da9e@lwfinger.net>
Date:   Mon, 25 Nov 2019 12:30:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191124094306.21297-4-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/19 3:43 AM, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>   drivers/net/wireless/broadcom/b43legacy/main.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

The subject should be "b43legacy: .....". Otherwise it is OK.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index 4325e91736eb..8b6b657c4b85 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -1275,8 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
>   }
>   
>   /* Interrupt handler bottom-half */
> -static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
> +static void b43legacy_interrupt_tasklet(unsigned long data)
>   {
> +	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
>   	u32 reason;
>   	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
>   	u32 merged_dma_reason = 0;
> @@ -3741,7 +3742,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
>   	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
>   	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
>   	tasklet_init(&wldev->isr_tasklet,
> -		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
> +		     b43legacy_interrupt_tasklet,
>   		     (unsigned long)wldev);
>   	if (modparam_pio)
>   		wldev->__using_pio = true;
> 

