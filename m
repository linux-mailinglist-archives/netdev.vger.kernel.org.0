Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B423151931D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244859AbiEDBHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiEDBHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493A81408A;
        Tue,  3 May 2022 18:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD2A3618AC;
        Wed,  4 May 2022 01:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9307C385A4;
        Wed,  4 May 2022 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651626223;
        bh=hV27jNHam8OizP1col9nfnGlVImzRzfatynwi/Ik78s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gZVwnvY7N0IjKjFqqyfvl6EGcBP82RpxDtU86xM7L1rskch8S30+yK0+5xeg+9M6s
         OE3dLViAocFesTCDdg8H8kQiWA9m6iyIy6ympa0wzudVminx8WHqxUhClrz+33TI0A
         SNIV0dkqPNltgY4HzvFxwSelrmnMVZd3YHSdN3WA4TIHcu18PZGuf7k5hWLUgj7Mrq
         cCVXTwnpj6qI/9Cb6AjpyyVR9Om67aeAaCCNFZXSkP+wYAM8qucGRsvLpXvzVPKhiL
         t5Ijs1KSwZAzRDYX3Ykt174fHJEH9bSePSgEktGie3zPdEvy95Gpsjf2IJ9x7KHdoU
         fJGXN2YBo0maA==
Date:   Tue, 3 May 2022 18:03:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <davej@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pavel Begunkov <asml.silence@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: Remove comment quote for
 __dev_queue_xmit()
Message-ID: <20220503180341.36dcbb07@kernel.org>
In-Reply-To: <20220503072949.27336-1-bagasdotme@gmail.com>
References: <20220503072949.27336-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 May 2022 14:29:49 +0700 Bagas Sanjaya wrote:
> - * -----------------------------------------------------------------------------------
> - *      I notice this method can also return errors from the queue disciplines,
> - *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
> - *      be positive.
> - *
> - *      Regardless of the return value, the skb is consumed, so it is currently
> - *      difficult to retry a send to this method.  (You can bump the ref count
> - *      before sending to hold a reference for retry if you are careful.)
> - *
> - *      When calling this method, interrupts MUST be enabled.  This is because
> - *      the BH enable code must have IRQs enabled so that it will not deadlock.
> - *          --BLG
> + *	This method can also return positive errno code from the queue
> + *	disciplines (including NET_XMIT_DROP).
> + *
> + *	Note that regardless of the return value, the skb is consumed
> + *	anyway, so it is currently difficult to retry sending to this
> + *	method.

Why drop almost half of the comment if the problem is just the ----
banner?
