Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3110342051E
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 05:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhJDDuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 23:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhJDDuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 23:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F17B611C2;
        Mon,  4 Oct 2021 03:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633319301;
        bh=aU5ALILGWNnuMRsq51D5OEKIBLqWVkxkH+BrRSI/PIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsgqILalkDVrcrBo+KTQEBUzvm6JqeaRE6YlJGEbK07W85m8AlQX45zjKqSwCusuK
         mWqgqfJLmlBBzcJ38zQ9av9QpCLL2AMxiq9vthtFSbQuwKTiA3rEjXj0yFU2+Avk43
         WViJtVYPDou5rusk3UTcPcEyaO6fHjkhRUeDs9bUM6dr5UZdDYaU/+PU/Xr9P5S6U4
         UyjCFgSXb8AdIcpUInZzkuovsAwy4G+lmSOn3GLqCu6TMGC8NajyE9LzadCuLjEZfU
         dSb10LlBqKk9BJgmGeFsin7UvC4K38IeKAj6yonyH418w1RnqNmIbiHE99mnYFncJ0
         vfzEGGcBat49w==
Date:   Mon, 4 Oct 2021 11:48:16 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH devicetree 1/2] dt-bindings: arm: fsl: document the
 LX2160A BlueBox 3 boards
Message-ID: <20211004034815.GC15650@dragon>
References: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 11:27:21PM +0300, Vladimir Oltean wrote:
> Document the compatible string for the LX2160A system that is part of
> the BlueBox 3. Also add a separate compatible string for Rev A, since
> technically it uses a different device tree.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/arm/fsl.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
> index 60f4862ba15e..d31464df987d 100644
> --- a/Documentation/devicetree/bindings/arm/fsl.yaml
> +++ b/Documentation/devicetree/bindings/arm/fsl.yaml
> @@ -979,6 +979,8 @@ properties:
>            - enum:
>                - fsl,lx2160a-qds
>                - fsl,lx2160a-rdb
> +              - fsl,lx2160a-bluebox3
> +              - fsl,lx2160a-bluebox3-rev-a

It would be nice to keep them alphabetically sorted.  I fixed it up and
applied the patch.

Shawn

>                - fsl,lx2162a-qds
>            - const: fsl,lx2160a
>  
> -- 
> 2.25.1
> 
