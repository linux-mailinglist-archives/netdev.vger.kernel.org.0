Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79EB45E83
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfFNNkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:40:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44161 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFNNkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:40:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so2564619wrl.11;
        Fri, 14 Jun 2019 06:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O95rFqLmx1gqmD991RSkp9dv9JMLhJuRBvQiIY9txys=;
        b=TBo/puD0AiTUj7kjtDuN2aDY14/t3jTB1niCkcBBUxESNbse7A7m6G20K1Yhp1VLVu
         mLpv8ZsVu6FYT0UxrLNvQbfyFtZzox3o/IO+0l1XQZFkjqlXl1NJ12c7zn7nGpvlrnlM
         C3QMnlXe/tTNjQq+xuMHV4dnBR8kQq/oJlnh1UXRIwRORgskahTZHznv7glWGnALwIc+
         MIXPdLTjs3Wr4m9QCcuIt05CAqPCcjo1x22Cn5/YDhjwgkcekxtWMwgx43U8m5r2VHz7
         eG4jyipd02vIOGRkZtn1lNQqIss7hhhFF0KRCi91fQgqfranOV0xWVBL05Izl2+qtnvP
         VbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O95rFqLmx1gqmD991RSkp9dv9JMLhJuRBvQiIY9txys=;
        b=RAl6KLD4SdtCS2OkDTt8zFrbttVAB6E8mcGt8I3oiaZEfBFzuq5kuu9aSRXo2ef7F5
         gCQSpWf9pivhW2bb7lZb8Cmlg4mBslPKwNZs3IN9A8ckRAXB/Jq2LKzSMYEwaU8x7Zn8
         2emh+EB8m0ubhJ+J5xSFfN2X//UHQ2WqoIZs/aYyZkJKmCJS/UsW+KLtGvARCD70fWsx
         i0hEHbB+/iXGSfLPwACLZfxhvfgQFdrHaBY3YinwNYOokXALFVu0UEsV6qbhSPD8tjjt
         9zdbKzV+ozWMbTNnwq2L9ArPfnKptXxLwRO2I6qVJTa102976pOuD6gEwr3EyWQH4yL5
         Jw0A==
X-Gm-Message-State: APjAAAWjKDdtbQv7+inMBnZpmSKQpfkE0QwUn/Tzymf7vFjSnGuyNzug
        6xuBDuu/43wm0ZV9JMAdOZp9ADTP
X-Google-Smtp-Source: APXvYqwzmbPwga2XEwdlUs1cn3pn+IMhBq1GeEEfryrM3dZCSdwqikTbPz3P7LgC6VCpsfauNimzCg==
X-Received: by 2002:adf:81c8:: with SMTP id 66mr62002750wra.261.1560519635241;
        Fri, 14 Jun 2019 06:40:35 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v204sm4946108wma.20.2019.06.14.06.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:40:34 -0700 (PDT)
Date:   Fri, 14 Jun 2019 15:40:28 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Message-ID: <20190614134028.GB23409@Red>
References: <cover.1560266175.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560266175.git.joabreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 05:18:44PM +0200, Jose Abreu wrote:
> [ Hope this diff looks better (generated with --minimal) ]
> 
> This converts stmmac to use phylink. Besides the code redution this will
> allow to gain more flexibility.
> 
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Jose Abreu (3):
>   net: stmmac: Prepare to convert to phylink
>   net: stmmac: Start adding phylink support
>   net: stmmac: Convert to phylink and remove phylib logic
> 
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   3 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +-
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  81 +---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 391 ++++++++----------
>  .../ethernet/stmicro/stmmac/stmmac_platform.c |  21 +-
>  5 files changed, 190 insertions(+), 313 deletions(-)
> 
> -- 
> 2.21.0
> 

Hello

since this patch I hit
dwmac-sun8i 1c30000.ethernet: ethernet@1c30000 PHY address 29556736 is too large

any idea ?
