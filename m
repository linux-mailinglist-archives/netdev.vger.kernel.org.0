Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190021148F2
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfLEV4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:56:31 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35390 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEV4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 16:56:31 -0500
Received: by mail-oi1-f193.google.com with SMTP id k196so4270106oib.2;
        Thu, 05 Dec 2019 13:56:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+4jN+XaXHwrYJI+muu2FvEZSPfGj9LIVkbxEwDHYMas=;
        b=BD6GPwcMe0BLBUvudzCr/chkM/YfW+yRM2U+Jxya9K7lPf4ThUT7+8Umyz5e/ucNFA
         MtC+iCzrzM1tsp/0DuoPaKbrxkmtSyWkRtxvpEqtozMVRDqiIf7uLYKgY9aIJSEeBjA2
         XsB16DcxxiqhMDCYWJ6GB5cTyqT9KGFNkLNyBZcaxNEejmO8nv1k7DyO28rKxLJYLuzg
         GQUJlAWkgbbrjy3+aEcJKFdWJiK2rGJTr/tewnTojwUwTrdrLobARKTGLVfOox6Aj2sM
         vbIdjkj1xAodWF4/m9PpFmrjUHGSKtn3p8YuPJhXCQR4p/ZSHQFbrh2Yz2SMD+Waqenj
         VK2w==
X-Gm-Message-State: APjAAAWHxbrPG3yju3F/04X+EfBGmo5F0PNaVUVvgAqfKuDrFET35565
        AfCottFn+PNyWHMigePqPg==
X-Google-Smtp-Source: APXvYqwnyU36jjBCPs3lGB+ujZ9geaCsahZP028XU/TWYqFvFZtwklN3E7FkUeJyL4g2H8dTgny28g==
X-Received: by 2002:aca:889:: with SMTP id 131mr9140897oii.3.1575582990359;
        Thu, 05 Dec 2019 13:56:30 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o2sm4026571oih.19.2019.12.05.13.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 13:56:29 -0800 (PST)
Date:   Thu, 5 Dec 2019 15:56:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] dt-bindings: net: ti: cpsw-switch: update to fix comments
Message-ID: <20191205215629.GA32427@bogus>
References: <20191127155526.22746-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127155526.22746-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Nov 2019 17:55:26 +0200, Grygorii Strashko wrote:
> After original patch was merged there were additional comments/requests
> provided by Rob Herring [1]. Mostly they are related to json-schema usage,
> and this patch fixes them. Also SPDX-License-Identifier has been changed to
> (GPL-2.0-only OR BSD-2-Clause) as requested.
> 
> [1] https://lkml.org/lkml/2019/11/21/875
> Fixes: ef63fe72f698 ("dt-bindings: net: ti: add new cpsw switch driver bindings")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,cpsw-switch.yaml          | 20 +++++++------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 

Applied, thanks.

Rob
