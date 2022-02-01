Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3874A62E6
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiBARsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241727AbiBARsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:48:20 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EA4C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 09:48:19 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s9so33474228wrb.6
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 09:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6I2MDfXZM/ijINJaNqnKNQNLPVtI5DKxUk5DogrUeM=;
        b=4BxCY5wOXFYdOPuo5KfsqT+1YU5gHrEbBAjSNg4XWTds09AtBLiwVGDrpV/cWXaO83
         zL1Ur0M+6k8h52Bj8dC7xX8KhcH4xqhedjCZu14pH9/slCrqjSnJHzdduBdZUfhBh+pJ
         N5co2dN8TFxXyXWsewuxzV6egTAbeG8zM6Ht34/i9BfMsftrd/MLcefrphlse2bPG/l9
         PgrDRB7AsvHaLpdTyurSneoTzfcxMpWGl3HCzW/46Psr63UOvXjSh0xMY/aaGtKt3g5p
         xLhScGIcIkbRydLOll9eLeKPBiJfsFaQKj7M7c9ObElQ51E9pOEdp9DDSAHB72T/rErD
         cB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6I2MDfXZM/ijINJaNqnKNQNLPVtI5DKxUk5DogrUeM=;
        b=kP/Vfg4UjfnmWcXsBNFZA++djAFrJ43psOF78dOvr3GhT1hpplh1VovzunnPbS1XAt
         n58vIhyCM496l04UZ1/qbVzSECBIje9vtJpkzhqGESWytki61smeBVBDeHQCPKJ4r9qj
         wfT6yexVAK64QiTo5sSYUp7yi/vB1mHl3T3aPsGPgTokZ0USHV19YgIRJwsn8NCn8KCa
         t5ATySEuKB9KyYv8BEdImsRSvBvkG9mco0fVtqslJM2ytDdU7qv8++Pwdsvf7nZvbwO1
         oO874OYGyAIRtj0XmdRVwbqRN8NuaZFxQ6HeKvMwYVQep3WYhtAN+cQza45MiMjdpiw6
         Y1EQ==
X-Gm-Message-State: AOAM533Le2Z4iw7CI83w9hC5FiiAN4fqNPIUfc3xsC1vHl5gufkX54Ea
        3/2fHNnl8sC0Gn6v5B+sm4rWJPJ4pT8GgmE33d2RHE0AHzKfGD/k
X-Google-Smtp-Source: ABdhPJzT1ShdRO9pruOWOJhfZSOjFCABWSZ++HK006iSFd5h6Dxi+qUpKZlKTlXxehjDCOkp+FlqwFC6FzfSPxWHLlE=
X-Received: by 2002:adf:ed42:: with SMTP id u2mr21920858wro.57.1643737698481;
 Tue, 01 Feb 2022 09:48:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643225596.git.liangwen12year@gmail.com> <57492c3d29c42235627777d739b0b0f28ba60a36.1643225596.git.liangwen12year@gmail.com>
In-Reply-To: <57492c3d29c42235627777d739b0b0f28ba60a36.1643225596.git.liangwen12year@gmail.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Tue, 1 Feb 2022 14:48:07 -0300
Message-ID: <CA+NMeC-hSzrtt3sDL1cgYf3TZJvAaa7EFy_r0MOgn7BxRaTkPA@mail.gmail.com>
Subject: Re: [PATCH iproute2 v5 1/2] tc: u32: add support for json output
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, aclaudi@redhat.com,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 4:45 PM Wen Liang <liangwen12year@gmail.com> wrote:
>
> Currently u32 filter output does not support json. This commit uses
> proper json functions to add support for it.
>
> `sprint_u32_handle` adds an extra space after the raw check, remove the
> extra space.
>
> Signed-off-by: Wen Liang <liangwen12year@gmail.com>

I tested this patch with tdc and can confirm it passes the tdc
tests.
Tested-by: Victor Nogueira <victor@mojatatu.com>
