Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90A231982D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBLCFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhBLCFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7218D64DD1;
        Fri, 12 Feb 2021 02:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613095500;
        bh=dUQnAWDXK2sSMA87bJerv0/skVCkMl0cu43LXgrw0Ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rWPCwnEx7g1zHU0S+nJcaKczyAIuMBb3z615Ba1SvdFxjO0T3Cj1MSHw7uNNj5cmi
         A8AnGwfTNun1vwJrZdCruYkaPf9lOcMwAdOXqpwrPKRoRhnbLPoYO/imHPNiHGBbqf
         xzP1BsQtnA6LO2vd3idzFOi4sNS2wL3y4i8wGRNnHSLwJsHbvusJs73LqjMGPfRo5v
         vZFC2w1WpjqrYIHA8+sF12HEp/QZ0TqoOKZIF53wrVU5q8SMRh0Kag+j2UTf0QmcgL
         QOHL0srZPv1iPObXidm2Ck4ABgnAhH0vzb8oAQOHxA+lcWoP/Xuk8QnysdEqq7Tb31
         2bs6M5C3gCx9A==
Date:   Thu, 11 Feb 2021 18:04:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net:ethernet:rmnet:Support for downlink MAPv5 csum
 offload
Message-ID: <20210211180459.500654b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
        <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 03:05:23 +0530 Sharath Chandra Vurukala wrote:
> +/* MAP CSUM headers */
> +struct rmnet_map_v5_csum_header {
> +	u8  next_hdr:1;
> +	u8  header_type:7;
> +	u8  hw_reserved:5;
> +	u8  priority:1;
> +	u8  hw_reserved_bit:1;
> +	u8  csum_valid_required:1;
> +	__be16 reserved;
> +} __aligned(1);

Will this work on big endian?
