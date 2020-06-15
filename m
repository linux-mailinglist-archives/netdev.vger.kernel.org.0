Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07541F9E9A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgFORen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 13:34:43 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:35443 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbgFORen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 13:34:43 -0400
Received: by mail-il1-f194.google.com with SMTP id l6so16136761ilo.2;
        Mon, 15 Jun 2020 10:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G0oDMFgi5KtWDyZ9nZLkkcQ4MwXS+kdNi+dIyXoI15U=;
        b=cmLY3KnXaZfP3XWPRlbsKlUKhWn2dUa6+kpNFMPlZjApb/UxhZg7VdByseHH50hyy5
         euYng9PHo4Qs5dEztBXMLnpNJRwhKZVyAFGvLck60K3Jty+ZKk+CVRg11fs6kI+GBNDy
         cLrCFsdC2R0kNqj/NTgFrlusUIgGCB7pYmkDKPWwKq0rs4xnvRcL0QN8znb838PgeD2O
         nPlayCVtKnjykxN1sGyz/4fBIWixEQuzmGlWvh2OMatUrJnW8siHYySlcPgGWVuBVXh/
         L8Ouy/cl/pYeREe5V2LfO1bq6DpEwP/OmItqSvlp7NQW8ALlEqljw62T3m7lZ4jMkQhu
         IE7g==
X-Gm-Message-State: AOAM531aagu/qlsvmVVZdD681/tV7sxFYi+shK92CKyQ1buT+Uo5x8Db
        /7RPIxfVQGyITi0RzTnEIw==
X-Google-Smtp-Source: ABdhPJwWfQ7KZkhbzYGOxXJUBLrTB6rB7/Vs1ZUTq2eKOcg6A7icfDw+TK0+uD8c7cXLJSOKGrSDkw==
X-Received: by 2002:a05:6e02:13b2:: with SMTP id h18mr28151252ilo.293.1592242482336;
        Mon, 15 Jun 2020 10:34:42 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id c20sm8247596iot.33.2020.06.15.10.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 10:34:41 -0700 (PDT)
Received: (nullmailer pid 2006649 invoked by uid 1000);
        Mon, 15 Jun 2020 17:34:40 -0000
Date:   Mon, 15 Jun 2020 11:34:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v6 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200615173440.GA2006513@bogus>
References: <20200604111410.17918-1-dmurphy@ti.com>
 <20200604111410.17918-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604111410.17918-4-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 04 Jun 2020 06:14:09 -0500, Dan Murphy wrote:
> Add the internal delay values into the header and update the binding
> with the internal delay properties.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83869.yaml      | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
