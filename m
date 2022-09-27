Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3B5EC55E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiI0OCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiI0OCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD8221E1C;
        Tue, 27 Sep 2022 07:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35F27B81B2B;
        Tue, 27 Sep 2022 14:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70851C433D7;
        Tue, 27 Sep 2022 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664287295;
        bh=NAUodwPgnE7GrEVryZvu4qNHr7mbevAz4s3TO23t79w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LuiosZJoGZ02miUBmsmqdUMGhsCAhmvkY+X0H1Fa4Jceq/WJAtnP5PXAzJeXApsDB
         +rFeYIsYnbFLG3z9IKRSYcVox4BqxGkoRF24D+Dx5v+NqwijA18XSCUBZI+1JxG9uP
         hIBufbCYnDExFNHs1yCbolTI1VEUuEb5AcIFRvDjVWhvBYeh90sWoElQ3rHeQFoWqi
         BTH3m8uvF/gs4DQXLPafNDQMGhq1sYdF6x+SMJGXDdn6PkwrbJPDNJJs6dee/Z1+Me
         EyORRxFj2Ggg8yTPznfdgeL31Lr/UqrwUBAT5VwsxfkfXa2aDuJoMyNIFIEoCFJGEU
         5fpSMc+pnvDIQ==
Date:   Tue, 27 Sep 2022 07:01:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhangsongyi.cgel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zhang.songyi@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net: atm: Convert to use
 sysfs_emit()/sysfs_emit_at() APIs
Message-ID: <20220927070134.7cde492d@kernel.org>
In-Reply-To: <20220927064649.257988-1-zhang.songyi@zte.com.cn>
References: <20220927064649.257988-1-zhang.songyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 06:46:49 +0000 zhangsongyi.cgel@gmail.com wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.

Is there an end goal to this? If the code is correct let's leave 
it as is. ATM is hopefully going to be deleted soon.
