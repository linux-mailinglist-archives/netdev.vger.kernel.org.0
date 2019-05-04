Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C492F139FA
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfEDNKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:10:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44789 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDNKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:10:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id c5so11213415wrs.11
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ylCighmR5KFCKvfl0MK/JOotS+k2IaaBA67id1CYsFY=;
        b=AMrkyGWIHoMFrqr8KcJ7YNgwwe5fYArjp46P4R8gx3YogtskSZl/Gmh8eWeKNsHiAt
         rOBE6QGo7vzOvVUjb+CZnN0x3bcG3u3DvIn5pCpoJXAS2sj+dcG2NLHTzOFcFft//pXG
         z3B16wriU0DAe5z0JujFoH7+GAMyTD5fYpe4J6O6UhmDSsyRWj7+IRPZ18B9mc5lxOrb
         +yKHOv/3JEmnzG7okWvSLIO4CPvt4BBWj2EvxT0ert23OKMGhVlRjj7nPZut9Z2Pbt3h
         Cs/+qZkgx4z/b0gAxwsB4WuKrM8mWehDobNuLbIhWwPq06CCOeZo0LhGhOuyR51WssUv
         XXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ylCighmR5KFCKvfl0MK/JOotS+k2IaaBA67id1CYsFY=;
        b=Iot8rb/288PQNb4Lgh/zrdNut94s86skV4gQoms8ZhGrXTS/1/ZfiHZDGkziBsoVn/
         U4cU9gNv+0XAu7XCJn1sk2ee0GuQWUrR7/FE+QKTKR20RGKqQy8LhJkT45SYiwgz1dUS
         o83DIwckC2DjUbPxA+8ypEgLmbhsE6mEdOas1zXpMtiRV/aw2fO6e/f0buXUZ5HcYr3g
         msVliEusCqgoliM1CUySBsNDyAY0IhGMUPKCTs35vIl8BCga38jFF2FryVF5km8Fkmr6
         DODoCPmPfc7mLWbfdkMZfFcrjxwHNuHxRiPGYJfi1HALaORQplqM9QcPBExU6a0Lqott
         097g==
X-Gm-Message-State: APjAAAXXvO+ilJy/PBYzAN724sq2VPO3D68Oainzi7S6s5J7Xe7UyA+v
        RsFnCMtoYAqw6x98zZKI5IiJeQ==
X-Google-Smtp-Source: APXvYqx+K/6vB6g9UV5+dCuGtd7gate4zMWwdukTA3/SWfxf/9L8ZA/mt6ecrGY7uQ6U9kmf+ZyioQ==
X-Received: by 2002:a5d:5551:: with SMTP id g17mr11922779wrw.50.1556975410574;
        Sat, 04 May 2019 06:10:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o6sm8825081wre.60.2019.05.04.06.10.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:10:10 -0700 (PDT)
Date:   Sat, 4 May 2019 15:10:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 08/13] net/sched: extend matchall offload for
 hardware statistics
Message-ID: <20190504131009.GI9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-9-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-9-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:23PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Introduce a new command for matchall classifiers that allows hardware
>to update statistics.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
