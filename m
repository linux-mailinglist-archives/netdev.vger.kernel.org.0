Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9128ADF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 21:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388109AbfEWTsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 15:48:45 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41615 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731711AbfEWTso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 15:48:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id m4so10824257edd.8;
        Thu, 23 May 2019 12:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJz4Jaf3nRlpFZhdMsCJcAxVfO7QekQ4JhpwJxmPYIA=;
        b=YpCD8hAGr3Ek/vvtcKb1exKSCOhooAa4utwBx08kk8KQQs2rdSiI88U2myH94gSxPS
         JCA9Fck7WAXovMF6/s2OIEJ01kT8vux916hInZvSI/lYLqY7aZWLWePGMosI/MpXUTj/
         biWrdZ2E6DA1Det203iLIN5ld6602Pj7+gu89jH81PychFb+qDOFqTow7v+enQ8pnkv8
         Nkela3idC+mtLxXdWa4k3ev1SDmSG2kW9iQE958Q2aI+6Dt1TGp7wbOxgyGEaPS5krNd
         IeFf863D2pvAr1MkFlu65RoM1wH2mKMVAHqelmybX5gBr0l+bH2KO7jdx4uGa0xX5zdn
         78ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJz4Jaf3nRlpFZhdMsCJcAxVfO7QekQ4JhpwJxmPYIA=;
        b=XZYBqOqCjLfO1R1Y22yxejpkVoiJedyWbDElXMIBhcf6QL/Jv2GTS1H/jWEYeXvY45
         JDBG24uijoBzzHNXrucAgxPc6cWJqyWm1tMetGCRY0IM6Fvsd3L89qxaJT51f1b1L9rj
         9WM34idVKzuMoH4zQZomy5CDyfKel1HhxVux+a6q18+wBG4xFfRjq6PBWdAWQ+6qO9yh
         hxeI+SwgCPM06nK2Qr3T9bgUXOhDvbdm2V7OQLtAJ3VS/9QfdVU5HN3BhvulcoL1vXvs
         7cFMS0RBWwnfRvqPBOF5ZISWNb3I1xB6n/5vnHdGi0viMJlgpOHwOVl9Xtz0jjypaDTb
         ulrg==
X-Gm-Message-State: APjAAAU/JOsFjt8bMeiZgvartsaT+5l6Oad+LKXJtN74oIZ0z1NO+lIo
        oD/2cG+G5kMxEC3wjfZWHVZ887pGSadVVxCA/jY=
X-Google-Smtp-Source: APXvYqwRmL5SHZzIt4wr9/g9nzNhVJw0Dm3F0aJ5vCQ1OXoVakcFgj6x9h87E5mVpi/g7JaqYyHeYXfk2FkFJa6M6Q0=
X-Received: by 2002:aa7:d381:: with SMTP id x1mr18189018edq.251.1558640922979;
 Thu, 23 May 2019 12:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190517235123.32261-1-marex@denx.de> <2c30c9c9-1223-ad91-2837-038e0ee5ae23@gmail.com>
In-Reply-To: <2c30c9c9-1223-ad91-2837-038e0ee5ae23@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 May 2019 22:48:31 +0300
Message-ID: <CA+h21hq6OW2fX_m3rGvhuumhwCj7MM+VjVH_G4RO85hgGa4p7Q@mail.gmail.com>
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 at 05:39, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> +Vladimir,
>
> On 5/17/2019 4:51 PM, Marek Vasut wrote:
> > Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> > BroadRReach 100BaseT1 PHYs used in automotive.
> >
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: Jean Delvare <jdelvare@suse.com>
> > Cc: linux-hwmon@vger.kernel.org
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

My only feedback is: keep up the good work!

-Vladimir
