Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503FF3D7F2B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhG0UXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhG0UXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:23:36 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E36CC061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:23:36 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id a14so537901ila.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0veg4OhcIu83SoqQBuws6ehx9mJPPKvc3XL9uleaC48=;
        b=MoyTvh+G/MTb8d6eWrqMAuQCZE9ctJmszsuviAQxd1y4o6VPS/vMhcGA/LTHl+SKnd
         qRL9BYZ4EGkxMIs74QRzJVEB87aZ4R5G6seJxTh4OYcqO704bmaPt4g1qkGew7Mh8klL
         x6stsABRfPIag6FLrvAPIBNW58ZG0dYv0L69NEEacX6+vAJh59+eBS22xcuxfTTbsAw5
         uvLNKktIdCR59Vqa6WYGIKknHp893KJ7Y3rY807vZyHm73fZZ094TNqqWvFzMhy94CF7
         rHlvP7R6vTdH3dfggNtX9E351Gad6gbrPK8n12NCW8pOmiJoDYnLtyZL7CJ1tDcVs53h
         VB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0veg4OhcIu83SoqQBuws6ehx9mJPPKvc3XL9uleaC48=;
        b=nQ2O+s3IDvTM9uDEtzhcFFrrHHI9Kn6j3mOcflR3LWNmfZmi+P5vUZTqY4ZApuzIcY
         n3aXPCZLVHA90H2lYFGWmkjO6YzYzmltiy3FrIEXMFpfh77jiaRTViGCJcDzEmHfYP/z
         +JVuRXEIF7rD6w3RdrluP8LgnHMHlPIOh7hmCSnHlH/HRosVv+QKyC7o3JwN09GrkXaz
         Vi6MWMRagfxZU1DJcpjHZfgQk6Vex3cDsSBOZQyn/9EADRkfXH0Y0aZolmDSo3PSh4db
         jjphIEztIqrDzdpaehJIfJA6y0APLfgHD+sL0KWLcn6GX5CCpVb+LDmX1N21I/fvm9NV
         k+Yw==
X-Gm-Message-State: AOAM531t/8L4rUGRAAV6sYKFy2DznGKDO+xXUHEOpOu9cK2g9C3db0fV
        OTKrPyadmCxgrvZBJFOckBOmGWtxjplotiKz4Xsz3g==
X-Google-Smtp-Source: ABdhPJwyn1+KieJXxFrh07ratFEci7W+OFnJhuVejmFQ7dIMx+ghoTG/bIaUHQtJbpPkcaThC1J71Rot+FC6mCkv928=
X-Received: by 2002:a92:d2ca:: with SMTP id w10mr17094433ilg.38.1627417415656;
 Tue, 27 Jul 2021 13:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com> <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com> <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
In-Reply-To: <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 27 Jul 2021 22:23:24 +0200
Message-ID: <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Rob Herring <robh+dt@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 10:18 PM Rob Herring <robh+dt@kernel.org> wrote:
> > The evaluation platform is based on ZCU104. The difference is not
> > only the FPGA image. Also a FMC extension card with Ethernet PHYs is
> > needed. So also the physical hardware is different.
>
> Okay, that's enough of a reason for another compatible. You'll have to
> update the schema.

Ok, I will update Documentation/devicetree/bindings/arm/xilinx.yaml.

Gerhard
