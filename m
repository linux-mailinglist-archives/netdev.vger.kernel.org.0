Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4AC3C8A0A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhGNRtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:49:15 -0400
Received: from baldur.buserror.net ([165.227.176.147]:60168 "EHLO
        baldur.buserror.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhGNRtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 13:49:14 -0400
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2021 13:49:14 EDT
Received: from [2601:449:8480:af0::97c7]
        by baldur.buserror.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <oss@buserror.net>)
        id 1m3iQJ-0004e6-4c; Wed, 14 Jul 2021 12:11:51 -0500
Message-ID: <63a72f648297e96c140a1412c20bd3796398a932.camel@buserror.net>
From:   Scott Wood <oss@buserror.net>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Jul 2021 12:11:49 -0500
In-Reply-To: <20210704134325.24842-1-pali@kernel.org>
References: <20210604233455.fwcu2chlsed2gwmu@pali>
         <20210704134325.24842-1-pali@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0::97c7
X-SA-Exim-Rcpt-To: pali@kernel.org, andrew@lunn.ch, linux@armlinux.org.uk, madalin.bucur@nxp.com, camelia.groza@oss.nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org, kabel@kernel.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
Subject: Re: [PATCH] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-07-04 at 15:43 +0200, Pali Rohár wrote:
> Property phy-connection-type contains invalid value "sgmii-2500" per scheme
> defined in file ethernet-controller.yaml.
> 
> Correct phy-connection-type value should be "2500base-x".
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the
> board device tree(s)")
> ---
>  arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> index 5ba6fbfca274..f82f85c65964 100644
> --- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> +++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
> @@ -154,7 +154,7 @@
>  
>                         fm1mac3: ethernet@e4000 {
>                                 phy-handle = <&sgmii_aqr_phy3>;
> -                               phy-connection-type = "sgmii-2500";
> +                               phy-connection-type = "2500base-x";
>                                 sleep = <&rcpm 0x20000000>;
>                         };
>  

Acked-by: Scott Wood <oss@buserror.net>

-Scott


