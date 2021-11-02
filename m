Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4860F44271D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 07:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhKBGcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 02:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhKBGcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 02:32:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99671C061764;
        Mon,  1 Nov 2021 23:29:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id r5so14455428pls.1;
        Mon, 01 Nov 2021 23:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=TzvJmrc06NlZ9hske6zTzy76Nfp+Gfs0H2R+cOceY8o=;
        b=CNIpgkxUpkhe2O+aFcTPR3KBcD6LcyfDYTDViZIjnbmRm0drBwWcrnPlXZja92r7u9
         bONFc35Bkm/pifaIrZi1h98Ms92J7GF1ZXcAuPSd4sm9boldZiBNq3EdLiqNSEUBm4pX
         UqqE+Ul0fDUz2sERocCgg3v541wLNLDKxANKutR+2bnIXwyF4bfRVkgB0fpL00Idhbd4
         xMfZwwI0kc1j1rvKeocCdsRq40fOBQ3kV34kbFmY/T69zqVlGJCkeDHzf33skXXCREKp
         vN4zDjhrXdszHHDQSYLoXt6XIOMkM1oJVIWxL1Cnq4GEy7OyaFWAxllc39TRDm1CeuZ+
         tL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=TzvJmrc06NlZ9hske6zTzy76Nfp+Gfs0H2R+cOceY8o=;
        b=KuJEpjbbKn0bTb0opBX6OtLENfHMH/B8awXRbtVgMWv0bkgPA2AXlaKVD0sRrM64JU
         O0rlhn1xKCHfpZi4ZjjeaSiUIrAig0K0G6yrqjOHlmH9ydpZJ3ai66XzOF0Q8C/KxEv9
         wV0Wm8KMKRc/b4HLv73a9Y1xjYQi84vbcWL9fw89enUuxZ0a8xDHoCho6VQEMXX51X1D
         tOt6/9yPC75G0lPJfLiHQNQKtrYAaYhrfGXTq6kw+gcGU2JkPbYmdcRBCyTlhQR4vcjV
         o/pEkjvd2vYh7N8ur5QCMECexJzUnPIeQ1sijJT/Wd6VrVNizZf7tE2zmQtzI/6auvoJ
         bV7w==
X-Gm-Message-State: AOAM533q9QrAkGQfFRJVrxG7XFzFcPLjRXLJ12PXNDU/HvWVYWh1Oca9
        HMYWM0qz6YUmwCVrI081CZYcchuzIV4=
X-Google-Smtp-Source: ABdhPJxCi+/d9B4gmP7dabpk3nBcb1peIZN4awU1v3vfqWKL/7NZFl+HFTZ9o+r6O+gThYkqJIjs8w==
X-Received: by 2002:a17:90a:e7c4:: with SMTP id kb4mr4406007pjb.237.1635834567906;
        Mon, 01 Nov 2021 23:29:27 -0700 (PDT)
Received: from [10.1.1.26] (222-155-4-20-adsl.sparkbb.co.nz. [222.155.4.20])
        by smtp.gmail.com with ESMTPSA id b18sm1046170pjo.31.2021.11.01.23.29.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 23:29:27 -0700 (PDT)
Subject: Re: [PATCH v8 0/3] Add APNE PCMCIA 100 Mbit support
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
References: <20210928065825.15533-1-schmitzmic@gmail.com>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <34a0deea-2784-10af-841a-eaa9d7ef5f7f@gmail.com>
Date:   Tue, 2 Nov 2021 19:29:22 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210928065825.15533-1-schmitzmic@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore the earlier ping - this one's the correct one.

Is there anything that I can do to help move this series along?

Cheers,

	Michael

On 28/09/21 19:57, Michael Schmitz wrote:
> The first patch enables the use of core PCMCIA code to parse
> config table entries in Amiga drivers. The remaining two patches
> add 16 bit IO support to the m68k low-level IO access code, and
> add code to the APNE driver to autoprobe for 16 bit IO on cards
> that support it (the 100 Mbit cards). The core PCMCIA config
> table parser is utilized for this (may be built as a module).
>
> Tested by Alex on a 100 Mbit card. Not yet tested on 10 Mbit
> cards - if any of those also have the 16 bit IO feature set
> in their config table, this patch series would break on those
> cards.
>
> Note that only patch 3 has been sent to netdev. Please CC
> linux-m68k when providing comments.
>
> Cheers,
>
>    Michael
>
>
