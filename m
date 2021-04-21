Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698F43674C6
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbhDUV0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhDUV0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 17:26:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2B0C06174A;
        Wed, 21 Apr 2021 14:25:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id bx20so49860610edb.12;
        Wed, 21 Apr 2021 14:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/nJoTAQRidVHQajPs6q3ldHAPVF7uFU+R0j/RWewsY=;
        b=vTbY4Is3R6vMevScZijHb09K732UcNymc5BEx27wrMNUAtM4eONLsOvzobtQJtjXZl
         rAjmv39/niikrCzbIvP9q1LownTiAt6F/Uh6X6JnwnLfNg0E5b4vRMxdXCK/Y2Ok+CWt
         pWGIK/SJVdSF1V2/q1j+Vv8ZgjbzlQcCtpCr8MzPya/F9e76AewWngAeg9ikD5sW0Yq0
         kxkdWtD6OtvbFIH+2hmutqXLkbhpchualSSkrWG9s0NNZPk909bCDvfFiQbO6Gbmfav2
         qPEoAFYlqlAaLX75AiO7VoSi/hJ7K4Eyn4CFeiKkGxNzi9yPzp7gXJKzs2ylJwd6D/+9
         A65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/nJoTAQRidVHQajPs6q3ldHAPVF7uFU+R0j/RWewsY=;
        b=iOv3gZgebWYKLCx9HSDWFw/CbdlYquYWZ/yd0YD/dzdqfjS4WKCy7J0EZWZ7tCP/fM
         +kO9b1fMQE080jlmTwORJH559M4rNG+nL2nTT4IzdMSxaRtS8Mmrg+U60qv0dAZM55RH
         VQeLedpDbtHTq3QG7NAFM36TtvmZ/kte9zzHKp28yiaNnmaU32iz1cGtC2WX6tqd1/Sf
         DYdWIUXmvJaQA9/NCHgBB3ZHGra97ouLbxHJYjPwSPo/6ZLnVpvim7DP5Im1EDxE/NRr
         5td+Bsr0hqWME4RP8OliiIfJpy5MxS81qOx5R++gSeGkObIlxwbYXxo7HnjeHvblU2Lc
         7BmQ==
X-Gm-Message-State: AOAM5332IIl+dUHNRSprQAK81biExT0+63fcAOQWroa/Yc/jdksCT9Us
        Msk+myTlvPPzS3Nx/g0AeJUC7SE52bUqIt2vhBI=
X-Google-Smtp-Source: ABdhPJwIUasehulChO42GfO1UO8CZ/OXVHkF6uHScXZmO/f6mtA0RzJmMflbHK10o6dgnfkFrarwNMz0iFv0Q7cqf+g=
X-Received: by 2002:a05:6402:51d0:: with SMTP id r16mr37461733edd.52.1619040345069;
 Wed, 21 Apr 2021 14:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de>
In-Reply-To: <20210421055047.22858-1-ms@dev.tdt.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 21 Apr 2021 23:25:34 +0200
Message-ID: <CAFBinCA1hm0zQKinds414p1p8q-On-uhKcHzqLZ4o9m7YENrcg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 7:51 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> The Intel xway phys offer the possibility to deactivate the integrated
> LED function and to control the LEDs manually.
> If this was set by the bootloader, it must be ensured that the
> integrated LED function is enabled for all LEDs when loading the driver.
>
> Before commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> the LEDs were enabled by a soft-reset of the PHY (using
> genphy_soft_reset). Initialize the XWAY_MDIO_LED with it's default
> value (which is applied during a soft reset) instead of adding back
> the soft reset. This brings back the default LED configuration while
> still preventing an excessive amount of soft resets.
>
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
