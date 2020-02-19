Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8540164FF7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgBSUfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:35:32 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40509 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSUfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:35:32 -0500
Received: by mail-ot1-f68.google.com with SMTP id i6so1473068otr.7;
        Wed, 19 Feb 2020 12:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wtDIKILIP+uU1BnQ4PlhfoOLvW8WzFAlPwrAgy9AVF4=;
        b=s2EEy63oMpy6lNm/8azbN4gvBIfEflcdhnreqjnTNRRK44yMnpIK9J5FVW+2SlnThl
         IVrBM+2Nv34YPj5WFh1V09pn+C4/a15ze7EY7U5JsRFwryVTU1SzEMsfRq+FlFQFlfYi
         nnLxk1QyJ+HlaIlUfrs7PdoMIwOqMapIu0jYnGiYzHvEJJaZ85ho+3mlD9T6HBWL3quq
         Z5qiKMrgHX8ITuidwsmFY5bmwCBS+OdH981S3U1kJ+nMYfNjH3Pvui7RPJqukrs8n1VS
         WvJEfRzqDQ1Z43jWB+St4BuBFOWb0qnc67kL6AjbRW8G4WHECTCch76esKYmhLCmXzSv
         ThEA==
X-Gm-Message-State: APjAAAWCB9aPVbNxdsjtY4ezSm/qTA/K0txdPjBu/xWflPnNw60tFGAH
        Th4mc/R3YPaHUXxvhiDSVA==
X-Google-Smtp-Source: APXvYqy8RF8sZufK1Y09hIvIcitju60UCY2VX3BG5jLj7GOEMFRFaSV+4rvpbXw5Ae3GeKIvehtg/g==
X-Received: by 2002:a9d:6f0a:: with SMTP id n10mr21673386otq.54.1582144530975;
        Wed, 19 Feb 2020 12:35:30 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p83sm323666oia.51.2020.02.19.12.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:35:30 -0800 (PST)
Received: (nullmailer pid 25307 invoked by uid 1000);
        Wed, 19 Feb 2020 20:35:29 -0000
Date:   Wed, 19 Feb 2020 14:35:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Faiz Abbas <faiz_abbas@ti.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        catalin.marinas@arm.com, mark.rutland@arm.com, mkl@pengutronix.de,
        wg@grandegger.com, sriram.dash@samsung.com, dmurphy@ti.com
Subject: Re: [PATCH v2 1/3] dt-bindings: m_can: Add Documentation for
 transceiver regulator
Message-ID: <20200219203529.GA21085@bogus>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-2-faiz_abbas@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217142836.23702-2-faiz_abbas@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 07:58:34PM +0530, Faiz Abbas wrote:
> Some CAN transceivers have a standby line that needs to be asserted
> before they can be used. Model this GPIO lines as an optional
> fixed-regulator node. Document bindings for the same.
> 
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> ---
>  Documentation/devicetree/bindings/net/can/m_can.txt | 3 +++
>  1 file changed, 3 insertions(+)

This has moved to DT schema in my tree, so please adjust it and resend.

> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
> index ed614383af9c..f17e2a5207dc 100644
> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
> @@ -48,6 +48,9 @@ Optional Subnode:
>  			  that can be used for CAN/CAN-FD modes. See
>  			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
>  			  for details.
> +
> +- xceiver-supply: Regulator that powers the CAN transceiver.

The supply for a transceiver should go in the transceiver node.

> +
>  Example:
>  SoC dtsi:
>  m_can1: can@20e8000 {
> -- 
> 2.19.2
> 
