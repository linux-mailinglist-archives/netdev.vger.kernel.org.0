Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66A5462A24
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbhK3CH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:07:26 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:38455 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhK3CH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 21:07:26 -0500
Received: by mail-oi1-f182.google.com with SMTP id r26so38232280oiw.5;
        Mon, 29 Nov 2021 18:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=czCiSapCpC1ZIvsPphO1KjyVFpX/z//ZHS0Jc60UptA=;
        b=GLDE/tfLALk+NixryfN7jY/bjuDX6uPkwRXyhUxLmK3J02vFpognmAMZWEazC/BYg/
         7WC0HIcj/PjXFG+ImsrTE+2A3Tgb2Q9CRFiDDKt16j/F8bhrox8BXCltyZkLOn3kSLS0
         yXhWxRIDFJXqZTN2RwSqfVY3djt8qYqqypQvCru1VYdv20rhrZXnk6qM0ASlzndIbLNI
         dQ1WKl0yf4NtCFrLiNEmoIanItiMNSLkyKNgHoIwkDF6qwWaS5RPxKn1m79s93OJwLQp
         9kfC3ojtI+dX5xK/ZfUFPoegE3SwCcENjFfxG5MNYviehdsIp1rsfw2vApkBJxP2ZRQ4
         RNyQ==
X-Gm-Message-State: AOAM531xeNQMVABcRl/fH9FuxcEMV2oS2q99aNDS+BMNCYaog/Tvgehr
        2G5iv7klj8eMR9RZ1PYBsQ==
X-Google-Smtp-Source: ABdhPJzxyFlJyd6GE7XQrZGGCNB62CR0g7xUjbjFBxKZCroK2jEq4r6L+XbxEhE+lyhqrUWoFf9I5Q==
X-Received: by 2002:aca:eb53:: with SMTP id j80mr1569933oih.85.1638237847280;
        Mon, 29 Nov 2021 18:04:07 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a17sm3397341oiw.43.2021.11.29.18.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 18:04:06 -0800 (PST)
Received: (nullmailer pid 1025600 invoked by uid 1000);
        Tue, 30 Nov 2021 02:04:05 -0000
Date:   Mon, 29 Nov 2021 20:04:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     qiangqing.zhang@nxp.com, festevam@gmail.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        shawnguo@kernel.org, s.hauer@pengutronix.de, linux-imx@nxp.com,
        robh+dt@kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, Peng Fan <peng.fan@nxp.com>,
        aisheng.dong@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] dt-bindings: net: fec: Add imx8ulp compatible string
Message-ID: <YaWGlfHnKKEWrbLG@robh.at.kernel.org>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-3-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120115825.851798-3-peng.fan@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 19:58:23 +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> The fec on i.MX8ULP is derived from i.MX6UL, it uses two compatible
> strings, so update the compatible string for i.MX8ULP.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
