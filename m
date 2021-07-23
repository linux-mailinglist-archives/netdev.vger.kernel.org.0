Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0845A3D3AE6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhGWM2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhGWM2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 08:28:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58382C061575;
        Fri, 23 Jul 2021 06:08:54 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j2so794799edp.11;
        Fri, 23 Jul 2021 06:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PAkhX5Xo98YeUW9gogd9oQuzn1u/1XQEnn+TYTLrMLU=;
        b=nLGpsOsef3mPZvPURhVHCv5/LbnRnsl/AZtg5qi98FUrQrc9FGXLQUUZhgGPi00Njm
         kRhlsafDhZ/Ir+BDHagW6tl6TfHTHBzYpChRuNK97NBdFrIz3fNjw8CDdyTouPEfNd0n
         33FkAIkIjHrfFq9o6o+VhBGe6cfKOkXHUCb3TNdm1RMQEVvFSMDby8Yzx7gvAHwAzJWo
         f7nbp351mxD0VB78Ft2iVsDUnrGJYlPRTvPqE6OweLR7tkybyQMPVGkT5s+tbhgcwaJk
         xowIYqqrB87usYrt9EgiqAO6lVKA/51Y4xpWV5ddbyVigtBGDhP6j3L9hFsZUsmIgSWU
         QDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PAkhX5Xo98YeUW9gogd9oQuzn1u/1XQEnn+TYTLrMLU=;
        b=A3juYI0btdlvxWk7+2k8AtOBNtzHrTljuiASCAbl2HAg5IIvTJaAPeyHFv3n/3GdcB
         Jemk2x3FLZkft4yZMEDPU8fDM+qOV7jzCixAZioiYhqlZFdkVE8lDK7xNFjmCWL8Drfn
         DmkHqL3a9v4KWEEg4LXHsDozd/DoQcwT/X+0SYiDA9Sh9YwnfZ+9Uf2DvR16IiWPtkW2
         UJ4GFfxdF3LiGJ3kCvJf5EHXd+GhrFdhMKjZgDgbRrIZ8ERvQEaIzSO+q+q/P2yr5+OS
         KT9wnLpwygAdVFkInbSo+ZJQxy5TsE4bCmNZgoCNJmGUdnKTf4Tovn0XombfOSlLta9x
         Y8Bg==
X-Gm-Message-State: AOAM531A5wx4EZc22YzOUZjq7UVh9R4WGj4bQsky7RYdX3/XTUIQBxNm
        VXDzQh/ssW5VUq+REgffCHI=
X-Google-Smtp-Source: ABdhPJx/9BRca9c3vlIqAYxdsyvYU/mwSwHs5XmUzc3hblRgBGVjpGX4CrAEBTtZGKoUmU/GTr9qbg==
X-Received: by 2002:a05:6402:1d86:: with SMTP id dk6mr5606889edb.136.1627045732909;
        Fri, 23 Jul 2021 06:08:52 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id f23sm9912748ejx.79.2021.07.23.06.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 06:08:52 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:08:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     davem@davemloft.net, shawnguo@kernel.org,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
Message-ID: <20210723130851.6tfl4ijl7hkqzchm@skbuf>
References: <20210723112835.31743-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723112835.31743-1-festevam@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio,

On Fri, Jul 23, 2021 at 08:28:35AM -0300, Fabio Estevam wrote:
> Since commit dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into
> phy device node") the following W=1 dtc warnings are seen:
> 
> arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property
> 
> Remove the unnecessary mdio #address-cells/#size-cells to fix it.
> 
> Fixes: dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into phy device node")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---

Are you actually sure this is the correct fix? If I look at mdio.yaml, I
think it is pretty clear that the "ethernet-phy" subnode of the MDIO
controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If
it did, then it wouldn't warn about #address-cells.
