Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3A6C3A57
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCUTYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCUTYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71922A29
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F270061DD4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E607C433EF;
        Tue, 21 Mar 2023 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679426655;
        bh=2vdmQIvK6L6rNuqU0xwHEAdn6E+pTRHeOCHqmDFrQEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UAetcWSxgN88L5e/VGtTPWLwkGahsoLc2l2JCbOvKEEnGkmUMQauXairHzgTIPT+Q
         HLqCpaxikHUcHQM1SENeWmoE+tm0qbGtvWpCJppb+3mpi5TV4sA8X/VAG0EiVJ/QvI
         WNjHdqd7zP5pa+cnyFFMmey74GCA382dQxAKEyOrdO/Yqa5T0g2YyMd84OON2IHywx
         Ex7YzXzlunjWh5gTUvpBXijXHUF3kwrE9BtdmPValirWDOuy/oJLCzjB5EkIiyqLZ1
         7+aWyWOcE9J4g6QxCrg6b3AZPYeMBG3NDSFPzRlVKMGZnTCrb2h3JW+chYFmrQfLlj
         NEIA3g3hV43Xw==
Date:   Tue, 21 Mar 2023 12:24:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, gospo@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v2 0/3] bnxt PTP optimizations
Message-ID: <20230321122414.5cc09af6@kernel.org>
In-Reply-To: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
References: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 07:44:46 -0700 Pavan Chebbi wrote:
> Patches to
> 1. Enforce software based freq adjustments only on shared PHC NIC
> 
> 2. A prerequisite change to expand capability storage field to
> accommodate more Firmware reported capabilities

You reposted too soon, have read of the process doc:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
