Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC802DA3D7
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 00:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441364AbgLNW5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:57:46 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45153 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441345AbgLNW52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:57:28 -0500
Received: by mail-ot1-f68.google.com with SMTP id h18so17491755otq.12;
        Mon, 14 Dec 2020 14:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8RRmx/saxrEOsk/+4v4Hf95Rm9K3o27fRskhKZP0vA=;
        b=fvzvBkrFc6Algvr9+SRV45KaK3eI3vq7hGWi/yZNUP6JDxdswQzstAXTPF5YeRv1AO
         3LgAvQ+4CtXSv78aQ8q6XRQNjDJY8wA2ajzqgsS+KbU+90NocMEM9TXhmPhCmX6IKVMy
         HRe5oww0XMq6I8VO96l0Bawpg/bTvcbTZ/hOPSFWMzzrRfJrKmbD1MtVPKkD7wSKN2By
         62JWRQ9z6aqv8EVptsL2fsRNbfmL54es0ubBpiINxQLG8dT2QtcDnXPuH3ANQIyw2GNr
         LbEtS1Wc+sXQI65funXdSA/tDnM29Vp6Ep1JWcbXDwf4gjnyxHXUEm3pQp9b4Yk4Mk0z
         7zBA==
X-Gm-Message-State: AOAM532AM05AgfBz16EzLCop5FayWkXGXI8BGi+hdbm/ggP+Rgg0R11t
        8IffvjiUadO49vy+l0lkhw==
X-Google-Smtp-Source: ABdhPJy2OORXX0ADGZfZfe5m8G4mo9LJFRteLkzOii3px8+JdHgVV5JvodnedcIn1T1ffYOLI7Q6xA==
X-Received: by 2002:a9d:170d:: with SMTP id i13mr21474885ota.106.1607986607540;
        Mon, 14 Dec 2020 14:56:47 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z189sm704369oia.28.2020.12.14.14.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 14:56:46 -0800 (PST)
Received: (nullmailer pid 2537300 invoked by uid 1000);
        Mon, 14 Dec 2020 22:56:45 -0000
Date:   Mon, 14 Dec 2020 16:56:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     devicetree@vger.kernel.org, marek.behun@nic.cz,
        f.fainelli@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org, lkp@intel.com,
        vivien.didelot@gmail.com, kuba@kernel.org, ashkan.boldaji@digi.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch,
        clang-built-linux@googlegroups.com
Subject: Re: [net-next PATCH v12 1/4] dt-bindings: net: Add 5GBASER phy
 interface mode
Message-ID: <20201214225645.GA2537239@robh.at.kernel.org>
References: <cover.1607685096.git.pavana.sharma@digi.com>
 <dbad3456b9c80a7f53d64b608ab69e4d4e0b2151.1607685097.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbad3456b9c80a7f53d64b608ab69e4d4e0b2151.1607685097.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 22:46:04 +1000, Pavana Sharma wrote:
> Add 5gbase-r PHY interface mode.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
