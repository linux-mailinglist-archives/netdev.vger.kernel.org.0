Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8353581E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 05:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiE0Dtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 23:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiE0Dto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 23:49:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF93B0D11;
        Thu, 26 May 2022 20:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C05B61D76;
        Fri, 27 May 2022 03:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D748C385A9;
        Fri, 27 May 2022 03:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653623382;
        bh=D3GZP6fleTWhoFCBrTzOU6j74QipwUFxxLvVwr0pU/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tJYPOCiwACHoA6gz2mr86oT4blc545XfmkckujqLvZZxC77zEMLzeH3PWJhMyd0aH
         El1JGn7e16gh2ymjCcTCfLVRHobvGN6C3/Kb5K3JoZ9QUVNkmJWX7R0TySjsLu8p6S
         tstrp0aLNOHigSU7TeBgKbGkPvQlxxsJqENYcGJBs8psmhkNOJq8d1OZdnQzFq8Lio
         nJqc1TC2G+/H5QWMJWSG4q79d6a4Q/W4893B/TIl8AiJkmEoDwV1mPYIzzPpjZrhzH
         AzO0wzzbUGGz34KkoYbQi1AlT6bDEHeCVA3wqixuy7cuN3LdhvMHUyFlBUgOLic5EZ
         svVn5zKj6cIrw==
Date:   Thu, 26 May 2022 20:49:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Osterried <thomas@osterried.de>
Cc:     Lu Wei <luwei32@huawei.com>, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ax25: merge repeat codes in
 ax25_dev_device_down()
Message-ID: <20220526204941.0a56bf5d@kernel.org>
In-Reply-To: <YoQj7eND7/2KSBFs@x-berg.in-berlin.de>
References: <20220516062804.254742-1-luwei32@huawei.com>
        <YoQj7eND7/2KSBFs@x-berg.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 00:38:37 +0200 Thomas Osterried wrote:
> 1. We need time for questions and discussions
> 
> In the past, we had several problems with patches that went upstream which
> obviously not have been tested.
> We have several requests by our community at linux-hams, that we need
> to have a chance to read a patch proposal, and have time to test it,
> before things become worse.

Any input on:

https://patchwork.kernel.org/project/netdevbpf/patch/20220525112850.102363-1-duoming@zju.edu.cn/

?
