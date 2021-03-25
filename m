Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15462349A47
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 20:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCYT35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 15:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCYT3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 15:29:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C69C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 12:29:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id e14so4761600ejz.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QRiMS0/8/nxHNtbg0/fowMiQmOjZ2YDBnMskonsbT90=;
        b=S3B+5GYUskR7AsJHdo9KZFF3HmgJWVLjWrxDCqCmCIWvWXClyG5qgEkqvZk6Le5jhM
         KtJ7NibFQmNaYafAgjqCDlmly95gPEMPXRFhtY2NtiCt8B8kzPpCOGDh8+bJK5V7L6ui
         UEk2B5uhLtRLHf/i7Ywaa+EjfuQaE+f7/PcGvbrSuV/j8cteJY9ljdt/eGft8fdwuaxO
         fs8xPzXF3eh3X3Yyd9LjcJd566yrTj+gxnBx7Mg7/7bqliM8d8Puyc0br52qDGOYjI+S
         Nes67OYspBTV5uzUxl0gNUKsEK900BG1M8MtuB/jU9YHCxXG1tp60DOI+gTR7oOIiiZC
         B0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QRiMS0/8/nxHNtbg0/fowMiQmOjZ2YDBnMskonsbT90=;
        b=JAVNhkGTAdH2hAjRiP1vShYZCZjwflTqa4RsAoOVgbokyxRV8CPArE3gwRTq3gZ70i
         4h2P5HpPS5bikHiMEv4EK0r60PcBhmk8IKTfNtWaugCfEh/+F1ruHy2q56MqzI/IEfFh
         fDpml0lrUmSH2ijJY/bA1ssIPJGoOMXol2l1kW/hVzCxnabWy64TCA1L9UuL6gWmtrD8
         TIgJNHEPlTw1xcW5VitS65MLp+a9I3ULaptiNLyK7Y5reKs9RAEcfi4dlT2v8oIJoKGd
         gIRWwpobWxjgQXlJVGCceEt/9bVIO//ksIGnfDjCtGnGkL35H6nFu53iwNceXWHbOmBn
         cAbg==
X-Gm-Message-State: AOAM532jYzWzZQxOOFj56+eEwgHYhULp1ChiqYmZAKFMDNxtrLJl9KJr
        T/bPkPiY5Ovq+RPFZzmvoN9XuJGFJj7Zv58T4w4=
X-Google-Smtp-Source: ABdhPJyWQEcwHYcEOXEmydxiofWUCzyj76spiCAIDF+hqomNzVTLfOrRv9JeaU7NTxle30mg/WuxBys8IwVNsn7Q2Ng=
X-Received: by 2002:a17:906:4cd9:: with SMTP id q25mr11170134ejt.187.1616700583098;
 Thu, 25 Mar 2021 12:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf> <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
 <20210324222114.4uh5modod373njuh@skbuf> <7510c29a-b60f-e0d7-4129-cb90fe376c74@gmail.com>
 <20210325011815.fj6m4p5k6spbjefc@skbuf> <4855cadd-8613-e8e0-14e9-a7feb96ba214@gmail.com>
In-Reply-To: <4855cadd-8613-e8e0-14e9-a7feb96ba214@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 25 Mar 2021 20:29:32 +0100
Message-ID: <CAFBinCCrEusRHwQMdKYx2yP-JgC4qkENpG_BCRQ5JHWD9=TEXw@mail.gmail.com>
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Florian, Vladimir, Hauke,

first of all: thank you very much for this very informative discussion!

On Thu, Mar 25, 2021 at 4:08 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
[...]
> > Just to clarify, this port to queue mapping is completely optional, right?
> > You can send packets to a certain switch port through any TX queue of
> > the systemport?
>
> Absolutely, the Broadcom tags allow you to steer traffic towards any TX
> queue of any switch port. If ring inspection is disabled then there is
> no flow control applied whatsoever.
I think with the Lantiq PMAC and GSWIP the situation is very similar

skb_set_queue_mapping from tag_brcm.c seems very interesting.
a per-CPU queue is also very interesting since these Lantiq SoCs have
two MIPS cores


Many thanks to all of you again!

Best regards,
Martin
