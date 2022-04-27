Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B410E511D1D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbiD0Qfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243292AbiD0Qfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:35:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BC84756B
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:32:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j6so4449522ejc.13
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q41bqyLlL7hPXduYbmY5BzoboqsVJJ6ZlIX0KeaPYrI=;
        b=Fo4CEXRrVm/yIWIcw4bfw946DQxBIDnRxllNfClU7aBxmOIQh5R5uEJoKn7a7sIwyq
         ETd6unlt/V+54iU5vd7qeVCCM5XwxJ/aqY8VnOTMczccNLhZmEVkXhoWEy/egsmdBZmb
         IlqEdKs0xTt/IFt5UQRYIGSaemYdKy8Vw+L4QGKjpdg1znaooRcWDupvIytE3XDLtLNt
         XJiSEGGqFQ39N8niByNPCL/yjdrLIN7WvD6C7Go9F7jG09fDNDelYbofI3gHDM74i08e
         QBA24wJ+ll3C2nfk3Ung7OB+j8zzoEVweSDKObpoA6rIafVLiXrKLCyoIU/H4T/Wle0v
         O/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q41bqyLlL7hPXduYbmY5BzoboqsVJJ6ZlIX0KeaPYrI=;
        b=DIzPcOh59sfDvn4Dvd8B2MO1Oigj5KmplZ3L0ZZyOJfTuikDyf2LPUQuilMcg+vnBG
         qpAnEZExH6D4W9dHkFPo3qW+OvoTAL3fQO70bhTkTsMxZjufDpd4UI63MAjllc0FSLIO
         8d2neIk9UxPaQXSelqbfUtmPfPZtodzkdWRzllhIRPedNZylez/oUJjb2jdxOJO7vbM8
         eaJDIKfat871kPrb7cVzGA+d0B89kAFzSozHghQnw17sijYJnpC4LyL4cE9icPI2BI5v
         QktUpCnli8J5gg8V5wsjH51m6/u04Gh2/m+IjDoQse9PS3j5XTw4C2Bj9SyWkBoK8xO3
         4ndA==
X-Gm-Message-State: AOAM530XO9ug4lpCFClAcrV77NKoENpjYwK6+sL42dB2HbYmSvpeJD70
        vHxzX/C8C41wfD19tIXyGbrADBpxfZ/2AkCw3vw=
X-Google-Smtp-Source: ABdhPJwjoykaWIY0RrqkOkHQjpGdHvUWqS4bCMpzUuBRMQ6HZXaXAPSiWhc809aN5Dq4UUSZOIiJs0YGCtEbUdnIMwY=
X-Received: by 2002:a17:906:3799:b0:6ec:d25:3afe with SMTP id
 n25-20020a170906379900b006ec0d253afemr27578363ejc.44.1651077158078; Wed, 27
 Apr 2022 09:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220427162145.121370-1-f.fainelli@gmail.com>
In-Reply-To: <20220427162145.121370-1-f.fainelli@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 27 Apr 2022 18:32:01 +0200
Message-ID: <CAHp75VcFqPV=2Lp7DsxYbD-YSKggCjo=s9vonAmbG1mZLR-ugQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update BNXT entry with firmware files
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, michael.chan@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andy Shevchenko <andy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 6:21 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> There appears to be a maintainer gap for BNXT TEE firmware files which
> causes some patches to be missed. Update the entry for the BNXT Ethernet
> controller with its companion firmware files.

Thanks for adding this!

-- 
With Best Regards,
Andy Shevchenko
