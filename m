Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEA3C352F
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhGJPit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhGJPit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 11:38:49 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7523CC0613DD
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 08:36:04 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e13so14121907ilc.1
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dxwIqH/ulbxlU3DAnabSwL337pnBzj6ZytE08T/Y00M=;
        b=mq+yXyti3ySp80Pak5oHPf+jb5iZhvarv2yqDG5/CyJIkv+LnVQi665rHVf9Pz4RtE
         56FguxtQMl0IsPnmX0J0b5LxXC/wBKxWK/yniXR5ALv/iBFUpUVhFUrfWV/g7c8TX4pB
         /6xkKpnRkWTSu/dfBIhqu0xEd2VOVBv1cu0fL8rhzIOgN9/3H/4FKzifMDKbTqcMmWjZ
         ibGn2RESNeyDutaxDSX9yzR5vHE/EDbAaS6mrwmYBwZv2zPm7QpiRwfhd6IsjNwRnfSz
         j4jAaYOZLFO5ONRuePfQxBF6oo0NyarVuOiCQQsdyR1ZPA9q453QVZpboV2m135akW47
         RX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dxwIqH/ulbxlU3DAnabSwL337pnBzj6ZytE08T/Y00M=;
        b=QezJ+kxkW0YUSaymLPvSROVfe45aOqygY3QYDevnEheN4vC0ucbdj8K54WLM75kEtN
         JamILQi3/Lt5vdaUDQ6QnytD8rElWiBSB3jMc4UTFGV8Oy753un0Rz6C7gLKjA9b/FUW
         U+Wjfd/7lfYyEn2BK6HYRaCOX9g6e+ewrP3aCgGx454Ousa+mx2zZiNuw1tc3GwhsLgL
         WHOxVZWDOP759N5JbeJLF/qkq+S4VV7oeAPuVfpmQx+KJ1VO3sR0lsbrYfHCwMqJrhzT
         cI0VwkOTcA89vCIeOL4hBF9Zh84sc8Nj+A1nVe6YGWvH4f3rb+NfnpyvN32c3koROw4g
         RKMA==
X-Gm-Message-State: AOAM5320zZk+1e9BIbXeK0FTuu6VjYaXiN3Pmci7pGAuLYbcDnvO75N8
        SovmX99mVlyJ4gWrKZH+s4gzxFIeo2OgeU6I2tH1dF+nkZ1m6g==
X-Google-Smtp-Source: ABdhPJyafv2bKzYtQ7DDZlr0gvDDDhO4/MLx4A8AGG51xFIRtvCE09P+IOGPiuT895mcYXyWZL32JpxobtTbZVhylhU=
X-Received: by 2002:a92:c644:: with SMTP id 4mr10024504ill.246.1625931363603;
 Sat, 10 Jul 2021 08:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
 <20210710081120.5570fb87@hermes.local> <YOm5wgVv7PGx9AYi@lunn.ch>
In-Reply-To: <YOm5wgVv7PGx9AYi@lunn.ch>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 10 Jul 2021 08:35:52 -0700
Message-ID: <CAA93jw4uhezgu05uM2xohoPMbDvbMAVmivSf2wgPiO4OzScwRg@mail.gmail.com>
Subject: Re: [RFC net-next] net: extend netdev features
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jian Shen <shenjian15@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linuxarm@openeuler.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 8:18 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Infrastructure changes must be done as part of the patch that
> > needs the new feature bit. It might be that your feature bit is
> > not accepted as part of the review cycle, or a better alternative
> > is proposed.
>
> Hi Stephan
>
> I agree with what you are saying, but i also think there is no way to
> avoid needing more feature bits. So even if the new feature bit itself
> is rejected, the code to allow it could be useful.

I would rather passionately like to expand several old currently 16
bit fields in tc and iptables to 32 bits,
and break the 1000 user limitation we have in things like this:

https://github.com/rchac/LibreQoS

>
>           Andrew



--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
