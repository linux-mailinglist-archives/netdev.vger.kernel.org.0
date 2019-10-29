Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52E8E8D6F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403780AbfJ2Q7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:59:30 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36102 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403779AbfJ2Q7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:59:30 -0400
Received: by mail-oi1-f193.google.com with SMTP id j7so9539158oib.3;
        Tue, 29 Oct 2019 09:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WEljFb7fdnZ7H/05vl76i/wPX1q7/WajKC2wO1/piAU=;
        b=nZXXNNjy+EexryRB4bFSJYIgTFQAOwzQ7RnFyNFtfoYtyuQov5wDmhB5o93eImRLPX
         YgnmDba+laPHuJtOt1gWavzolkAxfMDUrDgDuMYwbs2xU/evaejmbBuc702y93dcOzTc
         o7OvhzGyIQ9UeJUm87Yx3TisEBiFP7WrusDiZuA4J4EfUjwjQzfvz0zfhC2OrP1X2ddD
         6YtPopAin1QwN6jceNQ4MtXP+DFSzPMhU/1t2c9Ry+PaZ4qSZLAbEQqZeNfEakdN/QwA
         Pd3mmBETWoCoYX/COMFciK7pSydBomuhIItyz31vdoarkkSQnfuAKGSfbbEhDIUTN8Pw
         G8aw==
X-Gm-Message-State: APjAAAX/250iOhF8iYB9SNfOO8lZe7V+joHurFPClvfpp26zXAduDdT+
        E5FquYCVOSADpSEU63z3SJm8gIM=
X-Google-Smtp-Source: APXvYqzZn8tr0orO+5cx6rMdFkShcbrABGLcIDgX+2WMu+I6/bo6/LAyDfAJE1DqoVUT6p1xLa0LDA==
X-Received: by 2002:aca:5015:: with SMTP id e21mr5136685oib.174.1572368368009;
        Tue, 29 Oct 2019 09:59:28 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o22sm4676415otk.47.2019.10.29.09.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:59:27 -0700 (PDT)
Date:   Tue, 29 Oct 2019 11:59:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: Convert Allwinner A10 CAN controller
 to a schema
Message-ID: <20191029165926.GA13915@bogus>
References: <20191022154745.41865-1-mripard@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022154745.41865-1-mripard@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 17:47:45 +0200, Maxime Ripard wrote:
> The older Allwinner SoCs have a CAN controller that is supported in Linux,
> with a matching Device Tree binding.
> 
> Now that we have the DT validation in place, let's convert the device tree
> bindings for that controller over to a YAML schemas.
> 
> Signed-off-by: Maxime Ripard <mripard@kernel.org>
> ---
>  .../net/can/allwinner,sun4i-a10-can.yaml      | 51 +++++++++++++++++++
>  .../devicetree/bindings/net/can/sun4i_can.txt | 36 -------------
>  2 files changed, 51 insertions(+), 36 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/sun4i_can.txt
> 

Applied, thanks.

Rob
