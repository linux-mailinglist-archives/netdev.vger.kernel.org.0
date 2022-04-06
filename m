Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE64F63EA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiDFPjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiDFPin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:38:43 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6593D6FC2
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 05:54:22 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id x131so3814031ybe.11
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 05:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d/5NdzDtbs4HcCfOKngCnmL8pC8c/tSKojHWnsVBhiY=;
        b=KL/hSXFsqae+CWgWqslW4dRaiCsTXrJ0JziFgRGvU7KA0w2FMsUAgaoBwpFaejSW2B
         ORvYmsISU4yKE/IcHi5m8HUrGOEMTOX6ZfeEnQmwBnH1uv0J/xSrtNp9iyF8OS3AMimC
         6QeOVKrFVR6wNTTpm1bbyupsX1B8wDxaNS2oOrC+YWniMJMxXHgUckIMnCiAoZ1xFSet
         Oqz6uSTf4of19S50Yj2EY/y3JgFWKXA0N8TNGSrCt9KTP3XBb8MpF1dLEDKEiNmR/kAm
         v/2NTPDFDkUseJ5Vb0IARifMrdyQ6cSMWVBOxHDN33ZSSbfcOM4b0juhkfU1731NyNVU
         7czw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/5NdzDtbs4HcCfOKngCnmL8pC8c/tSKojHWnsVBhiY=;
        b=CX/xqi3Rr5iNFslyWAem8cXmQWeVBBsocpFVaZ/0kJnFyXzIn4jHVOS50NmWFu5lIf
         sGTm5jnWPc7a6NT+GQEzAlfUYhg0acDf0Xr8B8KBNjMzaAwv5AgJ4rIZ6INFGHHNp3LH
         4SftUejJQG1WgdHnIOGCeEdt+1ToMfuDkBwqGX2NPoXzroLQS5AY/qzNjQPvCaGKjibL
         fPZqLAZxjrRT+RtMrfe63PyFqWCOHwr3Z+AjApexct5thqPZ1+Y05zNW8alJHHd5GpEr
         dJmhtJGGAVGbm5KjCmPTWNdfwm3TZKa2p1wHUN9SB5gqW6QW3IAeh2mai2e/u9tX9bq2
         0x3A==
X-Gm-Message-State: AOAM5331rExHmExq81uqXjdZ7h+NiehlSa7URMD1Ulb8IDzGRx/Xlfar
        AGillMPwGEI5ObCk0IKmbwko6ZQ0WcHZXjuwzr9E1C3MdfQ=
X-Google-Smtp-Source: ABdhPJz+P58m2oyUu6fCFqcCWVRNzpqk5dRtPq3bQXoK+A5BVRjs4XTb+mn3wNzWVWhlpersEOe6MoSmAaZcweYXbkY=
X-Received: by 2002:a25:8005:0:b0:63c:92dc:b983 with SMTP id
 m5-20020a258005000000b0063c92dcb983mr6514478ybk.60.1649249662225; Wed, 06 Apr
 2022 05:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2Mb9zUZZFaFLGm@lunn.ch>
In-Reply-To: <Yk2Mb9zUZZFaFLGm@lunn.ch>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 6 Apr 2022 15:53:46 +0300
Message-ID: <CAC_iWjLD8_PsC=AHqR+FeH3qA-TWfWRDfah+7QHXS6dGx7AJPA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com, jdamato@fastly.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

On Wed, 6 Apr 2022 at 15:49, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Apr 05, 2022 at 10:32:12PM +0200, Lorenzo Bianconi wrote:
> > Introduce support for the page_pool_get_stats API to mvneta driver.
> > If CONFIG_PAGE_POOL_STATS is enabled, ethtool will report page pool
> > stats.
>
> Hi Lorenzo
>
> There are a lot of #ifdef in this patch. They are generally not
> liked. What does the patch actually depend on? mnveta has a select
> PAGE_POOL so the page pool itself should always be available?

The stats are on a different Kconfig since we wanted to allow people
opt out if they were worried about performance.  However this is not a
10gbit interface and I doubt there will be any measurable hit.  I
think selecting PAGE_POOL_STATS for the driver makes sense and will
make the code easier to follow.

Thanks
/Ilias
>
>           Andrew
