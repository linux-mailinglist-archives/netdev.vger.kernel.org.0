Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6689A3159DC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 00:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhBIXFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 18:05:37 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:34999 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbhBIWyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:54:19 -0500
Received: by mail-ot1-f53.google.com with SMTP id k10so81012otl.2;
        Tue, 09 Feb 2021 14:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BdXrNYH73Jb2kpPTUcCxcN6nJbRmjpr252i7yRd/ggk=;
        b=I6j242afR1bGVHPA78DIpg36KAcDA6RH+YSBVIqsLS4nr/aA6pQTS6nAc5gRo3FIc5
         qlVtEZlMvhV82isi2+KB4Mje+JJOWQ40OndBxvVpethcd11a/OamQrIMXM4K+m3C/xlI
         okj26FgdNuFZNR9WrES4PH8ehIzJq4QiwSwkjUt9nSvgO3IGcpXOWX86od8nhtBJgZgM
         fktdz9cVPRYFbwKDi7frTlJb8pYstb/enyxpUA0EdbKlk9ZZGAtNZivjjGaFr7yclKV1
         zoQQxk4SzMFRsZBdZnxmm8KBNwMLVqRI4q8Lo3AvrkRDyup+elnw92zOHaKs9xIs2UZi
         0X/Q==
X-Gm-Message-State: AOAM531M9hfaz4kN636GZxNGm+JgK033W2wc36nvg/e8CxAY3ilvxmZm
        5S9uIm944qTp4VHjqghkyjqHHSSZEQ==
X-Google-Smtp-Source: ABdhPJwzuiohuTuCd8IQ8dk5kVshNfOVLhoaBlPjyV7EoguvkYCz0yVz+su4drcXtxGAADhkz3ARLA==
X-Received: by 2002:a9d:7514:: with SMTP id r20mr17267303otk.318.1612911157755;
        Tue, 09 Feb 2021 14:52:37 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o98sm641ota.0.2021.02.09.14.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 14:52:36 -0800 (PST)
Received: (nullmailer pid 372109 invoked by uid 1000);
        Tue, 09 Feb 2021 22:52:35 -0000
Date:   Tue, 9 Feb 2021 16:52:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-can@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: rcar_canfd: Group tuples in pin
 control properties
Message-ID: <20210209225235.GA371996@robh.at.kernel.org>
References: <20210204125937.1646305-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204125937.1646305-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 04 Feb 2021 13:59:37 +0100, Geert Uytterhoeven wrote:
> To improve human readability and enable automatic validation, the tuples
> in "pinctrl-*" properties should be grouped using angle brackets.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
