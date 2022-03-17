Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CAC4DC38E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiCQKFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiCQKFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:05:50 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F911DBABC
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:04:34 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 17-20020a9d0611000000b005b251571643so3188413otn.2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9nUpgzxfAbZV4T52RCZIvcr/DfDTjQKuSh0K5ZGlvE=;
        b=abPaoLiZdx3ecilJzTIn3NriIeqU+n/NqrMMgfuAwsp+ri8WrFq8OtBBEY+LuRvFIU
         voR/ua3F9ZYY5VmnR3McaCXrcsKN30qy7R+Kw4sBRq7t8/3Lo9E0B0GgD0Xe3Vxi/1CN
         Mma+OzbtzI+lWUv0QShxiANMoG5lgyn4GG8SY3q44pUZfCJ/oPKL0gnRmhZ+DEpCgBrB
         /2iz0p3/WQ9dBW7p6T4LwBhGfvTn9hu1ZvuGN6MrE/LBTD5Z/LPMapmRDpDarZKOrhet
         3QHOM3Qy7S9QAkfSuyQ61AcknUoVLr1JhXUVDYYHNbD0UVpv9/LrZUvXXUKNzwCzCPGL
         Q/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9nUpgzxfAbZV4T52RCZIvcr/DfDTjQKuSh0K5ZGlvE=;
        b=wvyezNSFoS3o0jplu8zu7P2FXyaqRqn6xEx/qkY4Xu472a6JGGL6tG1XFudpGoDc71
         6GNk4s24BrbR09SXFVQs5gOA5vZUMLogZDN89MUZb/Hpdt68v46X+LdDor1kq98EHJ7l
         PLGz8M+nLIDLENCCClu9sn1Ti64s716sgsJSJSSxZ0iK/FJK78dnHvhA7jbrDq+MzSnY
         TaCP4Bq/ERrXP9sX7LSY+UFm/al5yWaHLoIh67DbR7g/WUt04msPi7VFCUCz+IKNSicM
         YIrWfpau0lgeBDobwwAbzL2eMhIBWOaB/pWUyUIfkW/1tOAXUj70CVZnLIpySS2TEKX+
         GlNQ==
X-Gm-Message-State: AOAM533ZSpFuSGJ3EkwjzwKRLfVI0jU+d/XGOAV2CIwj+PtBq8vTC5Ns
        KNa2vYvGszEADw5j9RVxNhWCHhRT3MvFElKKESRmfA==
X-Google-Smtp-Source: ABdhPJzwfFzBhrRDqvgE0InBEBQROYhXvwuPi4voMAzEwABwx5FappeX8bR+bfRME3eYybKak2lxfWoQMRjHCMjQOTE=
X-Received: by 2002:a05:6830:1b78:b0:5c9:48b3:8ab with SMTP id
 d24-20020a0568301b7800b005c948b308abmr1288721ote.235.1647511473444; Thu, 17
 Mar 2022 03:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220317091926.86765-1-andy.chiu@sifive.com>
In-Reply-To: <20220317091926.86765-1-andy.chiu@sifive.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Thu, 17 Mar 2022 18:02:35 +0800
Message-ID: <CABgGipUd67TSoPz3eeKf2kXzzwy8NWJMkGYtkikdcBKiaJd8Bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle attribute
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, Robert Hancock <robert.hancock@calian.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

loop in: radhey.shyam.pandey@xilinx.com


On Thu, Mar 17, 2022 at 5:21 PM Andy Chiu <andy.chiu@sifive.com> wrote:
>
> Document the new pcs-handle attribute to support connecting to an
> external PHY in SGMII or 1000Base-X modes through the internal PCS/PMA
> PHY.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  Documentation/devicetree/bindings/net/xilinx_axienet.txt | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index b8e4894bc634..2a9a3a90eb63 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -68,6 +68,11 @@ Optional properties:
>                   required through the core's MDIO interface (i.e. always,
>                   unless the PHY is accessed through a different bus).
>
> + - pcs-handle:           Phandle to the internal PCS/PMA PHY, if a fixed external PHY
> +                 is tied to it in SGMII or 1000Base-X modes. This is not
> +                 required for SFP connection. The driver would use phy-handle
> +                 to reference the PCS/PMA PHY in such case.
> +
>  Example:
>         axi_ethernet_eth: ethernet@40c00000 {
>                 compatible = "xlnx,axi-ethernet-1.00.a";
> --
> 2.34.1
>
