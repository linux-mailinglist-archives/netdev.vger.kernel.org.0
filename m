Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F41A71A6
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfICR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 13:28:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50262 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICR25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 13:28:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id c10so377478wmc.0;
        Tue, 03 Sep 2019 10:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=w+K4u8odsUFPax+hx2zddlYzhjzmD0FICwYsOGh0olA=;
        b=cNtJI/Jt7DHqIdgmuUg5lLy/m4T7YfAuV1Uh5CAeCrJTFaADChTMm0dvT7bW4s6jDg
         sHBLlvcYJKG/V04T/X9h2gqoDCDtf0kmDPOLQUHUTeZ25d7Regy+PwkAQAUg+FN2tHa/
         6aedAkPaIfoigyB3dxvgJ4MalWvXAIw2MgWm/RXDlafQU9riirAUDepHNokgEl1d3fFT
         rWrBMbGJkLZeTDm3Nn+zToaIMzkMq+wgxVoGbNdqo1whHqIONFfLnaxr8g4YQaJKGBda
         PhdM4ebYIVgYt49M3Tk0za7qreqcoRokpvAgW7FIruIkLY9xOEo8yJs+BvMyPgmE/24T
         wotQ==
X-Gm-Message-State: APjAAAUo0aKV1d9yzcLNGKmXTZC6nrF9atvdFz5n9l9VfBqcqCMWRTDl
        MfQhB6j/P6fusIPIpD/Ocw==
X-Google-Smtp-Source: APXvYqwPuaDBS6n+RBokvyyYviJLgi2039CDrIzaeWlaVrymSkQw9o6arf548BTNUXBQu9FsTGLNgQ==
X-Received: by 2002:a1c:4b14:: with SMTP id y20mr548705wma.10.1567531735329;
        Tue, 03 Sep 2019 10:28:55 -0700 (PDT)
Received: from localhost ([176.12.107.132])
        by smtp.gmail.com with ESMTPSA id u17sm19865544wru.25.2019.09.03.10.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 10:28:54 -0700 (PDT)
Date:   Tue, 3 Sep 2019 18:28:53 +0100
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] dt-bindings: net: dsa: mt7530: Add
 support for port 5
Message-ID: <20190903172853.GA14176@bogus>
References: <20190902130226.26845-1-opensource@vdorst.com>
 <20190902130226.26845-3-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190902130226.26845-3-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Sep 2019 15:02:25 +0200, =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= wrote:
> MT7530 port 5 has many modes/configurations.
> Update the documentation how to use port 5.
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>
> ---
> v2->v3:
> * Remove 'status = "okay";' lines, suggested by Rob Herring
> v1->v2:
> * Adding extra note about RGMII2 and gpio use.
> rfc->v1:
> * No change
> 
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 214 ++++++++++++++++++
>  1 file changed, 214 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
