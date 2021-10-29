Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0A440178
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhJ2RyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhJ2RyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 13:54:07 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC729C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 10:51:38 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id t40so9837757qtc.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 10:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7nMF1V6BCwjlzSpPh1jKw+VpyNLXokFgQZynS9/OsMg=;
        b=SZy3iI1x6UqOI0yZ46Lm4kpVmHNb0gTREnWO/KILOdRNn9W1nXXcEskLPaayzv8Dcl
         fBTJT4nZBAFtWCp+iJNFKPGJ7+ew3ofvWA1/k/uSTBeYsBSCUXY9DqSVbJQO5a0y3RfJ
         ZKZVWgE5jHAh3kbMiGUbI+8uw6n4E637EuJdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7nMF1V6BCwjlzSpPh1jKw+VpyNLXokFgQZynS9/OsMg=;
        b=YXFa3wz0cfhHkdEJM54Rgj9mwhuggHOybpwFAFRVYo026D/z0NQX0dGR81EqTE6FV6
         U12yFit1cf2XPT5iZxFeopxqPDjAaRnAXklcUSmNz519qRgrkCaJjQg0nhdTauukSIJL
         MjA2hcH6zPUfWo7O+CebqMzuprySTMb8Kf9qeOWba4csSqfSxe6huZqY1PXgHtwtzI1U
         iG6D/MoKUokETMWPyEolDqrvIMV+X4aAYnFdzpQhB6GMMp0GhHBKg+Tn5wQ3faeHYqwZ
         QwD9Zk3NgKfw4SMKNwqqzz0wq2RZSUy+SsVuwDq5Y4EPvVTxOjpi1qPITittr/p9HkpY
         6/dA==
X-Gm-Message-State: AOAM533izFS24KoxgRoSeeedEkIevHYZj0QEEdWpBWqS1mBfgoXCCF2J
        1Il8zo2CoAHXoAdjEEASCffgnlcezWNN9FyjLmARXxi65GY=
X-Google-Smtp-Source: ABdhPJy/LIk2FlF3YFx6sUj9oMHMPK2rorcoFjhjLsoz/JSfc85V3sjXobjyqNSwBgJwZBwpBEEBcQUWg0sIxVKCktw=
X-Received: by 2002:a05:622a:4d2:: with SMTP id q18mr13590760qtx.84.1635529897819;
 Fri, 29 Oct 2021 10:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <3a8ea720b28ec4574648012d2a00208f1144eff5.1635527693.git.leonro@nvidia.com>
In-Reply-To: <3a8ea720b28ec4574648012d2a00208f1144eff5.1635527693.git.leonro@nvidia.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 29 Oct 2021 10:51:27 -0700
Message-ID: <CACKFLinnFQS3izf=GV1Zxzt3qVRj1nDzz7c5gXnWTRdLFeswOg@mail.gmail.com>
Subject: Re: [PATCH net-next] bnxt_en: Remove not used other ULP define
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> There is only one bnxt ULP in the upstream kernel and definition
> for other ULP can be safely removed.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
