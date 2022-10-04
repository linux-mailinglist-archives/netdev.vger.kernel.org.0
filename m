Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946CD5F3AA7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJDAbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJDAbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:31:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2711B165A9
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B96DD61155
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81A7C433C1;
        Tue,  4 Oct 2022 00:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664843458;
        bh=LFu0NEAxsxZG3bhHAV6wAhJroqmmHOgtOON/dLlE5r4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SB37y0S1NHSAX0bd+xW2cfASu9rrj1aOH1AtQdznhavEiovLKL+SyOOG/xT4axYgw
         JHKM3YODxuZyGi2jZPZGhlTM0wpZ1/XtFYg4Er5I6wUVEFsIBtCrowIk5mL2e5Bawr
         62PGYVwQpNbBTrtsuOwZdiaOww6vlfHuQXpfg5W16s9JsvlN/81adcN3njzqPVomOE
         WGCnt9YSRthWQwM9C16HkGdbroVjwf1EgMcN6ams8Gz5YgJYYd+8iuaV0UecT/JgWX
         fpAzT2DsdsRM3juKPV8vofPregVV3tCJaIfLWfvruBY5Dp/oR+Ej191rpkib/d6BZa
         S2niBt1GJc4mg==
Date:   Mon, 3 Oct 2022 17:30:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com, Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: Re: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
Message-ID: <20221003173056.594bd107@kernel.org>
In-Reply-To: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
References: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
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

On Mon,  3 Oct 2022 15:27:25 +0530 m.chetan.kumar@linux.intel.com wrote:
> From: Moises Veleta <moises.veleta@linux.intel.com>
> 
> The Modem Logging (MDL) port provides an interface to collect modem
> logs for debugging purposes. MDL is supported by the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
> control logging via mbim command and to collect logs via the relay
> interface, while port infrastructure facilitates communication between
> the driver and the modem.

net-next is closed, please repost once Linus tags 6.1-rc1

http://vger.kernel.org/~davem/net-next.html
