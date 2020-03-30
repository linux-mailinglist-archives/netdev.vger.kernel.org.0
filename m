Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A474197FE0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgC3Pjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:39:51 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:39891 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729398AbgC3Pjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:39:51 -0400
Received: by mail-il1-f194.google.com with SMTP id r5so16224709ilq.6;
        Mon, 30 Mar 2020 08:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W6rZXeVDXuiNB2eyzP6KmsiWKTclilo12JD/by0Xhl0=;
        b=Mlfn2BhjX8eDqA22OA7Vl6fBctKJ+QNZ9XbgMwLcFFniJpB3r4rabf3nyENn2wCv73
         sMqHjkafKgA6AmRhO7+D2s9oPBqnSZEtKPWsejwNw3E7pctcjgSYSkxZaPI7aLnMUjNQ
         DX2SsxEfJHMpxN/Sgv+HCg0xOe+HUNwKQbmK0qa0JPHkhziEJPeJHEyb5EPfMfe1QGc/
         PJZ0SKhacud2cnbsD7K1DhsNZlzM+ByrQYQcvxWMMYDKTGEwDsSztLYmoBQqqLOYUO5E
         VegKKqaXHviFDTgyWlb5lSEo9O8F65xATYxKYmo7kBZ4mkhkb1EXZTGy31rnWVQHxuLd
         RJyA==
X-Gm-Message-State: ANhLgQ0j2dXXPJLhF3d/mfTveQjYBXPoTcpqD2NAyD8JkFO8JeiXYv5g
        fvLXxgk4gqZVeo1Pt0MPuQ==
X-Google-Smtp-Source: ADFU+vuVQIgPaf1Ao71iRH8paXsYDjItwWB3E5W7tkX2cZKV+GuUz/WVjODL+5u2LtNfZTgwONZfnw==
X-Received: by 2002:a05:6e02:e89:: with SMTP id t9mr12192934ilj.83.1585582789835;
        Mon, 30 Mar 2020 08:39:49 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id n8sm2216453ilm.12.2020.03.30.08.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 08:39:49 -0700 (PDT)
Received: (nullmailer pid 21313 invoked by uid 1000);
        Mon, 30 Mar 2020 15:39:45 -0000
Date:   Mon, 30 Mar 2020 09:39:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt bindings
Message-ID: <20200330153945.GA20686@bogus>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 15:51:15 +0200, Florinel Iordache wrote:
> Add ethernet backplane device tree bindings
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  .../bindings/net/ethernet-controller.yaml          |  3 +-
>  .../devicetree/bindings/net/ethernet-phy.yaml      | 53 +++++++++++++
>  Documentation/devicetree/bindings/net/serdes.yaml  | 90 ++++++++++++++++++++++
>  3 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

Documentation/devicetree/bindings/net/serdes.yaml:  mapping values are not allowed in this context
  in "<unicode string>", line 30, column 62
Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/net/serdes.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/serdes.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
Documentation/devicetree/bindings/net/ethernet-phy.yaml:  mapping values are not allowed in this context
  in "<unicode string>", line 179, column 20
Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/net/ethernet-phy.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/ethernet-phy.example.dts] Error 1
warning: no schema found in file: Documentation/devicetree/bindings/net/serdes.yaml
warning: no schema found in file: Documentation/devicetree/bindings/net/ethernet-phy.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/serdes.yaml: ignoring, error parsing file
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-phy.yaml: ignoring, error parsing file
Makefile:1262: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1261991

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.
