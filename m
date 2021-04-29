Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9767B36F22E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhD2Vkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:40:35 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:40591 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbhD2Vke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 17:40:34 -0400
Received: by mail-ot1-f45.google.com with SMTP id g4-20020a9d6b040000b029029debbbb3ecso29740655otp.7;
        Thu, 29 Apr 2021 14:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ygg2abr5faBENjSA5cFW+vOjsCf4TS2eA4+Ztp3hH6Y=;
        b=fYPoHL4ALbb59vpT1/hMXJYldzwt6BCzKa31CH6UK97vJq65VC/GRd7+5iNDsV/Quc
         sRH+w6pYa0LRkHSzNgt4mw9ekdjlsCRIx2J9nt9Jo3yqppG7SmhP8ijpW8EF5mBOvT4o
         /JnOAhaDa7Lqpp0a24pCJfe7VEQrFbQoSBbXVnYbD3cZFtvELUAgnOnoJ80tSmM5D86l
         PAuUT6usX519MJJ7COoN7/9tB0/0jWvFb2UZmQqLvONscmL0tcUDelnQeBkdQiyf4qhj
         yYKSXziJwhrzX2UfjOGiWS/Oi/kTxuWhtB78cTApNXXv9Av1PpemlYkvooI54YwniTxc
         0Sog==
X-Gm-Message-State: AOAM533jwbNtLV1eGQsN6A4GNz2bJfCml3+6EqRNCK1lmqWV9fgHYf58
        NyPlPLQUKE2qrp/jfChz8w==
X-Google-Smtp-Source: ABdhPJxvyUt/FmdFovkVBDpqigYwZi3sUxtRqVRmJ6uExAHHE86O3Y5qLrUd3IEKj70i6AA79+wgZQ==
X-Received: by 2002:a05:6830:1ac5:: with SMTP id r5mr1178763otc.34.1619732385868;
        Thu, 29 Apr 2021 14:39:45 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k20sm275236ook.26.2021.04.29.14.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 14:39:45 -0700 (PDT)
Received: (nullmailer pid 1822853 invoked by uid 1000);
        Thu, 29 Apr 2021 21:39:43 -0000
Date:   Thu, 29 Apr 2021 16:39:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>, kernel@collabora.com,
        linux-rockchip@lists.infradead.org,
        Jose Abreu <joabreu@synopsys.com>,
        David Wu <david.wu@rock-chips.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: dwmac: Add Rockchip DWMAC support
Message-ID: <20210429213943.GA1822801@robh.at.kernel.org>
References: <20210426024118.18717-1-ezequiel@collabora.com>
 <20210426024118.18717-2-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426024118.18717-2-ezequiel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Apr 2021 23:41:17 -0300, Ezequiel Garcia wrote:
> Add Rockchip DWMAC controllers, which are based on snps,dwmac.
> Some of the SoCs require up to eight clocks, so maxItems
> for clocks and clock-names need to be increased.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml         | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
