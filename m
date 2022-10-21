Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFF2607F1A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJUTgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJUTgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:36:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7336274580
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 603C161F0F
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 19:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67749C433C1;
        Fri, 21 Oct 2022 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666380981;
        bh=aT9tOJPJsB8gSohP62VnfRwC1RMOwRNEb6MUtYsvKQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GsyYSNRHSDOKL4bNDH59qi5RT342jQWeqD9g9DNwreVHh4jZ1qpTFk1CTkNpjdcih
         EQ1ziVnnTMiU2ixb6FjFi/Yli5Fh1XB49+xmvdY2kbHHKjZ5bVhBwzIixvvTVYWQB2
         ZdbBaejXiznYUJUqJ1bkMBd/pWJhXstnJQjuQ6HDY/giJCsPqL2c8c/uclNKvIg7+S
         YEsPE/ZtO9g9mb4+nXnhxf3No/0+OUVwRymv+Dlghf1hikpppGmojHI7JYADVAWCes
         U1H1ora0a8SQrIqUPk6xofuuTkdvd5v5zj/AweOwQwewt4dXA4fxKXCvHFoMF5Ehmt
         YlOzerZM/OryA==
Date:   Fri, 21 Oct 2022 12:36:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: Re: [PATCH V4 net-next 2/2] net: wwan: t7xx: Add port for modem
 logging
Message-ID: <20221021123620.2103f52f@kernel.org>
In-Reply-To: <20221021205917.1764666-1-m.chetan.kumar@linux.intel.com>
References: <20221021205917.1764666-1-m.chetan.kumar@linux.intel.com>
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

On Sat, 22 Oct 2022 02:29:17 +0530 m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> The Modem Logging (MDL) port provides an interface to collect modem
> logs for debugging purposes. MDL is supported by the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
> control logging via mbim command and to collect logs via the relay
> interface, while port infrastructure facilitates communication between
> the driver and the modem.

The date on your system is broken, please fix and repost.
