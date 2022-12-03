Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD0C641428
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiLCEuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiLCEux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:50:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C7B68D4;
        Fri,  2 Dec 2022 20:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E54AAB81AD6;
        Sat,  3 Dec 2022 04:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DDDC433C1;
        Sat,  3 Dec 2022 04:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670043049;
        bh=E9Nv+QaJ5r8gtO9zqBOkqxrvuj5zmcUnm8L9hDnTTQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d6qyI30qjSwTCkanduIsgvH4nzVnR1i/n9yVK/FujC0/Cx8n4AKS8neZy82S8SjZX
         mcmF9mT3r5HD/B2xZ1M2UaEMxErVHYMR7w/gU+F+PZkN4xw3ET4Ebly62ifFkj4vSk
         Yh7g3yAG/u+iKWw6H6rnhzlg+bokhy9ADeWHZWPl3AovSEc5tA6iL1URUyn5pS2DDp
         pMNxAlIYFeQ6k+w+Sf38Qbkm/RGkywx6Bbpun9toemWn4N+y1lcOvHKYYoWX2rVunW
         bf5kgRt+CH8dISP643oP3Jdj/sa5b9GpA9aeXrb8BSNhr5Y/bIdYzuZn0c23sJ7IE8
         yzGkiiuHmsEsw==
Date:   Fri, 2 Dec 2022 20:50:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <zhang.songyi@zte.com.cn>
Cc:     <lars.povlsen@microchip.com>, <steen.hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <unglinuxdriver@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: microchip: vcap: Remove unneeded
 semicolons
Message-ID: <20221202205047.57d59a9a@kernel.org>
In-Reply-To: <202212011006426677429@zte.com.cn>
References: <202212011006426677429@zte.com.cn>
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

On Thu, 1 Dec 2022 10:06:42 +0800 (CST) zhang.songyi@zte.com.cn wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> Semicolons after "}" are not needed.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>

Please rebase, patch does not apply.
