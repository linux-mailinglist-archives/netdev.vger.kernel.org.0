Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39574363E41
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbhDSJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhDSJIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:08:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429D8C06174A;
        Mon, 19 Apr 2021 02:08:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id n2so51702635ejy.7;
        Mon, 19 Apr 2021 02:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=E2UStkxkycqVWBM3ljmhrXF4ipVQOVwrVP4TqeB36Ro=;
        b=XQsx3szzAGh9MuZ7Tv/cQEIGLCUAzCkYCqTrlEn8hE2XRUqAQfe5sZqXNrYbXLoTPV
         ZgodWx/1IAX64P+87vUaT8jBFjY307P5yyVrjruPZZKNaANjVK4sI+TQAbIYhd3+RM+D
         /Y8rEnJ1HiZxtp+w9hezbMwiup6UJli0oYzGEJi581Phg4q7pst9OGp/VoEJNT3Etc1C
         +8QNW57GUIRg2A8NMPhVMdAevblgCn7SlDMBeCPedohl3fUPkJULkI2LL/WF667aUggl
         4ViW26TFV2LEYId/f9PER9uBKyVzSfHd67z1+nKhsrQgu3Z7qwz1LySH3abyC7sIIgNv
         Lo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=E2UStkxkycqVWBM3ljmhrXF4ipVQOVwrVP4TqeB36Ro=;
        b=Kx7Y3QvvLULaLGJjW4ljMnbKHIxKIDwKX1L+eXvMMM/DuQoa+/itopwsfqALJcuVxb
         n1P5UgRWtNWMd2xdNa+2WfnHPgHf/GVAlcXqRrNzwb/uvvKP3C+5gSac287HBAObVHN5
         ysVUvuvJAJS7CyxLFg/E6cv/H2atJ7Jx+v3GuNp15LJYr/r97UlFexagm6baA6M9Zet/
         u4NM/29Px8OlWCzlN0UK0J72XlcJVX7OGod/altYid2OhQgAppZyiZZoZsDjRuqkVgEF
         3O1eUVePwFxkzFpEnyqjtyPeClr3mPXqkGT8td1In6RRnHVmfHZZACo2DiAe4s46+x6q
         v0Bw==
X-Gm-Message-State: AOAM531fKJZzxweuVRjdy4SJLV4czQ1Ta6oM1OdMHVr9iwnwcvB2BLOs
        ntDKbff/f8Xf5rHLFy3Wb4kskDMxVTjJhg==
X-Google-Smtp-Source: ABdhPJzTRCGhZ/dWQFHMWX+wjx7g4wa0hXeIn8is11kO4hWt0yHA+8CovMFkw7KM7IN4R0tVzKmX8w==
X-Received: by 2002:a17:906:5203:: with SMTP id g3mr20446249ejm.95.1618823287864;
        Mon, 19 Apr 2021 02:08:07 -0700 (PDT)
Received: from limone.gonsolo.de (ip5f5ac7f5.dynamic.kabel-deutschland.de. [95.90.199.245])
        by smtp.gmail.com with ESMTPSA id z17sm12397983edx.36.2021.04.19.02.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 02:08:07 -0700 (PDT)
Date:   Mon, 19 Apr 2021 11:08:00 +0200
From:   Gon Solo <gonsolo@gmail.com>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: iwlwifi: Microcode SW error
Message-ID: <20210419090800.GA52493@limone.gonsolo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

My internet was very slow and I saw the following in dmesg:

[Apr19 10:50] iwlwifi 0000:02:00.0: Queue 10 is active on fifo 1 and stuck for 10000 ms. SW [40, 93] HW [40, 93] FH TRB=0x0c010a037
[  +0,001244] iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.

The rest of the message is at the end of this message.
The kernel version is "Linux Limone 5.12.0-051200rc7-lowlatency" from https://kernel.ubuntu.com/~kernel-ppa/mainline.
The relevant output of lspci is:
02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)

I would be glad to provide additional details if somebody is interested
to fix this bug.

Regards,
Andreas

[[Apr19 10:50] iwlwifi 0000:02:00.0: Queue 10 is active on fifo 1 and stuck for 10000 ms. SW [40, 93] HW [40, 93] FH TRB=0x0c010a037
[  +0,001244] iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  +0,000160] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[  +0,000004] iwlwifi 0000:02:00.0: Status: 0x00000040, count: 6
[  +0,000005] iwlwifi 0000:02:00.0: Loaded firmware version: 17.3216344376.0 7260-17.ucode
[  +0,000005] iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[  +0,000005] iwlwifi 0000:02:00.0: 0x000002B0 | trm_hw_status0
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000B30 | branchlink2
[  +0,000004] iwlwifi 0000:02:00.0: 0x000164C0 | interruptlink1
[  +0,000003] iwlwifi 0000:02:00.0: 0x000164C0 | interruptlink2
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000000 | data1
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000080 | data2
[  +0,000003] iwlwifi 0000:02:00.0: 0x07030000 | data3
[  +0,000004] iwlwifi 0000:02:00.0: 0x5440EBF3 | beacon time
[  +0,000004] iwlwifi 0000:02:00.0: 0xF0BCB49D | tsf low
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000097 | tsf hi
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[  +0,000004] iwlwifi 0000:02:00.0: 0x0845CB55 | time gp2
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000000 | uCode revision type
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000011 | uCode version major
[  +0,000003] iwlwifi 0000:02:00.0: 0xBFB58538 | uCode version minor
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000144 | hw version
[  +0,000003] iwlwifi 0000:02:00.0: 0x40489204 | board version
[  +0,000003] iwlwifi 0000:02:00.0: 0x0000001C | hcmd
[  +0,000004] iwlwifi 0000:02:00.0: 0x00022002 | isr0
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000000 | isr1
[  +0,000003] iwlwifi 0000:02:00.0: 0x0000000A | isr2
[  +0,000003] iwlwifi 0000:02:00.0: 0x0041D4C0 | isr3
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000000 | isr4
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000110 | last cmd Id
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000000 | wait_event
[  +0,000004] iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
[  +0,000003] iwlwifi 0000:02:00.0: 0x00010020 | l2p_duration
[  +0,000004] iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000080 | l2p_addr_match
[  +0,000003] iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
[  +0,000003] iwlwifi 0000:02:00.0: 0x15041745 | timestamp
[  +0,000004] iwlwifi 0000:02:00.0: 0x00348098 | flow_handler
[  +0,000066] iwlwifi 0000:02:00.0: Fseq Registers:
[  +0,000057] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_ERROR_CODE
[  +0,000057] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_TOP_INIT_VERSION
[  +0,000056] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_CNVIO_INIT_VERSION
[  +0,000056] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_OTP_VERSION
[  +0,000071] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_TOP_CONTENT_VERSION
[  +0,000069] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_ALIVE_TOKEN
[  +0,000074] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_CNVI_ID
[  +0,000074] iwlwifi 0000:02:00.0: 0x00000000 | FSEQ_CNVR_ID
[  +0,000061] iwlwifi 0000:02:00.0: 0x00000000 | CNVI_AUX_MISC_CHIP
[  +0,000061] iwlwifi 0000:02:00.0: 0x00000000 | CNVR_AUX_MISC_CHIP
[  +0,000059] iwlwifi 0000:02:00.0: 0x00000000 | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
[  +0,000062] iwlwifi 0000:02:00.0: 0x00000000 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
[  +0,000073] iwlwifi 0000:02:00.0: Collecting data: trigger 2 fired.
[  +0,000008] ieee80211 phy0: Hardware restart was requested
