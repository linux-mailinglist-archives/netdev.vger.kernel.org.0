Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A77315859
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhBIVJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:09:22 -0500
Received: from mail-oo1-f47.google.com ([209.85.161.47]:39055 "EHLO
        mail-oo1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbhBIUwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:52:53 -0500
Received: by mail-oo1-f47.google.com with SMTP id z36so10474ooi.6;
        Tue, 09 Feb 2021 12:52:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DB1HjKeqrbHOTghzkfcfAFWCp/DeUGeYQ1ovbopLxqQ=;
        b=Hb9IzZP66kI0I/f/ojuVa+ziU2Z9ltVfD6DH/nRWvUMSZ4UAAfvVB1L3tZKptom8QL
         O+cT6BuvlIiIW7i6e6t5VOIWefTbjFkhYZdbhdDiHMc0v4ykoUhTIKYGXGLxy00nchRM
         sbvgLPvtyHPNqL7EsQoTeq+L9u+vY3IXQ2DT/DgtgRvHz9vkNNTdUeYqFS3/Ka0atQwM
         B/72UAwyXs1Rgj5rGnvTjmZ8a2wJ8eKohwdpSA0vWbk1oV7UXFpyJV/zQlbEPoW87Vcq
         0d93SyRz+yqqHnU3+a3KTkck/5hia4P9W23OKsSCxp7R8eZwgLoRDxzLAuUcHlFcBxyN
         SKAg==
X-Gm-Message-State: AOAM530f9EyiOZTBJSFOKzcuPVju6xFTwokDbc34B5IiS4lpCk0ThFND
        4A1doL2NhBPn2PejOJNqV4zFZ4M7Qw==
X-Google-Smtp-Source: ABdhPJwuTXQzkOttxeaEVoXfeUOetz2hXU5ijPiUDla9stTo0MhZcfUXwnFcGsxN10b2mS9OTWMkjA==
X-Received: by 2002:a05:6820:414:: with SMTP id o20mr17288486oou.46.1612903911884;
        Tue, 09 Feb 2021 12:51:51 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a22sm4597367otp.53.2021.02.09.12.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 12:51:50 -0800 (PST)
Received: (nullmailer pid 157574 invoked by uid 1000);
        Tue, 09 Feb 2021 20:51:49 -0000
Date:   Tue, 9 Feb 2021 14:51:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH RESEND] dt-bindings: ethernet-controller: fix fixed-link
 specification
Message-ID: <20210209205149.GA157316@robh.at.kernel.org>
References: <E1l6W2G-0002Ga-0O@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1l6W2G-0002Ga-0O@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 01 Feb 2021 10:02:20 +0000, Russell King wrote:
> The original fixed-link.txt allowed a pause property for fixed link.
> This has been missed in the conversion to yaml format.
> 
> Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> 
> Resending now that kernel.org is fixed.
> 
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Applied, thanks!
