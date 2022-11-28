Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC09C63B3E6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiK1VFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiK1VFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:05:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479192FC14;
        Mon, 28 Nov 2022 13:05:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so7039600pjm.2;
        Mon, 28 Nov 2022 13:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SU+7WnCsOrsJPdIThKjzwRaJEylrganO+dqBZ0MQv2I=;
        b=Rgo428enLrnZ5QTJoj0DDi8DlxAZhVr+KuLLLzs+wWsB+P2RjN4RIsNevEZdM8EkXt
         6c6mc5pnJWYICEC1Aqqcl7sMZ2dfEINGQCIbZvJ8/bMFmE8DUYsoZWbxgpia+HVqUTCv
         ov++NLuuHODFIPdNLGKtmyQZK5Ive0K91emIg+mMAkAgG9h3eKVrDsu7gMrUYrwcFCJV
         NOqekjoHh/RjQ2NJIDCbq3J2lGQ2BKH+vrQq6TAuNXZ5aEaC7rgYXTVI16Nm4zcUmR85
         aNieOoh9/Qjx+2X+LjmxUegClU2BazL4oPnKzUklIjkga5iz0XZTbJJRHId+9qblKVhr
         Wx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SU+7WnCsOrsJPdIThKjzwRaJEylrganO+dqBZ0MQv2I=;
        b=Ry6k9l7u9GDqZd0Rc5xW5gSaxbtxuFa0xuUwqhLNn//D1p+/KMeBLwHmAhm7mqz2nC
         Vk1+RspDJso/7f/Xrz/MeI+SOuxjfdpF2/0hoFNJ5GaGq6Pm6qAN4K9hgbvcHe5k+i5+
         Kf2/gcbpuu5dx7hWmIor3DqZkOuczBcynDTj3A9YfzzI9MboIA6qqTdiy6Bfrzkz3UoX
         C0O4jFkAABb/lAX88HFf24aEic56vN2fix9rOViMbECMGKX8PaNEbeyxl64e7Xvb0VZ8
         fQ854nxg+Ty/uyZ5dY2jD07gKodJB/cNxo8EbCHDS4z1XsKPZP2D49a2Q3XZCss9lNMf
         BvxQ==
X-Gm-Message-State: ANoB5pldIIqZ5baBTOXjY/yQSSOCQAyETkAtHSNSLBUZ6sYplXCU6tpG
        jYLs6Th4Fr+XmjQPyp+gCgQ=
X-Google-Smtp-Source: AA0mqf5bBm2Y9SjEVrEUCbtOo3gHYdf1TflTA6seaRp2QvZDqpveB/K/i8wq5FqB0BhYIHKLxHuskw==
X-Received: by 2002:a17:902:e40a:b0:17a:a81:2a52 with SMTP id m10-20020a170902e40a00b0017a0a812a52mr39767223ple.159.1669669515700;
        Mon, 28 Nov 2022 13:05:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y24-20020aa79438000000b0057293b17c8bsm8448708pfo.22.2022.11.28.13.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 13:05:15 -0800 (PST)
Message-ID: <e1c8ef9c-5dce-485e-e363-abba3c1178a9@gmail.com>
Date:   Mon, 28 Nov 2022 13:05:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221125041206.1883833-2-xiaolei.wang@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/22 20:12, Xiaolei Wang wrote:
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspend and resume, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>    Modules linked in:
>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>    Workqueue: events_power_efficient phy_state_machine
>    unwind_backtrace from show_stack+0x10/0x14
>    show_stack from dump_stack_lvl+0x68/0x90
>    dump_stack_lvl from __warn+0xb4/0x24c
>    __warn from warn_slowpath_fmt+0x5c/0xd8
>    warn_slowpath_fmt from phy_error+0x20/0x68
>    phy_error from phy_state_machine+0x22c/0x23c
>    phy_state_machine from process_one_work+0x288/0x744
>    process_one_work from worker_thread+0x3c/0x500
>    worker_thread from kthread+0xf0/0x114
>    kthread from ret_from_fork+0x14/0x28
>    Exception stack(0xf0951fb0 to 0xf0951ff8)
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Tested with bcmgenet and bcmsysport/bcm_sf2:

- suspend/resume using rtcwake w/ Wake-on-LAN disabled
- suspend/resume using rtcwale w/ Wake-on-LAN enabled
- reboot -f (which does exercise the shutdown path which has ties with 
device_links)
- binding/unbinding PHY driver

There was no change to the ordering for GENET, however there was a 
change of ordering for the DSA (bcmsysport/bcm_sf2) combination but it 
seemed to make more sense the way it was, in that we suspended the 
switch first and later the Ethernet controller attached to the switch.

Thanks for your patience.
-- 
Florian

