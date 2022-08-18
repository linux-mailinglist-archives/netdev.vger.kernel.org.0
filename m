Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1215D59886A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344194AbiHRQPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344563AbiHRQP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7097E6BCCB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A50614D6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 16:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86F3C433C1;
        Thu, 18 Aug 2022 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660839328;
        bh=N5tZ0GlgCrZkrQl7SHjiSOZBVwIlZvW0D1rGJ1KtoAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uakx1AmtlVVrhAzNqvkj6hHXZnJe2NwCVqAt8oGMpaqedxBHp9AeRoziSIdYK0hla
         UDgund+z0Lo/xGNn/CflfWKvRgwHi/lqzGK3XyujrBofyNdMii861d+dncbZjn81pZ
         xpfxEUvyrIeFLeqYzr6tEEAfSErEYVz3/w66QOM9NcMIPvPLZzBIUb6BsttFU7Rxms
         1rGCkWPR0Bz6ExGerFUUPjF4554xph06zqR7b1m0C+wBfjoG5oFESJ12rdbaILExVx
         d63dWmG2//3f9EvKWQsp9yKsAZGmXxCPTZLuFxb2sGwRNZB/TTtQ1bkBvk2MCUQlsU
         LTB9m5bGr6QMg==
Date:   Thu, 18 Aug 2022 09:15:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     m.chetan.kumar@intel.com, Netdev <netdev@vger.kernel.org>,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Message-ID: <20220818091527.2b918b36@kernel.org>
In-Reply-To: <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
        <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo,

thanks a lot for the reviews. Unfortunately the patches got applied
before your responses - do you have a preference between the MediaTek
following up with fixes or us reverting the v1 completely and
continuing with v2 as if v1 wasn't applied?
