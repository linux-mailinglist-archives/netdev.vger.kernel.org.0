Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E102F6A9D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbhANTLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:11:44 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:37736 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhANTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:11:44 -0500
Received: by mail-oi1-f171.google.com with SMTP id l207so7061382oib.4;
        Thu, 14 Jan 2021 11:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OuweyPlkRjUfbMjqqh2CV+mLsPdrJqy3G1dkbVS1eZU=;
        b=Ji8ABhGHXtoWIj/TN+o/oWL/4H3wsSJMiy7jrgpAOiQsIF4Sc0dMevThp0q/wmnVC+
         HXF5bsAhGSMPT1dK/RV2GvxILKWJlLCPRPs0ueiM8mthp5rcBuEIlce/RJ5O4h1IXx6e
         1A2+F6TCiz3SBEYRcDJ31U7z6Mk4ibMB3AbtRiuUB7rohoYcqdK7JDc9ECgmm3H381dy
         +DrK4+DJKkxIqP5ADeM7mviEC6BKNvz4V+wFRGuLy96uGLwPxCELkJTHsic+zDm8bbfb
         Shb2mNdP1WRpUXV2O6UrUPb0D5YrBSceUlgSxS0SarkQUnn8X1W5EVHeEeIsGFQCgvQn
         TtvA==
X-Gm-Message-State: AOAM532XaRt/L/YKi8VN2qm7pmPekwtXNnPFymWRvNw2Kvmu52gJOlYM
        DqHhMfr3/zoCcahqEXTlzFTeG/BodQ==
X-Google-Smtp-Source: ABdhPJyCyN8iVoD3FUbCeTJenZbnGOUNr+ssedz+pYr3XOjuc6dn6KR63VcCPPxZ0XOw3w/v9MuUzw==
X-Received: by 2002:aca:c582:: with SMTP id v124mr3444409oif.115.1610651463114;
        Thu, 14 Jan 2021 11:11:03 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o135sm1234449ooo.38.2021.01.14.11.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 11:11:02 -0800 (PST)
Received: (nullmailer pid 3393424 invoked by uid 1000);
        Thu, 14 Jan 2021 19:11:00 -0000
Date:   Thu, 14 Jan 2021 13:11:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: add MT7530 GPIO
 controller binding
Message-ID: <20210114191100.GA3393390@robh.at.kernel.org>
References: <20210111054428.3273-1-dqfext@gmail.com>
 <20210111054428.3273-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111054428.3273-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 13:44:27 +0800, DENG Qingfang wrote:
> Add device tree binding to support MT7530 GPIO controller.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
