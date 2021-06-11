Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FCA3A494E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhFKTNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:13:01 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:46014 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFKTM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:12:58 -0400
Received: by mail-ed1-f42.google.com with SMTP id r7so23895936edv.12;
        Fri, 11 Jun 2021 12:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iI3T4VYcCTGvxD2ba4M9CJXzcAWWvc823xWrmRgeuus=;
        b=QAge+g67B2UApw2zWp870gBJL9v7BUMDvRzl1DQSIS5B4UTgm9BV6iz63gYKZP1ps3
         THqywD7q+ObJnNUPK89gRKR3a4Qhk+rR20PWds5pqLebhTeXRv0+qyGIBHwlWfbFNxZQ
         +cTSbUYLuJ72dd1d9Lf2p4JPdAEeTya11P1tn/jfoxdtsDWrpIr5576uvUdDgHEBNYQR
         0fRsR0fdOGoz67cN40JeadWn4s+3G3iljwk1kpV7WmQ0QjtcukfunaqCEDIwuzup0Cbq
         8l/fL8mJpuxLNcTcf2vIdy3tPWdtmX5fkWijtY8f9640UV0MkSncNEoNaGF/ShJJH9T4
         xrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iI3T4VYcCTGvxD2ba4M9CJXzcAWWvc823xWrmRgeuus=;
        b=FbfknaKlTRi/9iDYOvCoMGjqGEUWMVHox1uKjUtiWETaqOHV7iJsj8GPnaX77vb/vp
         pzUVbesY3Zcwm9eHU4HmQleo7hwAImHI3sSL4OcqYMQL5YGI4+Q3cWoKXLN3JyWUDqjU
         RPg/Cl/7AtvXsKMHmmFxl42dg/ekkIRZ+XHv1XBqk4MDCDO3qBoyxNhxK2HiHh18T067
         KTTdvTNORxYpLTjpjDe4RScKSVpnhCAbheIve1VTUvis2bCn19Stw6E+kf81GhUMUDxx
         cvt/cWcgN05WduOooC92XGUZccvjRzN5AhMuDF656PZb4TKZAQddlnEeJiY29JNTUh4q
         syrQ==
X-Gm-Message-State: AOAM532rg+fL5z1tgryJw7yYBWZvkCeG10/nzQ7VRCKbyxJs6/2vlJyf
        ws/ntAZSloOA85WgEFwMe8k=
X-Google-Smtp-Source: ABdhPJxub7FFXeXrsnokVDRbHm/raIefVqu9vFZ5ZjyMdQIKwGD+MDs1t/ao4XG8qepiXVNnJGKxgw==
X-Received: by 2002:a50:fe86:: with SMTP id d6mr5271882edt.141.1623438599272;
        Fri, 11 Jun 2021 12:09:59 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e24sm2370643ejb.52.2021.06.11.12.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:09:58 -0700 (PDT)
Date:   Fri, 11 Jun 2021 22:09:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v4 1/9] net: phy: micrel: move phy reg offsets
 to common header
Message-ID: <20210611190957.yijpabgf7t3hongd@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:19AM +0200, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> Some micrel devices share the same PHY register defines. This patch
> moves them to one common header so other drivers can reuse them.
> And reuse generic MII_* defines where possible.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
