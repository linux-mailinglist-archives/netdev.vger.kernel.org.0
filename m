Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC84245974
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 22:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgHPUSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgHPUSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:18:06 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87101C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:18:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d2so7334046lfj.1
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgQ/GmB3zrnGwyYvWKuLlUsZewAGc12JmhUW7ePwuRk=;
        b=hw1Tumy/txCSrpbVbJ+RnSqI+LqEWaEjQV1vJyZIAYMgQhaRzJNhItyhNG+eirkCxm
         gJ+qHxsQ8PSIiLPCmsIzOjPluEbI/q4PUGn4OxMacIoEkSScBIaZuDl2PhyWDA7EsoLv
         FSkMBF6pB2zwrJLE4SCbZbk3rZeyJ5zH/6e3cBadP90yT7pdwwgYvV/tZNavEAouEmxy
         p0t1PZflk1tcFwQjZUl0LzwCjxvBQoiKEOooEKTyFPjF9cSVTu0JcieViyrWZ8jeqhjS
         p662CxMsuU0ZfdOdocfSvsKHnkauIvoT3Rb5854NVxK6LyWsWFQjagGOmYxUKRr+k7jd
         poVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgQ/GmB3zrnGwyYvWKuLlUsZewAGc12JmhUW7ePwuRk=;
        b=UsphfHHEn+sA1vxp+IisT6LXtxcBcllSMUd+zhd5+T6a1fQM4Mv/TUFjGfyOGl8Yfk
         lMV35qM6paNbm9o/zpRhxRMHqmTA6VjuCOqiniPBE7EeDt3Wg55SH80Q1dhhNxTqPz5z
         3hf/ZumVwxxL1oH3bK5oBp5LQkD0wiBVTwY/+xZ7Xndi1ayJ9iyezxZf8iKErPpYwWsW
         +K9su2v2w+0Yn7EGRHG2eeRsmQEsugmyekXbNVoGz1UKYiustNJLQG/GhU/jmrqGicpl
         m2fPhc2rSh1SLvv8FK/1DuFk0J+6D7Dfe78As0MkCYRM8/1yVD+INgJr1+JnfVnLDQ9C
         EUZw==
X-Gm-Message-State: AOAM533NnohOTO7yH+tod8DVlcVSKdebY5remyuXBI7LZ2QvVRDB4hGZ
        KnhyvyijfDgS5m9SjNHilYJS9A5Dp/eXIwPMcDxbwNux
X-Google-Smtp-Source: ABdhPJxlhL0kDiwJgSAmI5UmETaeP7MeovvmgIftZdNoIZbK9vPvafAo7q2vk+PENEIke3rFuu+sbQ3rKrP/28r5Q80=
X-Received: by 2002:a19:bcc:: with SMTP id 195mr5916583lfl.160.1597609083812;
 Sun, 16 Aug 2020 13:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200816194316.2291489-1-andrew@lunn.ch>
In-Reply-To: <20200816194316.2291489-1-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 16 Aug 2020 13:17:52 -0700
Message-ID: <CAFXsbZrW1R8kEMQ0Ox+9vvDYAgfe_37acaY7Hz_V1dbR7wH--Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: dsa: mv88e6xxx: Add devlink regions support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tested this on the Rev C Zii Vybrid Dev Board which has two Marvell
88E6390X switches.

Both switches worth of port, global, and atu data show up when running
the devlink show command and for each of the regions, I can dump the
contents.

I also tested on a different platform with a single 88E6352.

Full series is:

Tested-by: Chris Healy <cphealy@gmail.com>

On Sun, Aug 16, 2020 at 12:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Make use of devlink regions to allow read access to some of the
> internal of the switches. The switch itself will never trigger a
> region snapshot, it is assumed it is performed from user space as
> needed.
>
> Andrew Lunn (7):
>   net: dsa: Add helper to convert from devlink to ds
>   net: dsa: Add devlink regions support to DSA
>   net: dsa: mv88e6xxx: Move devlink code into its own file
>   net: dsa: mv88e6xxx: Create helper for FIDs in use
>   net: dsa: mv88e6xxx: Add devlink regions
>   net: dsa: wire up devlink info get
>   net: dsa: mv88e6xxx: Implement devlink info get callback
>
>  drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c    | 290 ++----------
>  drivers/net/dsa/mv88e6xxx/chip.h    |  14 +
>  drivers/net/dsa/mv88e6xxx/devlink.c | 690 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/devlink.h |  21 +
>  include/net/dsa.h                   |  13 +-
>  net/dsa/dsa.c                       |  36 +-
>  net/dsa/dsa2.c                      |  21 +-
>  8 files changed, 813 insertions(+), 273 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h
>
> --
> 2.28.0
>
