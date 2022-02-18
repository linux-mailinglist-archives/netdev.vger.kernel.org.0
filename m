Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7D4BB084
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiBREJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:09:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBREJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:09:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5041BED95C;
        Thu, 17 Feb 2022 20:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DECF861DF7;
        Fri, 18 Feb 2022 04:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03152C340E9;
        Fri, 18 Feb 2022 04:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645157326;
        bh=vLLdAn1it+wYrS6TKmraZumSvbyzaXa30UTwqq7iYA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D7+zxR4EoKm1tTZKXkSIbYWlZxn9LZgOHNDOMfXOrNttJRWQDDAynwxSuy+oRytkJ
         28UmikUB+mAuHNCyjeXXAzl6+HtkPoKWreRrG+/E0xLgY6L7mFL5CIlHdpslYOIXsL
         qigLbeYE5bHv1z75va8fu+gGUaPnGGvIRaYa/1LW3/nExberhvhlId3CkCEGDK84VT
         yuBqmkQSNy4nWwNsuftn26X6+55FUZ5xey/nyJHvrvOPYy2+frn9tm31goOaEa1Dje
         B9FgHEnhGlYyp/pbZ5oSDSpBNpXZOx+tNhViM6gogarIJP9ZkS+uJFzoxd/7uva1ov
         YxFOMxKor23hg==
Date:   Thu, 17 Feb 2022 20:08:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fred Lefranc <hardware.evs@gmail.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Message-ID: <20220217200844.64f5b3e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217160528.2662513-1-hardware.evs@gmail.com>
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 17:05:26 +0100 Fred Lefranc wrote:
> Allow modification of two additional Frame Manager parameters :
> - FM Max Frame Size : Can be changed to a value other than 1522
>   (ie support Jumbo Frames)
> - RX Extra Headroom

This looks like pretty obvious config, not what device trees are for.
