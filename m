Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA38030F6DD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhBDPwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbhBDPwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:52:16 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01473C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 07:51:35 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s3so4717960edi.7
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 07:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d86uWRuSchZNGiF5GcPs01AGXa1MTPPIVm+o9lL5GbY=;
        b=Qg8Wx2MJuya5g3GjTxRfHecgJuEQj/c2ecrnBoWU5qtf+r1VPJb+7qNk1gSVNXxzAt
         wAOJcTtJramsRgiRmZqIn/R6PnNrMfkIllxzbZj1jvNdQR6eTN2rSfJPpKqxynRkPfAU
         mTT5cpgX/jflPbvuMK687+QSF1MIjTaGqmOHDWSyAvBpxKnUhUnN6h3uWWmYexLgQK5d
         TdnR1/ueH5SiMLpOpNI/0kmK2xVQzB2c/NUm8f7hviGnoBMAvklHF3tgrkfqATvRN2nw
         6sTYYCeWL73TRGsD0wjib4VcQwOlj0VFhy1k8tYPe+L+3ZjPnxjZvFA5K544W/gLBVZK
         YTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d86uWRuSchZNGiF5GcPs01AGXa1MTPPIVm+o9lL5GbY=;
        b=e1R8k9ycg3wtA6aCpFyPASLNQV6ZQNgHWqtSj1WH6t+Nndww4+JzCDXA6k++ATBONf
         qElmmy004UBl6G5vXL42w/0ZN9YOXVB82Fzz/jLwynNjCV4BLap0VDpN7zVMK50nb51Q
         vgRLCKMXAmaJC0SmUY1qLeHJ+PRBxxEIZHq0W5+IVw1IgYjcze7Z+Q57F972M6VGpkLx
         rzacaWVeaEaFCaqtisEQe9nuo0U57DzDzsVMfPX5iDuCuJdoU+ewz8aSUwHkLR7CVszB
         xNbUc89x0DEU0VjvakEpNoAi/enTMhDLfo6CExaNw+Nodompn6IRC1AqJdXY1K4oR2j4
         x6Xg==
X-Gm-Message-State: AOAM530hfu5wCUGOF/3C1H6/3nQ4+TbWEIOydLw2uI3/25gazOOoGdai
        w8LkvTdSymZ7BOEQAVM7CZJrmFoHuoFBMf+0f/Q=
X-Google-Smtp-Source: ABdhPJyR7UsY8ad2bn6sC9+KnfH6PP4QxgzlS5AZ2zY7/2M0RdEUzHXtetBfDfUwGtTQow4lu5jU9GgLomaMBqURBA4=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr8665817edv.254.1612453893736;
 Thu, 04 Feb 2021 07:51:33 -0800 (PST)
MIME-Version: 1.0
References: <1612452064-20797-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1612452064-20797-1-git-send-email-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 10:50:57 -0500
Message-ID: <CAF=yD-Ksu5cwE9KK9Te4Cpz+57Aa19UHxtHpHoxQMBiB4d=zgw@mail.gmail.com>
Subject: Re: [net v2] selftests: txtimestamp: fix compilation issue
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 10:21 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
> test. It could be included instead of <netpacket/packet.h> otherwise
> the error of redefinition arrives.
>
> Fixes: 8fe2f761cae9 (net-timestamp: expand documentation)

Needs quotes

  Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")

When resending, can you also revise "It could be included instead .. "
to "Include instead .."

And mention in the commit the other warning fixed at the same time.
Thanks for including that.

> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
