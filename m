Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5937633473
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiKVEdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVEde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4CBDEB6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC26E61509
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF183C433D6;
        Tue, 22 Nov 2022 04:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669091612;
        bh=wEoQw2XdS2mBkCf1x0IILVkp0ngtKKwtLiEiCaLIpl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fygWevvWvcnap9B7vr9t0e+VtgzCs3s1Ss3DUmnQNEECh1l0/ui5BcV0bN650nu2o
         ZJZ7Xl6jKIzbllRifWZZc7KVZkqPNheHhSO8wy2xM7aqePR994sPXU0nE0xPrRxCJh
         ZIVPz6SWRrtoF/rwGwbyRE1hrr/eHz8Q4e5R42F887Y3Or25GI9RDFigGKC/oU4hHX
         dcBWIl8nTSLeiuQYT6QvG6Oh3m0+AocCscnSXqN9tqZRNHEiLeKTxqBGOH+u1TcP4D
         we2yjD2jHtnbUc7I50ruMgcRji0/e2hO+yjMwzrV3AN091Ot0coPW7ySxJ9DHIMZHs
         betatAO9f/CxA==
Date:   Mon, 21 Nov 2022 20:33:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, uwe@kleine-koenig.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 04/12] net/mlxsw: Convert to i2c's .probe_new()
Message-ID: <20221121203330.7ae19842@kernel.org>
In-Reply-To: <202211220615.q0vnGfzb-lkp@intel.com>
References: <20221121191546.1853970-5-kuba@kernel.org>
        <202211220615.q0vnGfzb-lkp@intel.com>
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

On Tue, 22 Nov 2022 06:20:23 +0800 kernel test robot wrote:
>    drivers/net/ethernet/mellanox/mlxsw/i2c.c: In function 'mlxsw_i2c_probe':
>    drivers/net/ethernet/mellanox/mlxsw/i2c.c:637:42: error: implicit declaration of function 'i2c_client_get_device_id'; did you mean 'i2c_get_device_id'? [-Werror=implicit-function-declaration]
>      637 |         const struct i2c_device_id *id = i2c_client_get_device_id(client);
>          |                                          ^~~~~~~~~~~~~~~~~~~~~~~~
>          |                                          i2c_get_device_id
> >> drivers/net/ethernet/mellanox/mlxsw/i2c.c:637:42: warning: initialization of 'const struct i2c_device_id *' from 'int' makes pointer from integer without a cast [-Wint-conversion]  
>    cc1: some warnings being treated as errors

Ah, we need to pull that branch you mentioned in the cover letter after
all.. will do tomorrow.
