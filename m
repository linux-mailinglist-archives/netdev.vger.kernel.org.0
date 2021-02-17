Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A66B31E1C6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhBQWFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhBQWFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:05:01 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ECDC061574;
        Wed, 17 Feb 2021 14:04:18 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v14so142873wro.7;
        Wed, 17 Feb 2021 14:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6wttnQGWu0sxnyWFkVI72XRlxSZgSjW/Vbi7KmBnooU=;
        b=S8NztYelNcnuzKYnhS7oX1mJsUZSLgr3mbFA8X2i1g0Ufu+3349DArFXUmApD+wUN8
         qae+oQZcQrMGGwfs5uXO/8pg0rTm52mo+/cNttAYIrGQrUaez8wbfR0azlntX+LX4u3G
         BCBpcyV17PSqvQRIcv8dDeKp0HBzhIFX9UViWcKGce0DeL8ZU+5MbE4wV/VuDlMMp99u
         GqyjV3+G6IpSQ0+lce5zJAFo4GQZqMhq6ncTXWjHGKCuotpBbeX+zEqDlymSamjkU+l4
         WWSWTMUQOhU9/pG7L1dhuaTW+9eEEbhrEKX0TVpp7LMEplSM8fTiGesWNq3AKS3I33zP
         1RUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6wttnQGWu0sxnyWFkVI72XRlxSZgSjW/Vbi7KmBnooU=;
        b=d7YlqnJohor//F5Y8MZxziK7v8PJbulj3kFN3VWgU+O7Gmd4CQx69vHrVC9qa1q83D
         fDVQAXxzeaxljrz6s/ucxTZeh3qJZfRGtyqFmzwfH65MooqzB4B9/SRXXw03IvsYVzru
         dPlXLrBThzBWm4drPx8tFH67H/qR2K8D7T2ykERS/fl8qIJFnDfWkPi4ntAoxqG3WIrj
         ahekWM7te4WjEc6AP2IWHwJ5F8UEjFIn4E9f1Hvas3O0zcsibIOlTlhpRfIsRzxhwHmr
         DX0iAuPfOu8RSlxMvc6e2ZCgYd0OiIg4q5ZFC1+XJvqIpVrzl18OoSa7hcEoBNdVC79G
         B2cQ==
X-Gm-Message-State: AOAM533nZxkDjcQVLyXSpzfub5nGFvfx/aqLYWrdBkVuBkuMPPVFOc7s
        /SiQ/ZvzlWo2tWYMg6WvZbzGonfMRsqvCxcgF+E=
X-Google-Smtp-Source: ABdhPJyoNgeCYh4ZR1wXJGekd+0GnvpscpjxuRKyBWvKDEv6fshsFjkzz00EaLIHiia/zG7sJrerWde6Yn90dDe9PP0=
X-Received: by 2002:a5d:49d2:: with SMTP id t18mr1232965wrs.224.1613599457065;
 Wed, 17 Feb 2021 14:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20210216010806.31948-1-TheSven73@gmail.com> <BN8PR11MB3651BB478489CF5B69A9DB6DFA869@BN8PR11MB3651.namprd11.prod.outlook.com>
In-Reply-To: <BN8PR11MB3651BB478489CF5B69A9DB6DFA869@BN8PR11MB3651.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 17 Feb 2021 17:04:05 -0500
Message-ID: <CAGngYiUV_c7Z-gUCt0xKcP-E_5UVyM9PWBQ_wYK9o5_L0D-1qA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/5] lan743x speed boost
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub and Bryan,

On Wed, Feb 17, 2021 at 4:43 PM <Bryan.Whitehead@microchip.com> wrote:
>
> Just to let you know, my colleague tested the patches 1 and 2 on x86 PC and we are satisfied with the result.
> We confirmed some performance improvements.
> We also confirmed PTP is working.
>
> Thanks for your work on this.
>
> Tested-by: UNGLinuxDriver@microchip.com
>

Bryan, that is great news. My pleasure, thank you for your guidance
and considerable expertise.

Jakub, is there anything else you'd like to see from us, before you
are satisfied that patches 1/5 and 2/5 can be merged into your tree?
