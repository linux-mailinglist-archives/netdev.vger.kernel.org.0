Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70AE4E5725
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbiCWRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237903AbiCWRIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:08:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0E574DD7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:06:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so2454993pjf.1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXZo6ZCMxvR2wI9wR3kaNle0BThcFCe2JNx/cU3GJL8=;
        b=TeNYFVOsIc7jS+zi51ONM9O06chEwBHgo2dAXG01JvKGh/0wydujNfdFhxSjlJCzG6
         Pl22CD++UULu5i00mN0QSliaRg+rRLRXFquxP/yPxM/xrErnrCO+5FovFzVkwyEEkVVM
         vO7cxPm8zVaLMGej02OwpiQqpLsc72cohOSaMO7AKlLGuim5DSU0Zho1ftDUZC0l5Qqt
         jVwNIrxvz+I3Wpszi9gZZOzxgqF/ZjbXrjoigpqGpqF3nCpfEzVRPOi5OPzr/5FSopG8
         qdgbVkjXmGWUk/iF/26gW3xbXxYKtA6B283qd6eXwR99qcmQ9YL+H9jNclbu9t7hh2mH
         BUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXZo6ZCMxvR2wI9wR3kaNle0BThcFCe2JNx/cU3GJL8=;
        b=CC2dj7dQ5kznKv66k+Izu9CxzZXAA2jw9tzTXJGsjVDsdr9snOZlfZTKuLwNNaEtna
         dCffw2WwHX1bBhHTXzXog1B3vF+enNYvRhaKZyqtrCfirSnrRBt7B4SmHvyGB2neQZI0
         fthadBwLUneqC6DRgmi6LvBMsWSxs29bBxxkN431nH5mx1ey4Hl6C6nqA3DIUueOO3D8
         mGrrvCFOaUhMuX6QkWsLKYkfiBpYUWQOl9GjNrJApHsbfj43g+/xrkPPdcaiLDOTPZDB
         ksDPU9G05KGHRKnNxBO3FzW0p56bqeelvvawZMZ5HV6nowXL0ciULqNjHzhIsVC8MC17
         LS5Q==
X-Gm-Message-State: AOAM533FxTQwTesFsziRqjJZdUlbpNxeNAYPs1/tXpI/o0CXCr1I/F1Y
        iYTqZ+F59BVJUlXN5j1pACs2qqpLeFie3LhpkIWW5g==
X-Google-Smtp-Source: ABdhPJxrcU5e3z/zDo4jv/QLntdvinC7EmFQDSZGAHoYNXm2giTyynNWq3AiGNgqpAPIoA0nRf58W4wI6V7r92YiPtM=
X-Received: by 2002:a17:90b:1d8d:b0:1c6:fad4:2930 with SMTP id
 pf13-20020a17090b1d8d00b001c6fad42930mr716587pjb.159.1648055199780; Wed, 23
 Mar 2022 10:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <1eb3d9e6-2adf-7f6c-4745-481451813522@linux.intel.com> <CAHNKnsQMFDdRzjAGW8+KHJrJUnganM0gi8AWmBnF1h_M2RSLeg@mail.gmail.com>
In-Reply-To: <CAHNKnsQMFDdRzjAGW8+KHJrJUnganM0gi8AWmBnF1h_M2RSLeg@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 23 Mar 2022 18:06:03 +0100
Message-ID: <CAMZdPi_veiVaQYBcu9o0GqbmUcYtkL4NawOo2AGPKxfmaNrdhg@mail.gmail.com>
Subject: Re: net: wwan: ethernet interface support
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
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

On Sat, 19 Mar 2022 at 19:34, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hello,
>
> On Sat, Mar 19, 2022 at 6:21 PM Kumar, M Chetan
> <m.chetan.kumar@linux.intel.com> wrote:
> > Release16 5G WWAN Device need to support Ethernet interface for TSN requirement.
> > So far WWAN interface are of IP type. Is there any plan to scale it to support
> > ethernet interface type ?
>
> What did you mean when you talked about supporting interfaces of Ethernet type?
>
> The WWAN subsystem provides an interface for users to request the
> creation of a network interface from a modem driver. At the moment,
> all modem drivers that support the WWAN subsystem integration create
> network interfaces of the ARPHRD_NONE or ARPHRD_RAWIP type. But it is
> up to the driver what type of interface it will create. At any time,
> the driver can decide to create an ARPHRD_ETHER network interface, and
> it will be Ok.

Agree, WWAN does not require a specific type, so you can do whatever
you want in the newlink callback.

Should a modem/driver be able to expose mixed interface types (e.g. ip
+ eth), in that case we probably need to add extra param to newlink.

>
> > Any thought process on TSN requirement support.
>
> Could you please elaborate what specific protocol or feature should be
> implemented for it?
