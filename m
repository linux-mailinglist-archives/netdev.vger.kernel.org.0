Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30124C1A1A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbiBWRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243487AbiBWRpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:45:47 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5434641626
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:45:19 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id f11so18016731ljq.11
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1xMudg1aO+vDV8gtsvJkLSGnB2p7ARyyZXhKa7RZNgM=;
        b=vUprQDNBr/k/6JKgcaUPkM0l8ab4NlvxMLyq12yJMm4tXHMGgfyyQom9m9S6QdI8CG
         3+QYqmlydFnBKd4L5I711pDdLb0zNuMo6tkz4OkXrTzFknRhf6VGxTxmYc2OezPsNo4R
         5lm9JlEts9xqe61QkNrOtkOtbE+PgHxzf3gF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1xMudg1aO+vDV8gtsvJkLSGnB2p7ARyyZXhKa7RZNgM=;
        b=oGybA47RwQr5dBKejm9hzgdksHnSPfQeiJT/u+1ctMdje6VRiU51LLZQhIqejf6vd2
         ecnBN1BGzwHnvyuXof4uPi818/WILTTzn0Ru4NFBm5d6zCvOSFUdimzrpyzjnSdOc5Aj
         IKbZx5Zd9MiAhLdNNo+FulZlNj94f3RKreqKl8D0+dhuQk6taSZytiTk/na/5XKkPkpO
         gKlf12Ki26V6g6zp6Ai/0YkgGf0fLVo/fVjvWxl45i/nnS32qk91rc1yNtisH4bWiRRM
         Rrnc8f5+8X1AV7LL3gWi5nq7e1L+huGdpoSgJU4IGfLYNvUi0LSHT26JyFgUCf16Ep2R
         b/fQ==
X-Gm-Message-State: AOAM532M+iVZcu4xZELsYgxFD15SpAAlUdXRJ4P8FZLdu5HHC5Ku3x3D
        H11flrvCXAof2B4Ux0w8xZc1ACCnE+GoDACUwbD2+Q==
X-Google-Smtp-Source: ABdhPJxx24t+XO+FReoa5ExPw4Zh8z8yxS34Vyfr4zUx/U7TwqCyNCdv3Zdzct4CarxOjZvyrYvyUodpyNnFrnNVvsk=
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id
 o22-20020a2e90d6000000b002460e44bcf6mr345680ljg.501.1645638317714; Wed, 23
 Feb 2022 09:45:17 -0800 (PST)
MIME-Version: 1.0
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com> <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
 <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com> <20220223094010.326b0a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223094010.326b0a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Wed, 23 Feb 2022 09:45:06 -0800
Message-ID: <CALALjgwm9LpmnT+2kXNvv-aDiyrWWjMO=j0BBmZd4Qh4wQQXhg@mail.gmail.com>
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, hawk@kernel.org, saeed@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 9:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Feb 2022 09:05:06 -0800 Joe Damato wrote:
> > Are the cache-line placement and per-cpu designations the only
> > remaining issues with this change?
>
> page_pool_get_stats() has no callers as is, I'm not sure how we can
> merge it in current form.
>
> Maybe I'm missing bigger picture or some former discussion.

I wrote the mlx5 code to call this function and export the data via
ethtool. I had assumed the mlx5 changes should be in a separate
patchset. I can include that code as part of this change, if needed.

Thanks,
Joe
