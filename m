Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0157E421581
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhJDRwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:52:23 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34643 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbhJDRwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 13:52:14 -0400
Received: by mail-oi1-f170.google.com with SMTP id z11so22696836oih.1;
        Mon, 04 Oct 2021 10:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nExK0Sv28mbDB3Mt1OQhUPXvDIcix9XdHS0KQ339UaA=;
        b=4TFQhVHjAILbW1VQaNH8sz//SC52ciZYHJjcFmPFaaRZtxUkeKCfVHRnzR9ZGro1BU
         DnD0ivwAX8USCdI45Gy9+9fkOkAou4Jb2OSYukCusj9qQ8DQCxxpWWOiiQvNksD35O5D
         KhFEAoE74uijcnKcsYlQAxNa3AdbwbTNJC4ER4gnYadEWwotcqkc4pAkuUx88vOZ0fN5
         283muosu5aejTRLPfYUlYtLHS/ppq+iu9QLBpUqtQBfTFp/e7zZHtFX82ZCKa/GSqjSP
         GjtuO8EmzUu8rc7UeyGgCaKtllA5zB8beJnVkDvnF+tihIy7vgCu3SQkyt3f4u67cp47
         WG6Q==
X-Gm-Message-State: AOAM5323Kyar6ztz+OGc+zlHTs6o2qQnnJZVjkkq/E2U2W9EKTbuFNlB
        VU7Egfcpwey2QQ/vEuIefQ==
X-Google-Smtp-Source: ABdhPJxMQm9vu5rBQQ5RoKlPfiDHh/XfWflRLqQTnEdgqzQ6yZh5clCu6/D1ptFLE2757iK4ibZG7g==
X-Received: by 2002:aca:604:: with SMTP id 4mr14070540oig.8.1633369824777;
        Mon, 04 Oct 2021 10:50:24 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id p18sm3105444otk.7.2021.10.04.10.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 10:50:23 -0700 (PDT)
Received: (nullmailer pid 1551421 invoked by uid 1000);
        Mon, 04 Oct 2021 17:50:22 -0000
Date:   Mon, 4 Oct 2021 12:50:22 -0500
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linaro-mm-sig@lists.linaro.org,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Message-ID: <YVs+3mfImSGq9ww9@robh.at.kernel.org>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-3-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632519891-26510-3-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 14:44:48 -0700, Justin Chen wrote:
> The ASP 2.0 Ethernet controller uses a brcm unimac.
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
