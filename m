Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37D26B86E9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCNAab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCNAa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97306DC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 17:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A56F61456
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570DEC433EF;
        Tue, 14 Mar 2023 00:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678753827;
        bh=9GaKf0lRlqlZLevFZcekG/s+L93mogKeWjpqlHGBeSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AHuwPSxliEAT8FvQ7C4gJ65OinPtPQBb/7NAiPKaLYAP5LrgiLZ3adZak8ENpLPyN
         ja/scmmJMIdmJBE9rzAvnuUSPEKpBdsEJV8JB848FXOZyo1mICn8BYI+B7TbLvl3wQ
         4iJA4Mv0MC8pS5nAQtObSdqpVZj+HgSnshkpfHS2nNw4vW3JZMK02o/vQuaH7/apy1
         CytQpFPgs7psXm3n0ysyPNq/o532OYYv9TCh8UfonHCpOk+1aNxpfTaTGHyy6sFVH+
         TyBrH+6hIBrBO7dqDRJE9vcYTCLrBHA4i3tvDBAkgXaRFZpyObiI9x52BKsJTzfD6R
         /7qLXGljKxDlg==
Date:   Mon, 13 Mar 2023 17:30:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] vxlan: Make vxlan try without a local
 bypass, if bypass fails.
Message-ID: <20230313173026.5b8fb013@kernel.org>
In-Reply-To: <871qluxzyy.fsf@laptop.lockywolf.net>
References: <871qluxzyy.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Mar 2023 14:07:05 +0800 Vladimir Nikishkin wrote:
> From: Vladimir Nikishkin <vladimir@nikishkin.pw>
> Date: Sun, 19 Feb 2023 21:24:49 +0800
> Subject: [PATCH net-next v1 1/1] vxlan: Make vxlan try without a local bypass, if bypass fails.
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> From 8650e2e742b7a2cd6c35d1c034084b9f68e0f112 Mon Sep 17 00:00:00 2001
> In vxlan_core, if an fdb entry is pointing to a local
> address with some port, the system tries to get the packet to
> deliver the packet to the vxlan directly, bypassing the network
> stack.

Looks mangled, could you try resending with get send-email?

Please make sure you CC the right people (scripts/get_maintainers)
