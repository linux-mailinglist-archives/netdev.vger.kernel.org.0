Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F813237AF
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 08:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhBXHJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 02:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhBXHJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 02:09:09 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B319C06178A;
        Tue, 23 Feb 2021 23:08:29 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id u4so1521434lfs.0;
        Tue, 23 Feb 2021 23:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OhiHzvxVBzMcfj0EAN/kpIbK/2F2capB4/UjOZuTUm4=;
        b=tLRNDlpYIH9l0xOUQQCs2ThFo0Dy0U6GonTZOVeCaJOcZos7hX5YQOV995jZxAfBUM
         rA2jaqYuD56AoA7wVTUZtrktzzB52zM8SDLrnzfUhqpXd2zy/Cj1uCrGYWeydhoFwgR4
         D61cFEgC078N2xSvak2jKjEqVoo186ScX/lTYswKR3PBBzPCdmGwRjhYYeDDFiOEWRiN
         8WuilQ1Op9cgUm0voCgxU6O2sY19hvuKyVJ0fPUGOEPGpA+kNZc37cxvRr54mCISUaXE
         MABI6jgC89J8mIzpPX6S474kF6+VGkkCrtL6OnzYvYUdaXvdHcizc0wrxJ7+SkaQgM8I
         zlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OhiHzvxVBzMcfj0EAN/kpIbK/2F2capB4/UjOZuTUm4=;
        b=G35YLxXTCR/sbp46tAy9t/6pAKBZUXd8oaGiIqQa/sy44iUO+Rzb2rzD+6Eha3e/BG
         8bUFTnShtHaHdvd+kIO0fivMDjdgxpnmvpUcIClJdmg/ZU7f3BK9dc0syJIlTQ7ZLhWL
         R8UfsjrvoN+CFyk+zk7QqGOrGaCldf8CCkOX3sZCjCYvAZIeVkpUhpcDhUdhUUfdTApp
         p0CDEDClcuhTO5Q+gkION7pZj2HIWnaWX/d81RcHptsVoTWg6gOqgySeVRgJWoNlesX6
         lxW9KQpiUX8SYopWZPiMTtAnD2jKEqlhLlgJ1HLnZUeEVGexOSgypSGWFPx8KmxfZvJL
         zkeg==
X-Gm-Message-State: AOAM5323jNekBkwpqnPQFsgi6xE5Y6PurFvl9qSUcqVt2AuJXDXLWMZX
        FzOSzDH5PqVht0vlwNj/+3g=
X-Google-Smtp-Source: ABdhPJzF3RI1oCQDeNNEWtd+K8a0Z3XrJtSDOG3aGifi2mwFwoBLT6FpzOOYMh5L3doXxEUbLOWcFw==
X-Received: by 2002:a19:8984:: with SMTP id l126mr18093759lfd.213.1614150507698;
        Tue, 23 Feb 2021 23:08:27 -0800 (PST)
Received: from curiosity ([5.188.167.245])
        by smtp.gmail.com with ESMTPSA id v2sm287459lfd.111.2021.02.23.23.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 23:08:27 -0800 (PST)
Date:   Wed, 24 Feb 2021 10:08:26 +0300
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     imitsyanko@quantenna.com, kvalo@codeaurora.org, kuba@kernel.org,
        ohannes.berg@intel.com, dlebed@quantenna.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] qtnfmac: remove meaningless labels
Message-ID: <YDX7aryD86rcu6GV@curiosity>
References: <20210223065754.34392-1-samirweng1979@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223065754.34392-1-samirweng1979@163.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> some function's label meaningless, the return statement follows
> the goto statement, so just remove it.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 27 +++++------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)

Thanks for the patch. 

Reviewed-by: Sergey Matyukevich <geomatsi@gmail.com>


Regards,
Sergey
