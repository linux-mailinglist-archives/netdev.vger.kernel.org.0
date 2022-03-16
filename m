Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3044A4DB91D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiCPUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbiCPUDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:03:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2C58E5F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7164B61117
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86977C340E9;
        Wed, 16 Mar 2022 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647460915;
        bh=AaS16rAgdoCF3/TZ7wYgj15Nb0isouGWpPCSfLyolgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N7tHg90DOiVFVhQ6iH/3zA7NlFeapg8lLHJEpADP9OLKK427Cxxj/bamQNtYCKqoT
         QhGUcPrdzQbzGYfbXrcQcLvGs6n5oE4wfrcM6aw8gyL9z2p23bPsFs3jRIGp28REB+
         rh0BKSl9IV3qSVLH+DPqRqiqJnOvNxwzRs+QNEE6IuLKXy262+nMfqgfijKpDGQz3s
         s4uvW360vzoKAn0opV/5Tg8xgkF1ilOdFyXwF5Bupe1m3GccINSdPvlC/pzeZ5e6Xh
         RyWXzpWytzVGT1x5z09pNkDrIshU+27Zk+xVoJadd0FMWeyDaJEV+uCoVDb+9+gJyk
         iU9O9Nk/d2wdA==
Date:   Wed, 16 Mar 2022 13:01:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.co,
        netdev@vger.kernel.org, Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH] net: axiemac: initialize PHY before device reset
Message-ID: <20220316130154.44db510a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316075707.61321-1-andy.chiu@sifive.com>
References: <20220316075707.61321-1-andy.chiu@sifive.com>
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

On Wed, 16 Mar 2022 15:57:07 +0800 Andy Chiu wrote:
> Related-to: 'd836ed73a3cb ("net: axienet: reset core on initialization prior to MDIO access")'

What's Related-to signifying? You can have multiple Fixes tags 
if you need to.

> Fixes: '1a02556086fc ("net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode")'

There should be no ' quotes around the tag, please fix and repost.
