Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA65E4D708D
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 20:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiCLTbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 14:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiCLTbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 14:31:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761CD381B1
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 11:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFB8BCE0AB0
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 19:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AEC340EB;
        Sat, 12 Mar 2022 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647113443;
        bh=xfE+fM7lUQElAr6D15DnrV+3eu78aFwfde942wjhhdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sn9Wm+XPTn6VFeFuJQCwoIki8pW/5OYGpHyuOBrUgXHu5gbsybjSFCn4mt7TiN7JM
         duR1zv3H+5I/wuJ36Vx1dgW8zu1ipvqohcD3oZ/XG31O8kqGmnAGESkTjR629WvrdN
         lsNwoeUjB6Jg6CWobZ1xZFnrIHIkuHQAtj+M2H9fQGKNvlageQnHbqf+yWbJr1H8eu
         sanKZgW0YnJdQ42zvglQpJym2cntQYq++KAWE2tOn1a4pvvA8cTUsIhgwnzY0ngD0I
         EetdClSKlXOhaWeJY0IDLOBmVrmfW/VoYCiHEpQuDIe2gb70JrtIjbAosuElXH1704
         +xSCbn1ex1upQ==
Date:   Sat, 12 Mar 2022 20:30:38 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk
Subject: Re: [PATCH v2 net] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions.
Message-ID: <20220312203038.5a67bdc7@thinkpad>
In-Reply-To: <20220312002016.60416-1-kurt@x64architecture.com>
References: <20220312002016.60416-1-kurt@x64architecture.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 19:20:19 -0500
Kurt Cancemi <kurt@x64architecture.com> wrote:

> This bug resulted in only the current mode being resumed and suspended when
> the PHY supported both fiber and copper modes and when the PHY only supported
> copper mode the fiber mode would incorrectly be attempted to be resumed and
> suspended.
> 
> Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
> Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>

Nitpick: We don't use dots to end subject lines.

Marek
