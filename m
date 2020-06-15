Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC72D1F8BDC
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 02:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgFOASa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 20:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgFOASa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 20:18:30 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99723C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 17:18:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b27so14189314qka.4
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 17:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7PAVwfA+4Vkh07hZU0HuOunbYGJ74TB3FrzkFFsVJCM=;
        b=fNwYwkDkHgOH+cvmk02/j3lAw0p5Xx4qedl8WE2c8IzkmVPXmR/FqEFJfqHrDRvvR8
         9Y+i2xIwG8vzv2ZQ2PLsunNm8uuyY2wVfsrMaFxaqpA5cmDf1hUKmVE+7k9yX51dtu71
         WTVHNLmnD4dZTgP2M+Z65pQZbLe2EV3sTGNdhrecxa5FI6NuKMIexbBpcvbaYk2zoVpz
         zpJoVJZRHbJx135GLwCQ94xdlwhF5OnRt+QA4PYU+IW4VAhJwCEe/fJ6RuLW8IBafh5f
         4oR8cfUitanQ8IxMXFkU5lTIxWzyE7mTJKqwgkmg6nCrV/nddptU1XOA08qG9H9Kq3xJ
         4wjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7PAVwfA+4Vkh07hZU0HuOunbYGJ74TB3FrzkFFsVJCM=;
        b=Iy/3D1fLneF6Wh+W6vApR9vSVHdh888EKh1HzPQ3/Yv5nw25AxwqkPidj8AD8b/bl5
         fDzzgJeb2FxQvQZXFLfzfSfiRp6oB2uGRPpNjLuAmBOJNGs/vZ28/PA8xXoFgzL69WLz
         PVvES5jUQx3kasccvNGaqYUgKJLMO2d3ASIMGbMOVkVo2PQSfZH3fqBKOdAAzeQFsc1W
         vaAo985auO6BYcrGQZ1MUQPKGQqU2EvIGKtQLe5QxNbJelZO6T0rHEvVwlBCtpLzCOPe
         Q01OPNJQYQBiQC4zebxzo9lQQ3V3lrW89reJmlRJmABWhDNHGB0KC6hToOl355Uu5P0V
         Jz7g==
X-Gm-Message-State: AOAM5329/Dufvz4E3GalVSHABq7YM9aYQz4JuFrkpOp4DqYiYDtj8yL5
        yZmAZsgv49PpAKek6A15H0RNNFi7utqnt/NO46rJq4lb6hk=
X-Google-Smtp-Source: ABdhPJwqffRy1+ASXcfL/l8aWlzQ9S7ZBOLFk8QWRyKZa9LB+cLpkOWfmqUEm/whlLEH09aPtZJP0YZkf2VjZNuzmcg=
X-Received: by 2002:a37:9c8f:: with SMTP id f137mr12463249qke.220.1592180307459;
 Sun, 14 Jun 2020 17:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200614072012.xyhvghdgvs5xj5ta@SvensMacBookAir.sven.lan>
In-Reply-To: <20200614072012.xyhvghdgvs5xj5ta@SvensMacBookAir.sven.lan>
From:   Matteo Croce <technoboy85@gmail.com>
Date:   Mon, 15 Jun 2020 00:17:51 +0000
Message-ID: <CAFnufp3eSvQLubdzS5m++o5L6Q-N3-GGznN3aUh87eFKynjNYw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mvpp2: remove module bugfix
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        gregory.clement@bootlin.com, maxime.chevallier@bootlin.com,
        thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com,
        Marcin Wojtas <mw@semihalf.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 7:20 AM Sven Auhagen <sven.auhagen@voleatech.de> wrote:
>
> The remove function does not destroy all
> BM Pools when per cpu pool is active.
>
> When reloading the mvpp2 as a module the BM Pools
> are still active in hardware and due to the bug
> have twice the size now old + new.
>
> This eventually leads to a kernel crash.
>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Hi Sven,

Nice fix, if you think that I introduced it in
7d04b0b13b1175ce0c4bdc77f1278c1f120f874f,
please add a Fixes tag.

-- 
Matteo Croce

perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay
