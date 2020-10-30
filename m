Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5C82A0E78
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgJ3TUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:20:17 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42599 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgJ3TTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:19:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id h62so6529247oth.9;
        Fri, 30 Oct 2020 12:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=npMX/3Twp+gjExyPBTZmU+Vb5+6Ql89retevSrzN5dU=;
        b=C7ubNpK31o4c8+/Q8LpOsj2ixIE3R8g37bMC6kDwrcQlqa5iaDqqIe3w8pxzxu/QKS
         YnG10JOuc0+rNcbT3E09ztksBqFArm6+7cop+99kh1SxdThB0AJ3uoqsRBiz58crXXcU
         h2imqBZc3xPkG2CKRYJ9qnok+B+eawF5tt0XMBJiifcL5lXVgch26VAaVvR5sRJv0d0+
         oeFSp8zCdYrkd8xYrPLrc4ntIfK2kn+qG4n12gyrqT5EYVbyPGKvbonkkbX6NCEvmYy8
         702px7ebWDhz/B/P0tiBsBdhZnnn05V1zyBPkDeaGmB2lJTBRqUAIfIru5zbj65ozyS7
         CkVw==
X-Gm-Message-State: AOAM532WLZ1tzHVFzwXUqMDChw1P4Wbdvls7JQSiYcN/n52nMl8dhgH3
        WdsdpZ2I+sf59wPxsRko6A==
X-Google-Smtp-Source: ABdhPJxpc/qKs1ze/b9dGFwXKrmlxpStISFNxpijCXWebdbCpLmKC5ipga3nyE55XtR2Wml/X2FRZA==
X-Received: by 2002:a05:6830:1e34:: with SMTP id t20mr2851598otr.287.1604085552041;
        Fri, 30 Oct 2020 12:19:12 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t4sm1556808oov.15.2020.10.30.12.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 12:19:11 -0700 (PDT)
Received: (nullmailer pid 4174527 invoked by uid 1000);
        Fri, 30 Oct 2020 19:19:10 -0000
Date:   Fri, 30 Oct 2020 14:19:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 2/4] net:phy:smsc: expand documentation of clocks
 property
Message-ID: <20201030191910.GA4174476@bogus>
References: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 23:27:42 +0000, Badel, Laurent wrote:
> ﻿Subject: [PATCH net 2/4] net:phy:smsc: expand documentation of clocks property
> 
> Description: The ref clock is managed differently when added to the DT
> entry for SMSC PHY. Thus, specify this more clearly in the documentation.
> 
> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
> ---
>  Documentation/devicetree/bindings/net/smsc-lan87xx.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
