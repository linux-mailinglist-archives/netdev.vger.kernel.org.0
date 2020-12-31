Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311AB2E7E3B
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 06:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgLaFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 00:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgLaFXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 00:23:37 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD7FC061573;
        Wed, 30 Dec 2020 21:22:57 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 81so16348005ioc.13;
        Wed, 30 Dec 2020 21:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RIc44+c3YEkg/IldDEKf0sBTUdVnrPFU3OYUl/jyWMQ=;
        b=ESONkeY34QnDOUXJGNPrRPqfRE+cE7h5CX1YsyUv2MldHKKA8ZakrfIcqcwGsjJtYX
         FFE/1oHNNwpQ7O+DW5ZjsLSeSwSP1UBUBsC1Pb7OnJkS8yDl3TVFEOJW7ynl99HNN6TU
         fMnMXxD0vVTEKgK+7ZeSuiqpZLsEt2GjMHJ6aplUqeV6xnx4onafP49pBsOOu7Cym+cn
         YCv2E5NhpSk8MI7IwH76cu6QQBM1Q2U7HSlKQJyZ4HKeVypsHO8jon5AOeXkhr3EjBIq
         maaBXDPDyawGt29XGbgqgUQmmb3PeG2ejzU7d3ADNPBQ7JcyYkWh6vfV2tiwdE5p/8dV
         M1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RIc44+c3YEkg/IldDEKf0sBTUdVnrPFU3OYUl/jyWMQ=;
        b=M+wdcapUEiKIhxYNEPyBxm4MLaXoKC9t1/qNo6CfQk29xEotcWIVjIzHtjNRbJnVEV
         jltG4W4IBxyQzX2Uo+fO5CFckGs6sbz3Jcz2vwQbzf5X9qusYeXxrXMtCJZ5mYyThstR
         Y+YdwkDxe4hj0gNE9Yf8747p5mNdrdOaJic9hKh5BbE9UqZZlCrBBGditCyO7AqOXBvK
         wj77dmwbluvivctKUI/kM3BifGsPgTcl+094NwU/+p5xUb5eWX9r25+Fhu92sAHHF0Jk
         pAP5urbf4KFg6TvCndtcV5zmu9nHZqzsaJwkbsShEZTvfhvqIqk/S7o335Fmv8rByDlo
         4rEg==
X-Gm-Message-State: AOAM5326YyBjwXDmKk4LpUW2mkWXNsDg1gYwlXVTo79He9tqU8ggJUu4
        LJ7/YlwTPB4hnYEafMpax9nvCLwHPrIramPph9M=
X-Google-Smtp-Source: ABdhPJwfipLZx3LyzC+ygC3KwqfO7kYf13xkgSdzq7BNPbgGYZlRD1E2aKTFARNjoZT68sUTm7xmpmLC0yy38dn0wMw=
X-Received: by 2002:a6b:3115:: with SMTP id j21mr44671212ioa.55.1609392176219;
 Wed, 30 Dec 2020 21:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20201228094507.32141-1-bongsu.jeon@samsung.com> <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 31 Dec 2020 14:22:45 +0900
Message-ID: <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 6:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Dec 2020 18:45:07 +0900 Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > A NCI virtual device can be made to simulate a NCI device in user space.
> > Using the virtual NCI device, The NCI module and application can be
> > validated. This driver supports to communicate between the virtual NCI
> > device and NCI module.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> net-next is still closed:
>
> http://vger.kernel.org/~davem/net-next.html
>
> Please repost in a few days.
>
> As far as the patch goes - please include some tests for the NCI/NFC
> subsystem based on this virtual device, best if they live in tree under
> tools/testing/selftest.

thank you for your answer.
I think that neard(NFC deamon) is necessary to test the NCI subsystem
meaningfully.
The NCI virtual device in user space can communicate with neard
through this driver.
Is it enough to make NCI virtual device at tools/nfc for some test?
