Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED63574AA
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355505AbhDGS5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355503AbhDGS4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:56:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850DCC061760;
        Wed,  7 Apr 2021 11:56:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a25so6366718ejk.0;
        Wed, 07 Apr 2021 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RxFgR6aOcICR1FXkZyxfT0N1Hrrv9abE87587TKcQo=;
        b=PKiUx6gR3sgKZfmJes6q1PCysle9q+11gvYlhe7m1iHz6Pr93RV3uQleWy2NxbjARI
         /zjXAPpAPn4LOtHu6Zq5PebmS0C6HGnNQnhgH4T9oSXCbabe5GGTeAwj0QIzZTrZ2cYM
         oMb/tWZeP+TlH5hSfNTfb3SCNoZv2tGCbx7yKYoAyoogmfwdbP0DU5KkZcXl76eFGKSx
         SqXd7YHygha1SpcuGl/A+2DUv+XTFtQ/5xR5kpzWLBy4/1b/0BeqfMgUXTr1YpR0IBfX
         41zdYqdxfGEqdrOk7rEG4Q2z+3rsbLYZFvnCpziIU+jWpBXAuZhd2jS5gdjPSe8M5RDc
         BoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RxFgR6aOcICR1FXkZyxfT0N1Hrrv9abE87587TKcQo=;
        b=khQyd5sAZyUZIbcAMtPeN2xKrAFDCiZOwKiEBmwptnPI2P8gJRqp9NpYHBSI2DFR+P
         Uv5ohntC6Sv6Fq+UyGn/SXFEGKJBXC9Tf0/3q/4p42dD+ucvdmpYdZ91eS7auXV1YMtC
         MLiY356gPUch20itlJqkGKe2jtJrMzxIkaq+tPFaaGQtpAlTLGFZ+BJF8RKY4xaptGG5
         FvYuvFvhekoS1UpzIeYzHj6oZ7L8Jye8SjrG8L8+Mb750xsVlPgc9DyR8EHzCxv9OEvg
         JGa6F6lU7wFVp/2FzukqrDY46O2zrj0gwL5iepuhI9F9G614TIfXiEdkff0uH5hqFSUG
         Usaw==
X-Gm-Message-State: AOAM533JvqigYUUAqH8Haa0n5jtkapqYKj+yYWrNTpsO7WfGa2HBU8wK
        ajTs0Wc290xCiIx2vTd9gcEkPPoFFSokTd9LDq8=
X-Google-Smtp-Source: ABdhPJxXmKOL4W9oQ9c1GekPrRP1YHuZyu5iI1h4yVnEfmAxQIYj01TiewpZaRoiR3Fu5Bx+7IMeMbqm1V7eC6QpjWk=
X-Received: by 2002:a17:906:d15a:: with SMTP id br26mr5465774ejb.328.1617821798254;
 Wed, 07 Apr 2021 11:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-2-martin.blumenstingl@googlemail.com> <YGz8FRBsj68xIbX/@lunn.ch>
In-Reply-To: <YGz8FRBsj68xIbX/@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 7 Apr 2021 20:56:27 +0200
Message-ID: <CAFBinCD-jEUbyuuV=SLER8O1+PwhmiqHXFMaEX=h5mca=SDLgg@mail.gmail.com>
Subject: Re: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Apr 7, 2021 at 2:25 AM Andrew Lunn <andrew@lunn.ch> wrote:
[...]
> Having the MAC polling the PHY is pretty much always a bad idea.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
thanks for reviewing this!

For my own curiosity: is there a "recommended" way where to configure
link up/down, speed, duplex and flow control? currently I have the
logic in both, .phylink_mac_config and .phylink_mac_link_up.


Thank you!
Martin
