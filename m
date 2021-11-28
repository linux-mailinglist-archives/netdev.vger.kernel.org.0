Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C52460B57
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 01:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359726AbhK2AFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 19:05:08 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:36573 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359713AbhK2ADG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 19:03:06 -0500
Received: by mail-oi1-f170.google.com with SMTP id t23so31223129oiw.3;
        Sun, 28 Nov 2021 15:59:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HkopmSmImQ8w6mneEpJv7+5TiqS3kp9uVIPZgZsG7ps=;
        b=3fU4n8Rxu4OwvU+L2CtwvEzCzGul/DifxgKbahR+Maxrj8BCuJktzwyR8XDbPGe1X2
         bC3BtmFuaaweglAFb2Yn7JJBox+jNM9eDqInr6xxRZCR6y/uUuaTv1+jewq5ruvxbbpc
         iuSOpMrTyI4edwY6frvx/vJh+BrJxn+IKEZuwhLuN8WSwchvCqi4czaVfQPu/YIzDTBl
         qgWolUKLga7HZJijTgrlHgvuLlu+fB0iaI7efBRhpu4DDAtJMKw2adFFhYYEI67FKBX1
         uar8nnAkLxje4TJEsg2lFhqRZeTvl5av+kEFYOQfaIDfXXjJHNDFju4wDRrdhUTgSJBp
         pUWg==
X-Gm-Message-State: AOAM531ZDEBCcNfgHFaBA4xdC9/DDEWhCDmJoEAHCK5owW5sFLp3jmIf
        M98xoI+x2GmxlVrDeeT6/U5GCsjW5A==
X-Google-Smtp-Source: ABdhPJymWGC3cRGmk+z8SQTahYVCKdbAjCOPFeTlz8NYWGEtEd6izZ2utwiI4HU88YCnD1tXXW8siw==
X-Received: by 2002:aca:1b08:: with SMTP id b8mr36306600oib.148.1638143989603;
        Sun, 28 Nov 2021 15:59:49 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fe7:4487:d1b1:985f:1f68:141e])
        by smtp.gmail.com with ESMTPSA id j5sm2077075oou.23.2021.11.28.15.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 15:59:48 -0800 (PST)
Received: (nullmailer pid 2843741 invoked by uid 1000);
        Sun, 28 Nov 2021 23:57:41 -0000
Date:   Sun, 28 Nov 2021 17:57:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
Subject: Re: [PATCH v3 4/7] net-next: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
Message-ID: <YaQXdaXzJ3LD7ab2@robh.at.kernel.org>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
 <20211112093918.11061-5-biao.huang@mediatek.com>
 <04051f18-a955-9397-d94e-0c61fc8f595b@gmail.com>
 <5f6fec21ef9f2bca6007283b37e35301cfe745ed.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6fec21ef9f2bca6007283b37e35301cfe745ed.camel@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 11:09:55AM +0800, Biao Huang wrote:
> Dear Matthias,
> 	Agree, converting and changes should be seperated.
> 
> 	There are some changes in the driver, but mediatek-dwmac.txt
> 	
> is not updated for a long time, and is not accurate enough.
> 
> 	So this patch is more like a new yaml replace the old txt,
> 	than a word-to-word converting.
> 
> 	
> Anyway, only 3 little changes compare to old mediate-dwmac.txt, 	others
> almost keep the same:
> 	1. compatible " const: snps,dwmac-4.20"
> 	2. delete "snps,reset-active-low;" in example, since driver
> remove this property long ago.
> 	3. add "snps,reset-delays-us = <0 10000 10000>;" in example, 
> 
> 	Should I split this patch? 
> 	If yes, I'll split in next send.
> 	Thanks.

It's fine with one patch, but describe the changes in the commit msg.

Rob

