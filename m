Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35A063B4D5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiK1W3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiK1W3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:29:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF5B24B;
        Mon, 28 Nov 2022 14:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB78614AE;
        Mon, 28 Nov 2022 22:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7452CC433D6;
        Mon, 28 Nov 2022 22:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669674546;
        bh=xcQxXnrPCAnUx0UIMRQ0AyINld9piSgUJcX2QXwJ60M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EoqthV20Y+l4UTWI1AZtrRV93JG3GOnbQKy2tYKNI12ewckkMKp+2P/Cm8MeGeH2G
         ROHIqS+lMvigJpRr/gPxtQ+kfdmGpcXXNEJE3M6LqhodE2bsF6noOk+AR9iryZxG5c
         bxcitNTGsr2z8yoXyxBv6+1ovCAqAJnk14s/wucUjVtH0uc1+2Y3K8CykaUib6YVjH
         7Oizk9UGfSwou8kEYjTYF4C+8JG3PZ4f/QUl6s1iRQOD6Vpy0vHhjHUtJE5i4NRj1z
         nzhI473FyyEKF+jOfUg4uLh3FLJAOxGolaSIs4uBDJeCT3+r4dNFI90DvNGCnekYK4
         ci98NqGWiIQuw==
Date:   Mon, 28 Nov 2022 14:29:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 5/6] can: etas_es58x: report the firmware version
 through ethtool
Message-ID: <20221128142857.07cb5d88@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Nov 2022 01:22:10 +0900 Vincent Mailhol wrote:
> Implement ethtool_ops::get_drvinfo() in order to report the firmware
> version.
> 
> Firmware version 0.0.0 has a special meaning and just means that we
> could not parse the product information string. In such case, do
> nothing (i.e. leave the .fw_version string empty).

devlink_compat_running_version() does not work?
