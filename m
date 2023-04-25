Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF73B6EE3A0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbjDYOHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjDYOHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:07:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2F6146D2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4162462EDE
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6623EC433D2;
        Tue, 25 Apr 2023 14:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682431624;
        bh=4dtl4Vzj4JWqe4heSlqgzhT1+OGky2J/Foy8rs5dQaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pDhhTEnsq9DRGXtZITWdsSGfEPV/9045QaMWOoT3a3OK/9ss/lXgeHQlg5WOj6BA4
         cW+K3xNhz0taLaDyx56dBsA7qnE6QyKkxcNPpPj1viF3ICkDG+PYdmZboyDttFS+G4
         68DMyfPelgoq/R/88bpP6/v5SYeyu5tOHz6D21wDyCAlHScuaTsF154DT+54a5fItj
         N1seICO5H5TWhRljTWA6xUxqVBVXpsV2wPsa0nOcJjol3qmVJZ6bKbeYf6UdyhPFOX
         IXmZVOc+NWpBjWVRGjZB+b1Y6rAf44D2msbN9a0j0iLhcKLCzsUtlDdIkqJ3sAPFtQ
         c0Ny1UxFy+oZQ==
Date:   Tue, 25 Apr 2023 07:07:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     ZhongYong <U201911841@hust.edu.cn>
Cc:     ktestrobot@126.com, wangjikai@hust.edu.cn,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] wifi: mt7601u: delete dead code checking debugfs
 returns
Message-ID: <20230425070703.0686a593@kernel.org>
In-Reply-To: <64474195.013A79.00008@m126.mail.126.com>
References: <64474195.013A79.00008@m126.mail.126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 11:15:04 +0800 (CST) ktestrobot@126.com wrote:
> Hi, Wang Jikai
> This email is automatically replied by KTestRobot(Beta). Please do not reply to this email.
> If you have any questions or suggestions about KTestRobot, please contact ZhongYong <U201911841@hust.edu.cn>

What is this? Please don't spam people with some random bot output.
