Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D210B4748FC
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhLNRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:13:27 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:37608 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhLNRN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:13:26 -0500
Received: by mail-ot1-f49.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so21566256otg.4;
        Tue, 14 Dec 2021 09:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XgyDvIguawpGpPiLnkMUQAqaUkuE+oDjLxhmm8AED0o=;
        b=cfFs6MYehtdaAk0/TG2iNNm4Pi5MZM8LKAclr7aDa7tiDCo0OmhBEmvZw4yO9RHLSN
         2sw7CHWHuLFC2GG6xLdO6wukyNI+hV3XX5ME7zb5odV4UtoqQO5jD9OGEUuiBgIxTK5I
         r4ItjfPfgs3k++mW/B/mPa31ksHdTDn7C75eYiTNlnp2ANy2IisbV31ZgLuhpOD2+gCc
         Zx8hmtIF4OngtaZS0jnJOUZQbPBthMfg7m7WFO2cq06W5xwv7Em7Lcv3BqQ8OGV3sxnr
         f3/BuN7aNA61BZInv5ssr46PpNTuf0YUGmglHF8EiAWSrKo0kDKV/CCns1KDM1wuN6n5
         Z3zA==
X-Gm-Message-State: AOAM5335WCsJggA2PW8r+/Q3cwarbcX/GYutRy9Bv58uoQUoH/xAhejB
        KJ8tWKEukZElse7vbmJzMYrn3fRuGQ==
X-Google-Smtp-Source: ABdhPJyAckwKtk2wmFYXo6y0KbBYQM8cVlvJ/bfKpPemke7He1uMLWSoaQXS9+lNxlD7t0/ISfJOSg==
X-Received: by 2002:a05:6830:449e:: with SMTP id r30mr5389712otv.120.1639502005623;
        Tue, 14 Dec 2021 09:13:25 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r26sm64300otn.15.2021.12.14.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 09:13:25 -0800 (PST)
Received: (nullmailer pid 3567854 invoked by uid 1000);
        Tue, 14 Dec 2021 17:13:24 -0000
Date:   Tue, 14 Dec 2021 11:13:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        wells.lu@sunplus.com, netdev@vger.kernel.org,
        p.zabel@pengutronix.de, robh+dt@kernel.org, kuba@kernel.org,
        vincent.shih@sunplus.com, davem@davemloft.net
Subject: Re: [PATCH net-next v5 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
Message-ID: <YbjQtOJW82EKFTNU@robh.at.kernel.org>
References: <1639490743-20697-1-git-send-email-wellslutw@gmail.com>
 <1639490743-20697-2-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639490743-20697-2-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 22:05:42 +0800, Wells Lu wrote:
> Add bindings documentation for Sunplus SP7021 SoC.
> 
> Signed-off-by: Wells Lu <wellslutw@gmail.com>
> ---
> Changes in v5
>   - Addressed comments of Mr. Rob Herring.
> 
>  .../bindings/net/sunplus,sp7021-emac.yaml          | 149 +++++++++++++++++++++
>  MAINTAINERS                                        |   7 +
>  2 files changed, 156 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
