Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49613D11D8
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhGUOX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:23:27 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:56287 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239441AbhGUOWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:22:48 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mgvj3-1lRvFq2j89-00hQvH; Wed, 21 Jul 2021 17:03:11 +0200
Received: by mail-wr1-f50.google.com with SMTP id f9so2530846wrq.11;
        Wed, 21 Jul 2021 08:03:11 -0700 (PDT)
X-Gm-Message-State: AOAM532WxCkqnfhRreXnOe84xWlng5HrXsX5P8AQaO0CPy5h1g+i30PJ
        HxtESQxqP+IyKY/+94sSPVAuTaeFMDt3vmFUimQ=
X-Google-Smtp-Source: ABdhPJyjWnWzwjYA4r+4Fzew1FHPBerxrrH54RK6rQot3FMcRIf3h5TFs/DMCixvrv7bz0++Xk6Oa9YfajVLCTBO8KY=
X-Received: by 2002:a5d:65cb:: with SMTP id e11mr45059401wrw.105.1626879791201;
 Wed, 21 Jul 2021 08:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210721150141.1737124-1-arnd@kernel.org>
In-Reply-To: <20210721150141.1737124-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 21 Jul 2021 17:02:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3qvSfEJrrEoHyF4GYWns30Mta_XSA9+WBpmYZk=mjmkQ@mail.gmail.com>
Message-ID: <CAK8P3a3qvSfEJrrEoHyF4GYWns30Mta_XSA9+WBpmYZk=mjmkQ@mail.gmail.com>
Subject: Re: [PATCH] net: phy: at803x: fix at803x_match_phy_id mismatch
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Bauer <mail@david-bauer.net>,
        Michael Walle <michael@walle.cc>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TGY9ZcpPbrEM9Bz0WgWH1Rn9kE/MbakL4E//s1iae5nLrVbkX2r
 9MiMozpV0Zx/p4RkrM/NQIvpSIanK+1yiiCDx7b7uklKey4Cy5lezlCE545HPGeLGLpY16C
 mWyKEHoSc/lnUr6RLdXyRV4Ninjs846H/xD4RDaNGvgXc7n0uJQAv74n986ng94ZvIU4uE5
 FkuAjkGsZrUsNYVjDnepw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0JhZBbo3NMU=:XxjGDPdsinKqjLLMlEh4iB
 C9Hx29MRlcv65DCeaXM6U9YwAHQgtqTjVGQBwNE2GBBZYKZWhrSvxNZI+h0Adh+1qLN+3hhye
 rXtxIVU9/u2MflZiyq8H1WQ4q+8Du1VsS4yr8e8gnKkBWUVcG50eQUBC6CD80Gd3iimpMz7Y1
 N4uibGSXGCTkgdVnx4Lek+s3nJBH9A7gLRrUkW3McvGboZ7XgcuCxTnO5D05Rzruww/PuiAd7
 1CHixOaWE/8XVYkIHwuB02E1Qb8q7O6jLKsvTvVbRsDFr2B2oBWqrRdkaDiqiy/9lGTryfPKW
 Z6M59A7tm7hNLntaoLk8DXgKgmLlNDIY5RJ+R6nPwTFGFLhF/51uO/mtDJVY390+mZrL2+Pa8
 0yd+oCzw9bUCPx5IeVf+z4BQhRd9oBiWT2bmdvqN7SIxoL6xubREOnA4yUYVR0LOniOA+ou1x
 kl3s3UxjbnqB18vRnWUMz2QzKDGIOnp7XyZdsZm9acVFLhP8dgjiKj1/zfe9aQ4jMf/Xzwjzd
 1HgJ9GWwTtItiPSV1cuuvG4QHVE2FWj5PrBaZndYPizLRcbfDdShQox1q2EDwFseoK5FY19T1
 HfRGiusRp0gA7C87jc3dKUxBqmrZ8fL1TSWTVVfHL7uGZlbU3lbcVbLJYRK5lLlLymtKkQQtl
 mnchItRsNRr7NaY68U+VmUSqbihhKYaXpR8kX5FbfRms+SwtWI7nGF6SER5vCV7bApLQmKY1Q
 395w2HzVLiQI6qqyY0gSqfcLX/FTK1Umx8XRjo9n/BRQ83xKp+Q90j3Fkgxar2fOLxmK5az3A
 TaPXortCbhfG8xBXL8loteJL4ZTo0VGrLB4zJ8eat2vFhJSZrWCmWa0XGBbC9FTRDd3oXtn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 5:01 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> There are two conflicting patches in net-next, one removed ...

The email subject was meant to include [net-next], sorry for missing that.

       Arnd
