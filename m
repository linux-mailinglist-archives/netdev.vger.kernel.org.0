Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054456E2E85
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDOCIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDOCIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8F4138;
        Fri, 14 Apr 2023 19:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F03648CC;
        Sat, 15 Apr 2023 02:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C8EC433D2;
        Sat, 15 Apr 2023 02:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681524507;
        bh=6ku6pu6nfzZgQQnuE5fxPZEh2aPsOxfnPx3I/CAn3qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RbXfjDiFKQFLxCkm/FRUfPYcPmGAgVpfzvRIvDTFQcpkZk/OUuIWQOj2kEXesPD5r
         9x/hwL92jfH34K4ckEHlncwPRcA9svJgMl2Unov2yACgenBznxBWuaRIPw1iolKriE
         7eJzum71NxwMTj5pwisBYG2NyRHG/LnAlQa9eM7dqdxEo3BV2X5grHUDM9wd7EImR6
         /JvkRJhUqo43NvybA2nC426q95Tli7f4zHvm+zJVWdxiG5tIsWkOrc3hK7Rt7qFgwo
         LMuGEj/yj1kdAymkjOrMHNAqXezvDvAJQ0V6F/0Q6eJc1iPGVNtsXYrVsxk0ivfmQm
         Velg1Z4Xbvt8A==
Date:   Fri, 14 Apr 2023 19:08:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 0/4] net: mana: Add support for jumbo frame
Message-ID: <20230414190825.6ce2d980@kernel.org>
In-Reply-To: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 14:15:59 -0700 Haiyang Zhang wrote:
> The set adds support for jumbo frame,
> with some optimization for the RX path.

Looks like this patch set got silently applied and is already 
in net-next :( Please address my feedback with follow up patches.
