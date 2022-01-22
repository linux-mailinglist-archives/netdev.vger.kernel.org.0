Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F75496917
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiAVBJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:09:02 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:44730 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiAVBJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:09:00 -0500
Received: by mail-ot1-f52.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso13856311otb.11;
        Fri, 21 Jan 2022 17:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zzhzglmsoAM7Ny9GaYHPX3KggB0T0RmcO/TZVXvApo4=;
        b=TIH04tp+UerCyyqUJCzA+VkJGMWqdDPORTa8U3EAOvSHeR/vOG1Kq8lJaw0my/5LxR
         Fd9OVl9ewdVKxgZgv4SLy90R833duCY4+WKW/t9sWXBuYuIMVZIhOKtAILwVTyjeVjqB
         AZX/7BmZRoRrRh40lJj0cCE/Q0+wx65G4/OXGbOCGtp5ih3AnKPqPU5Yz6Fck8uTKN0z
         vXM3CCIz+l5mbr4FyyvyYpGutXCGACcNvUZTm5UV9WdvXWobeUvvQ0Z6fnprVLu24X30
         6VTLJXslJdqECTGp9tdFPtKt3PrP8r13k3ejILRnpU3Y1RJVIcopsbl08hRmeOnUd9Dc
         ehxA==
X-Gm-Message-State: AOAM533LDE/g1SjlGkbeLxica3wRdjRGxjydwY+7kiCmsR2Zf3Rt1YCA
        OsW6lmdu2nfSf2KZANoKCg==
X-Google-Smtp-Source: ABdhPJyLDbAkOUdPRhZDwPr94FDjb9zmxxOfhr+SGVS+I7nZM9u0m88j7NWUBV4a09q+sOUSGH9Mgw==
X-Received: by 2002:a9d:74c2:: with SMTP id a2mr4408801otl.23.1642813739978;
        Fri, 21 Jan 2022 17:08:59 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k14sm1538003ood.15.2022.01.21.17.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 17:08:59 -0800 (PST)
Received: (nullmailer pid 1975721 invoked by uid 1000);
        Sat, 22 Jan 2022 01:08:58 -0000
Date:   Fri, 21 Jan 2022 19:08:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, marex@denx.de, woojung.huh@microchip.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com, olteanv@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 1/2] net: dsa: microchip: Document property to
 disable reference clock
Message-ID: <YetZKi0nfphamvkd@robh.at.kernel.org>
References: <20220112182251.876098-1-robert.hancock@calian.com>
 <20220112182251.876098-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112182251.876098-2-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 12:22:50 -0600, Robert Hancock wrote:
> Document the new microchip,synclko-disable property which can be
> specified to disable the reference clock output from the device if not
> required by the board design.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
