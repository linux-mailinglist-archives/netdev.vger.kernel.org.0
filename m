Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E894B290968
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410660AbgJPQL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:11:29 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35591 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407134AbgJPQL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:11:29 -0400
Received: by mail-oi1-f193.google.com with SMTP id w141so3012886oia.2;
        Fri, 16 Oct 2020 09:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rEAPxl1KjgfwVme9xwT1MzPMtYY7qqr5iqswWViBBoA=;
        b=bbFcIM5rX6uuJFdYkQ0K3HSej5LzoJsBuzalkzrCGjbZwpXWW0MWDaCKhWifVtNVKo
         RMW4PE0PURhAvCExsoHBzj7FV7AyOsVRh7tZjU5GUnlVdoPfPQDtLj9dqfwKaVibklnb
         xqxlcxhuBJ/0LxMm/YHOw7zxePUUGSXLCQLVlqQ4vq6qVa+A3N3oScvNcV1dHU/jFtMW
         rND3l+h33WATlK/1Od/Uysh8nofrmI6B3069uYE0blD0p7PxXkB4gNESbmPW6r2JNngb
         0GcYtFt4/7KTEGpznqPWhKDAoGl+wwcEZr4BP8LUWWl02MwImYT0neUVnHIO6kl7p4CC
         tzTg==
X-Gm-Message-State: AOAM531dLqg7vpY85NKMosAhr5r5xxL4AZg/q6vA+/Z1tU6fChDYOzlv
        jtnYOhXsWQI4jetjFz2SZveWrdQTcA==
X-Google-Smtp-Source: ABdhPJylcRl5VtXACVgCUXR3Yo/AvXoa+GOjkZt1qU4vIYR7pQmtadpwGpHRc3srxH8tyzjL0w9DTA==
X-Received: by 2002:a05:6808:10e:: with SMTP id b14mr3083547oie.152.1602864688191;
        Fri, 16 Oct 2020 09:11:28 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j10sm1082858ota.56.2020.10.16.09.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:11:27 -0700 (PDT)
Received: (nullmailer pid 1505308 invoked by uid 1000);
        Fri, 16 Oct 2020 16:11:26 -0000
Date:   Fri, 16 Oct 2020 11:11:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        devicetree@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/2] dt-bindings: can: add can-controller.yaml
Message-ID: <20201016161126.GA1504381@bogus>
References: <20201016073315.16232-1-o.rempel@pengutronix.de>
 <20201016073315.16232-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016073315.16232-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 09:33:14 +0200, Oleksij Rempel wrote:
> For now we have only node name as common rule for all CAN controllers
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/can/can-controller.yaml         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

./Documentation/devicetree/bindings/net/can/can-controller.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/can/can-controller.yaml#


See https://patchwork.ozlabs.org/patch/1383115

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

