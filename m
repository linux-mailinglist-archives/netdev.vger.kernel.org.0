Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06152D4B4F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388098AbgLIUKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:10:34 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37023 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbgLIUKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:10:33 -0500
Received: by mail-ot1-f66.google.com with SMTP id o11so2652505ote.4;
        Wed, 09 Dec 2020 12:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CnQIK7QLR9HIawmYxyGceI161sRy0+j+9gk2A0bDIrk=;
        b=d4pdTNdXuiR1MTFwORavkR07ScgS+8jGt0Gs07xCdAeqU25kb0e/kg+gG1c+u6lAtY
         FGuM1PFMP5c8YvtCR8CX5hZnu2UbcyRK7Vmk52SbFkIqbMCiaN+B/fMwb9DnBpipRzBg
         DwndXPu4zl/zw4Sn56o0BJznTz7gYMEjaZeOzt6ysvzKCowli0fccflUoOtBECVhLYn1
         lTXDz4UiurDvo1yFHHF1sC6X65z96tQe1DwYxE1Fc2avt8FVh1DhgNwp8gY1S/PSmug1
         iBorl8GSp9vwNBJsYFcx4Z33lBnDUVZoh2/mbb3ikY5F+s1+ET7jLK8p3UmdJaJQMLLl
         QHzg==
X-Gm-Message-State: AOAM531F5qRDO9CusmYvM653F8TLDr0dT47PUFhVx4017mUuZGRQ0eGe
        WxJLKZPqARBuBJm+ua9rvw==
X-Google-Smtp-Source: ABdhPJzNnYvkdIKSeo62KHjX3cKdszP5u/d50c6QRfsYBIAge5xj1cbzPbbBYdbNxcg1ltnjrhXpNg==
X-Received: by 2002:a9d:7490:: with SMTP id t16mr3236135otk.323.1607544592511;
        Wed, 09 Dec 2020 12:09:52 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b82sm501669oif.49.2020.12.09.12.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 12:09:51 -0800 (PST)
Received: (nullmailer pid 859544 invoked by uid 1000);
        Wed, 09 Dec 2020 20:09:49 -0000
Date:   Wed, 9 Dec 2020 14:09:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Paul Barker <pbarker@konsulko.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Marek Vasut <marex@denx.de>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH net-next v5 2/9] dt-bindings: net: dsa: microchip,ksz:
 add interrupt property
Message-ID: <20201209200949.GA859466@robh.at.kernel.org>
References: <20201203102117.8995-1-ceggers@arri.de>
 <20201203102117.8995-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203102117.8995-3-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Dec 2020 11:21:10 +0100, Christian Eggers wrote:
> The devices have an optional interrupt line.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
