Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AC9607AB8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJUPbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiJUPb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C594AEBA
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 08:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0CBDB82C8C
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAA6C433D6;
        Fri, 21 Oct 2022 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666366221;
        bh=z6sS6DpXhEetRIfPs5R2qXzuQOs/VBzM+1qt90lFczk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tK0EzGCXlmONnFW4HRsppFpER1LsD78JNybe8Q+ajR0fexOMKYsPQZAz5gy2KoLos
         6xN8LrPGGjFuorja2ypixttY6yK+g/hp+ZI24ZlaDBk/BFQNxr2jT/0FtqT8rf2y4G
         hbkuJn/YD5w7a2TtQXDk5ueGImDBoC39mYO4H5vsKh6sXz+lq8wxNTpzQkRz2g4BDR
         BBGGaSK/r/moIFfhwbAonHLUkeiloPp8XMF/8mIyMX46e5Iy9wnvigHda5hDeALxh0
         Z9kwXGaM6zHcahLj1hCrnkqN32q2rW5L8YAzQsnm/gZa97MvOCb50w4D6MFEmvVJ4n
         mcenplmfGRbvQ==
Date:   Fri, 21 Oct 2022 08:30:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH net] ethtool: eeprom: fix null-deref on genl_info in
 dump
Message-ID: <20221021083020.6ef403e8@kernel.org>
In-Reply-To: <5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com>
References: <5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 10:22:47 -0400 Xin Long wrote:
> The similar fix as commit 46cdedf2a0fa ("ethtool: pse-pd: fix null-deref on
> genl_info in dump") is also needed for ethtool eeprom.
> 
> Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
