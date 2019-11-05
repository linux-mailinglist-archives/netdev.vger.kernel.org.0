Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15926EF322
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfKEB7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:59:39 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33030 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbfKEB7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 20:59:39 -0500
Received: by mail-ot1-f67.google.com with SMTP id u13so16306924ote.0;
        Mon, 04 Nov 2019 17:59:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cp6fhNM7KdYvvK5b7iPPVRi7PA69F5kheAydJPVgeXA=;
        b=Uobnl6ebnQ6gW/4p37qXPuc/33JqWqz0lm0T2+phnzUiwTOI2ZzL1XG0Ttq+DVzmyp
         rwfEWTLx5880bhn9Us2HPM8YmDbKcLHM/2fswjWsr5I1UlPPfx3rXn4Aa7OZdGf8IofP
         SNUtY4F15vHoJrrfyWARvL9fe5Pw9jBUP8Aa0EKF5lKsj2IBqOWDSYDFpkDDuUWM1Yvq
         r1vNltlbmygmINUB8DRsi1/guk0n+8USgwMIr1ZryjrRA2A8FefxyT9OD6Z6rJE3QqlC
         ds8nLJd4Z4nbUeurTpvhCl5whaXahTIkNjIsMNOQCR8JFwefowHQCWiV0j5gDQ7fAdSW
         qBKw==
X-Gm-Message-State: APjAAAWs5pA0QSHfuLvMvpJSji645kmV1FouexBmxR7oO36f0281PhvB
        QKquqFduU1zixklS1OPtioNNpwA=
X-Google-Smtp-Source: APXvYqyAqEZxKaDBS7/K7JVSPoKNZ/QDCcAAP8gainROJM3u3UZb6yb2XdytdU+zur7E59YO27Bvpg==
X-Received: by 2002:a9d:5e06:: with SMTP id d6mr20196663oti.242.1572919178130;
        Mon, 04 Nov 2019 17:59:38 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k24sm5217744oic.29.2019.11.04.17.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 17:59:37 -0800 (PST)
Date:   Mon, 4 Nov 2019 19:59:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     vincent.cheng.xh@renesas.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [PATCH v4 1/2] dt-bindings: ptp: Add device tree binding for IDT
 ClockMatrix based PTP clock
Message-ID: <20191105015936.GA17377@bogus>
References: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 23:20:06 -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add device tree binding doc for the IDT ClockMatrix PTP clock.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
> Changes since v3:
>  - Reported-by: Rob Herring:
>    1. Fix dtbs_check error: Warning (reg_format):
>           /example-0/phc@5b:reg: property has invalid length
> 
> Changes since v2:
>  - As suggested by Rob Herring:
>  - Replace with DT schema
>  - Remove '-ptp' from compatible string
>  - Replace wildcard 'x' with the part numbers.
> 
> Changes since v1:
>  - No changes
> ---
>  .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 69 ++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
