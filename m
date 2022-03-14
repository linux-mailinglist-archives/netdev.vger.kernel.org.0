Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B495E4D8F4A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiCNWI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbiCNWI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A17A1C5;
        Mon, 14 Mar 2022 15:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CBF7613C5;
        Mon, 14 Mar 2022 22:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D31C340E9;
        Mon, 14 Mar 2022 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647295663;
        bh=sU8B46VeX8cW2s6YLD+RKxbR9NZhCm592Uq7eMMy7O8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ujDF7wW1DU1V2L5Ef4FONd4hfSl1O4c8h665kv9OZxfHymsAxQaO7dCzLFybF14qJ
         wcCqnoCMR/v1lBYeFxC7nbI8dejOhP8QSPyUmeZQscpKPnnZyJ5Chd7+6UC8g1iUWq
         ZjtJKQ+T5fqu5aC11bnpGBWSDZ71Ld2i/uNsLzK1Ff6ATLt5fJbky9ISFv4LSp/Xj5
         tDAEJkxdD2R3hoe/mlGTfnIlcF0jUAVQpnLMaApF7ovB90j4O8xIBEKBqebNbR5WAp
         QD7Z2XmFB7zfQ+pJRNo8q9he+CSJklmt6wWu67MAURyyQzx1ZAgpks0Z3wb8y+NGTL
         tAP3TJ4w30Lqw==
Date:   Mon, 14 Mar 2022 15:07:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, kabel@kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions
Message-ID: <20220314150741.5e674da7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220312201512.326047-1-kurt@x64architecture.com>
References: <20220312002016.60416-1-kurt@x64architecture.com>
        <20220312201512.326047-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 15:15:13 -0500 Kurt Cancemi wrote:
> -	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>  			       phydev->supported)) {

You should align the continuation lines so that the start matches 
the opening parenthesis. I'll fix it up when applying for you this 
time but please make sure to run checkpatch.pl --strict on patches
before submission. Thanks!
