Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744EC372B99
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhEDOGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 10:06:47 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:38513 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhEDOGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 10:06:46 -0400
Received: by mail-ot1-f52.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so7634188oth.5;
        Tue, 04 May 2021 07:05:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dJ098IqVRr87l/DzRCJEGpPHQTJM6HZjM/MT07n97Yo=;
        b=Ol8gVmNCIC8fBjoRNQKLqSNicnO1abGzWxniRhtQJhurqrJhiUtrA3OHBQhP0lPcDK
         5NcIK90XMGfHzvGFxbwRkMfib/UUi7zy+54ehfo7/7HDQLcfRenjM7N5K7WNxT0LglmG
         T/gVL2bcXHI29sjCSsFpHjhRHtk9woKRF3ZifDZH2sHMw7YbVnA5JifzOYOTq5g6SwIs
         Ly+W5Xx147rUFz0iUdkT/1kYmhQsJizSTXtMBpMK66otdnNjY55Fpzcj13KKnX/ezQQQ
         VpugOsz5YDdaGqmTDJYUjdMtsheDBHXkDxaAQPpgAx5hP35TEib4D6G2rfntSTDTt/OL
         YwdA==
X-Gm-Message-State: AOAM5321nqL1Q5+IUJkXNo7axKwN9ZiCvaSaTAiBYrxcQOu2bHIt7qVB
        Ia1U90O8p5foHaHibNUwRNzcB0BLrQ==
X-Google-Smtp-Source: ABdhPJxIh1SpbK1ACKxULPdmeBkX4mc41//B0xuWCwcREZv6iqdtkBiwfuxUB/wXkhAIL4Au2olafQ==
X-Received: by 2002:a05:6830:2004:: with SMTP id e4mr19573122otp.78.1620137151151;
        Tue, 04 May 2021 07:05:51 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e11sm249249ook.20.2021.05.04.07.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 07:05:49 -0700 (PDT)
Received: (nullmailer pid 4063078 invoked by uid 1000);
        Tue, 04 May 2021 14:05:48 -0000
Date:   Tue, 4 May 2021 09:05:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Adam Ford <aford173@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: renesas,etheravb: Fix optional second
 clock name
Message-ID: <20210504140548.GA4063024@robh.at.kernel.org>
References: <b3d91c9f70a15792ad19c87e4ea35fc876600fae.1620118901.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3d91c9f70a15792ad19c87e4ea35fc876600fae.1620118901.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 May 2021 11:03:00 +0200, Geert Uytterhoeven wrote:
> If the optional "clock-names" property is present, but the optional TXC
> reference clock is not, "make dtbs_check" complains:
> 
>     ethernet@e6800000: clock-names: ['fck'] is too short
> 
> Fix this by declaring that a single clock name is valid.
> While at it, drop the superfluous upper limit on the number of clocks,
> as it is implied by the list of descriptions.
> 
> Fixes: 6f43735b6da64bd4 ("dt-bindings: net: renesas,etheravb: Add additional clocks")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
