Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C2290AAD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgJPR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:26:21 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36359 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390753AbgJPR0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:26:21 -0400
Received: by mail-oi1-f194.google.com with SMTP id u17so3264485oie.3;
        Fri, 16 Oct 2020 10:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=omBtvAFklWNlMUExD+4CJmUl79VsD9qGgMC2YooqDqQ=;
        b=O3vyaTUN1322Q7xxUo+EDsOaHITA9I17aSGKABBfnKF41NjIGBVPtIPA6L2pycDJCF
         0pHVjXGQ4wEnNfJ8gHLMg0k4fJ45hY5mViwFMeoEK+1OepYt3y/RynhqhnOyHEJcHQ14
         aKCnuwIGngQASYV7jogmPXPQXy+enGMQoiaXcheTgEfHjXQLotc+kMWuvaKvKyGQetbJ
         4WqGfXa6DVfie9a+TLkUwBVXr24EsfP6mjzVclQP0Vfr/1jEePdDc/Y+e4qPJp34GVfW
         LeCMkKsOLtaWlGKtjRO1JWxl4ME/UWrufAL/KqkYDWNm7QtNDc5Zw9Joj8ItfbwmfmS6
         470A==
X-Gm-Message-State: AOAM533XOcrXqlAqAzXXIV+yluSw5diFwfxYVcI9w8U8U1/6M0TQCVX3
        Ev36PUrYv0TfyxBDlRYTyg==
X-Google-Smtp-Source: ABdhPJzPn9Z+rZQLCishbk/PK12xWXQbmx1o3tzrhz0RLIx7LPM64CTl4qb0i2NU5xp5XJ3dwvEfhg==
X-Received: by 2002:aca:eb48:: with SMTP id j69mr3293005oih.149.1602869178902;
        Fri, 16 Oct 2020 10:26:18 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r62sm1226958oih.12.2020.10.16.10.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 10:26:18 -0700 (PDT)
Received: (nullmailer pid 1609608 invoked by uid 1000);
        Fri, 16 Oct 2020 17:26:17 -0000
Date:   Fri, 16 Oct 2020 12:26:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Amitesh Chandra <amitesh.chandra@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, ravi.nagarajan@broadcom.com,
        cheneyni@google.com, amitesh.chandra@broadcom.com,
        davem@davemloft.net, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: bluetooth: Add broadcom BCM4389
 support
Message-ID: <20201016172617.GA1609528@bogus>
References: <20201014054543.2457-1-amitesh.chandra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014054543.2457-1-amitesh.chandra@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 11:15:43 +0530, Amitesh Chandra wrote:
> From: Amitesh Chandra <amitesh.chandra@broadcom.com>
> 
> Add bindings for BCM4389 bluetooth controller.
> 
> Signed-off-by: Amitesh Chandra <amitesh.chandra@broadcom.com>
> ---
>  Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
