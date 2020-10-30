Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D3E2A09EF
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgJ3PfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:35:02 -0400
Received: from mail-oo1-f66.google.com ([209.85.161.66]:40827 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgJ3PfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:35:01 -0400
Received: by mail-oo1-f66.google.com with SMTP id p73so1679042oop.7;
        Fri, 30 Oct 2020 08:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f7OS+EUFbhEQuDFaM2eG8nGD2Rlqz1agmq6gIIYsHNU=;
        b=FKqQF4zO2QMsVfu25lKnMzSaQJm+zolLV0KcsGDBvzfjVbS3gZx6pXAFnVg4Mfq7/r
         LOeVrBn8w6Bxy4rolwn6zGJZqIgN6jxT0/kieOesUHEolE3d7qzaI/L2i4+vpOCStufQ
         QiXwW4DnUQiXdRt5wXCMPOVPooQfvB4jVpNtOKW9qkwVvw5qrXYC/eGNxGp3nSkavtIn
         vBClA/6oIch3NEgujkxre6dXMkbwoHioTOFKxGn4ipmluu/WDgbIE6rd2OsXJGSSAcoz
         NwHa2pkqDMXh8uXoVTw+BPZMGe1yxxrVQ1iKGrTweOxaLw9rNvQHkz7/JaGjYxEsxkTS
         vAzA==
X-Gm-Message-State: AOAM532IqU1SSVAsz2PERTo8vv3xm/YtQEDZFV29xJdrmSPf+egDsdix
        /6kp6eyw0jq5wSCCHjlVIA==
X-Google-Smtp-Source: ABdhPJzlmsd1EZXiMrMHIP+mMaqrNBgk1i7G9ZMk3nQVkT6gvmO8VRXAOHSZ12zpEyoTI2UhasQRHw==
X-Received: by 2002:a4a:ba10:: with SMTP id b16mr2321785oop.75.1604072100632;
        Fri, 30 Oct 2020 08:35:00 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p17sm1433277oov.1.2020.10.30.08.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:34:59 -0700 (PDT)
Received: (nullmailer pid 3885667 invoked by uid 1000);
        Fri, 30 Oct 2020 15:34:59 -0000
Date:   Fri, 30 Oct 2020 10:34:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>, kernel@pengutronix.de,
        mkl@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: can: add can-controller.yaml
Message-ID: <20201030153459.GA3885616@bogus>
References: <20201022075218.11880-1-o.rempel@pengutronix.de>
 <20201022075218.11880-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022075218.11880-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 09:52:17 +0200, Oleksij Rempel wrote:
> For now we have only node name as common rule for all CAN controllers
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/r/20201016073315.16232-2-o.rempel@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  .../bindings/net/can/can-controller.yaml       | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
