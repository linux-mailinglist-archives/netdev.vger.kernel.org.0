Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C34DA630
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352555AbiCOXVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239201AbiCOXVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:21:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0E95D67E;
        Tue, 15 Mar 2022 16:20:34 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h2so1352695pfh.6;
        Tue, 15 Mar 2022 16:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ekRw2ATyMf5rkDuzQAe8jMuo2YVQkSMwncEmdrJ6loU=;
        b=KrTLefn+KtVs4HCqOB5qAmwjJ5tsqjim3A+K79e2STp5LF0ILoi2RTbxTjZQP0F5oe
         FS0OG1phDhesYW/hMbrEXsjqWkOwz0ArfDAFQpg7dQ7BDRzXZVgdbphwCWjdGvkYIBLn
         pP8Plt2hAuaXi1dK7xxogbl3SXfpKIY40ch9NdY0Qw2dJGR5npIAl9hIf+LUncbti8Jl
         diODsPLt4iQAvLaoJCCyVfTQjBs1uh23/m3djRip3OZ3KtCJ+ZrIJLxe0qb5JkYpMXDI
         p9upcfXOt9bVp7WJMN4QXXKXQKH3zyu1xG5npCTINdOLzUSPci8+BszwPcL0QE+P2bHL
         8lhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ekRw2ATyMf5rkDuzQAe8jMuo2YVQkSMwncEmdrJ6loU=;
        b=ATbCZzcFGJBeRqVGAVLt4hS3H08Dt//29lBjlMq7acdRhgGz1sXqfKkta/2zCcgXYR
         0cU97IN/bNYJfxkDEQ0xXZbhbpFiZTmej8FtujAN+rV8xnFyQpS2Nb2jQsMbF5gVwcEt
         ORDz/DvckbPFMFcTefa0gL6EfVUzZKOWLvOdcXyZQzdSxBTogEzs7SBPbaVoHIR5m0EK
         9CAzhoJUXN/58ikplyLi7WUv15tyIp21NFIlh7ZD030Z7RPYNoBME4SVi0VeITAypCrE
         UeSrDF3kpB8VKRemqdT0nT/4Ls30OD815Z2cFWiaymo+J786nJKiwHiRXRJUItn7oYqq
         maeA==
X-Gm-Message-State: AOAM5314lFgWl3l4zqNXoz3Z2kBKuH9asxsPfNgIgsI5NdI0JKG7K3S0
        AZTN70PsqYotdoRiO5RfBqM=
X-Google-Smtp-Source: ABdhPJxPHpUIZyPNiKza/Mfv7mmtzFpKixLGmNwXqnyx6ktKwcmMCJxfPvdRl59dnvQVOgXEAV2bmA==
X-Received: by 2002:a63:ef41:0:b0:381:7f41:64d8 with SMTP id c1-20020a63ef41000000b003817f4164d8mr1874473pgk.312.1647386433362;
        Tue, 15 Mar 2022 16:20:33 -0700 (PDT)
Received: from [192.168.254.55] ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00150200b004f8d80ced3csm212178pfu.40.2022.03.15.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 16:20:32 -0700 (PDT)
Message-ID: <eac8596b51b7a6f7b02777e126c40cd76ef0f426.camel@gmail.com>
Subject: Re: MK7921K de-auths from AP every 5 minutes
From:   James Prestwood <prestwoj@gmail.com>
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 15 Mar 2022 16:20:32 -0700
In-Reply-To: <CICSX6EXTZ6U.MYGFTUDU5ZKW@enhorning>
References: <CICSX6EXTZ6U.MYGFTUDU5ZKW@enhorning>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 2022-03-06 at 14:00 +0100, Riccardo Paolo Bestetti wrote:
> Hi,
> 
> I have recently installed an AMD RZ608 Wi-Fi card in my laptop. The
> card
> uses the MT7921K chipset from MediaTek. I'm running Arch Linux, using
> kernel 5.16.12-arch1-1. I'm using iwd 1.25-1 as my wireless daemon.

Could you also post the IWD debug logs (running with -d).

> 
> I'm experiencing de-auths every 5 minutes from my AP, which is a
> MikroTik
> RB962UiGS-5HacT2HnT running the latest firmware. This has a AR9888
> wireless
> chip. It is indeed configured to update group keys every 5 minutes.
> 
> All the de-auths happen with excellent signal and SNR (consistently
> 50dB
> or better as reported by the router, which is only a few meters apart
> form the laptop). My router is set up on a fixed channel, with fixed
> channel width 20MHz. The almost perfect periodicity also suggests
> that
> bad signal is not an issue at play.
> 
> The kernel log does not report any messages from the driver. Only:
> 
> Mar 06 12:19:21 enhorning kernel: wlan0: deauthenticated from
> 08:55:31:cc:23:c3 (Reason: 16=GROUP_KEY_HANDSHAKE_TIMEOUT)
> Mar 06 12:19:23 enhorning kernel: wlan0: authenticate with
> 08:55:31:cc:23:c3
> Mar 06 12:19:23 enhorning kernel: wlan0: send auth to
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:19:23 enhorning kernel: wlan0: authenticated
> Mar 06 12:19:23 enhorning kernel: wlan0: associate with
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:19:23 enhorning kernel: wlan0: RX AssocResp from
> 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
> Mar 06 12:19:24 enhorning kernel: wlan0: associated
> Mar 06 12:24:21 enhorning kernel: wlan0: deauthenticated from
> 08:55:31:cc:23:c3 (Reason: 16=GROUP_KEY_HANDSHAKE_TIMEOUT)
> Mar 06 12:24:23 enhorning kernel: wlan0: authenticate with
> 08:55:31:cc:23:c3
> Mar 06 12:24:23 enhorning kernel: wlan0: send auth to
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:24:23 enhorning kernel: wlan0: authenticated
> Mar 06 12:24:23 enhorning kernel: wlan0: associate with
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:24:23 enhorning kernel: wlan0: RX AssocResp from
> 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
> Mar 06 12:24:24 enhorning kernel: wlan0: associated
> Mar 06 12:29:21 enhorning kernel: wlan0: deauthenticated from
> 08:55:31:cc:23:c3 (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> Mar 06 12:29:28 enhorning kernel: wlan0: authenticate with
> 08:55:31:cc:23:c3
> Mar 06 12:29:28 enhorning kernel: wlan0: send auth to
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:29:28 enhorning kernel: wlan0: authenticated
> Mar 06 12:29:28 enhorning kernel: wlan0: associate with
> 08:55:31:cc:23:c3 (try 1/3)
> Mar 06 12:29:28 enhorning kernel: wlan0: RX AssocResp from
> 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
> Mar 06 12:29:28 enhorning kernel: wlan0: associated
> 
> Pretty much the same from the router:
> 
> 12:19:21:
> BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout,
> signal strength -42
> 
> 12:24:21:
> BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout,
> signal strength -42
> 
> 12:29:21:
> BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout,
> signal strength -42
> 
> 
> I have other devices connected to the same access point without
> issue,
> and I can connect to other access points without issue. So I'm
> figuring
> this is an issue specific to the combination of this chip and the
> particular access point.
> 
> I am not able to say whether the issue is in this driver, or with the
> access point. How might I go about finding out?
> 
> Best regards,
> Riccardo P. Bestetti
> 


