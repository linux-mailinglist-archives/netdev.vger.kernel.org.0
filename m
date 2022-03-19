Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39AE4DEA28
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 19:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbiCSSgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 14:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiCSSf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 14:35:56 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C16F2986DE
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:34:33 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 2so3910430vse.4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTWEetd1JVa8VqWcw/AyvWe9rS0lTmZuwgDubbkJEkA=;
        b=GZR4batc/MJjNHz5OuFXi+8qbM6fIbwANHOxdcQ4X/ML7G81rTnLQrB+79MNoAVdWv
         xDyfOTKC4Xe906ikonoeI3j5oulD18ZH4HUAQjfqf40qBLVDjnBFz0rkCaCmuDwsmI1X
         ZPcYCumEyIP4UnV2saBgBDzbuEzToqu8HW0+QPpNJ4a1p5p3OuNRPF21xrcfmdSjM/5G
         oWd9wk1XYs3in4Y9yB21hjfg2iQVqcSbsst4Uhsy+lAWnv5ZIDlS7eWhKapdqBc5oYZo
         KKjGySgeueuaIg+oD5jG21xPkbOw0Kz2GxT4F3Vi65Vg3zWeZYT487XB0JVnQSVEmHQO
         CQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTWEetd1JVa8VqWcw/AyvWe9rS0lTmZuwgDubbkJEkA=;
        b=wlyEUvGpVinT0ybepmIN9qH6XIyC2qjRoSuDvx+2kOkW9E2rZBT1bgZAzNVGs041y0
         mBz6XXdkmP3q9wE3Aig7OuvIIGg0xzKiXwn5xYSUkRbAlGx31t2rlJQjomoifC64SjOD
         7HzvQ8P+Qt+t+cPBfzeFcqRkeYbCdacFxPP/ChhBGXGdvLMkOytsK+hdr7IS6+5ggToW
         JXEGTfojCh7vpigAG66JRCrarJSy+R+KATOcHgeYLkmvyzJJtx6Yw/WbF7NAY0siqbdh
         q7+f5P5A98WdNZCGMAV31QFalsxP1IJ5Gi36T+J3tE+o6TRTA8GXAP58RwEs5ojnLAEy
         moAA==
X-Gm-Message-State: AOAM533piKqd85jhtmRLRAdbfBuQgwRu7/Ar9CAsY1Ahnxm2Kzjcx2Ji
        lzgaHv1UwkwZ136rmnTW4PfVKn1RewtaTHwYTng=
X-Google-Smtp-Source: ABdhPJzjAkR5Bm/TJWUZORsvWr3R9k0+F0OzPN4X+IOlMsJ2m3YcNjiXeONYbT1ShdT5D61tWjR5zeQP+1dwT3c0rNQ=
X-Received: by 2002:a05:6102:1489:b0:31b:3dc6:10fd with SMTP id
 d9-20020a056102148900b0031b3dc610fdmr4832335vsv.50.1647714872764; Sat, 19 Mar
 2022 11:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <1eb3d9e6-2adf-7f6c-4745-481451813522@linux.intel.com>
In-Reply-To: <1eb3d9e6-2adf-7f6c-4745-481451813522@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 19 Mar 2022 21:34:23 +0300
Message-ID: <CAHNKnsQMFDdRzjAGW8+KHJrJUnganM0gi8AWmBnF1h_M2RSLeg@mail.gmail.com>
Subject: Re: net: wwan: ethernet interface support
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Mar 19, 2022 at 6:21 PM Kumar, M Chetan
<m.chetan.kumar@linux.intel.com> wrote:
> Release16 5G WWAN Device need to support Ethernet interface for TSN requirement.
> So far WWAN interface are of IP type. Is there any plan to scale it to support
> ethernet interface type ?

What did you mean when you talked about supporting interfaces of Ethernet type?

The WWAN subsystem provides an interface for users to request the
creation of a network interface from a modem driver. At the moment,
all modem drivers that support the WWAN subsystem integration create
network interfaces of the ARPHRD_NONE or ARPHRD_RAWIP type. But it is
up to the driver what type of interface it will create. At any time,
the driver can decide to create an ARPHRD_ETHER network interface, and
it will be Ok.

> Any thought process on TSN requirement support.

Could you please elaborate what specific protocol or feature should be
implemented for it?

-- 
Sergey
