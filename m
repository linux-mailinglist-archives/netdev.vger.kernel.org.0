Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016484CCCB2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbiCDE5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiCDE5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:57:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10DA5F24F
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 20:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3686A61B5C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A3BC340E9;
        Fri,  4 Mar 2022 04:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646369781;
        bh=uckrxPfMRdxS7+MV84+QawcyPO96e1mTkvTVvZbXTus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ykxkkfu9P/6lShb9RyGcEXZtQOZQ1ZOBuH5QxfErRxxLVVcYxlrhGP5YXoTJ8WqFs
         JpsZybPS24mMRVuOLbw6HzQTetDDycCsTg/zhNsGTAXkZywFCOQ0l+vOJiucRkqUVT
         oEEptjfB9l9NB6Vq85JU1VM87XS8bfRsrvJqkuOnfC0zI+Sx6AYyFZgv/E+CNdF1eD
         08zcBCiC0QgwGJK11yXVexkmFsYVqVhp/EYA+zqMNwV6lauVIoRe/fEj3paOC3uiQV
         o27/nTD/P1Xz1x6k18U21c4fD/JhxlAuH00c93/TOqLnaNyK4xKRZO/ut35jxlikYB
         LhBp/ROtAmGJg==
Date:   Thu, 3 Mar 2022 20:56:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 0/2] ptp: ocp: update devlink information
Message-ID: <20220303205620.16c72929@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303233801.242870-3-jonathan.lemon@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
        <20220303233801.242870-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 15:37:59 -0800 Jonathan Lemon wrote:
> Both of these patches update the information displayed via devlink.

You'll need to repost these patches with the threading not being
broken...
