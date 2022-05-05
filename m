Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003A551C55C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382058AbiEEQwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382045AbiEEQwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C6D56F8F;
        Thu,  5 May 2022 09:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 497FDB82C77;
        Thu,  5 May 2022 16:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D22DC385A4;
        Thu,  5 May 2022 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651769340;
        bh=NRrwDWz8wcT8CnNMt+44/umq8eBIMbarXpA7NUirvD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q2ZJy0eBfyJo0pa8jJ3E1NRjHXIsLC9LS7Qc3eJ2x3/LjRS8k6+a8VcHPk+B9fbQS
         WN1qbRo4MZ+c13F02kNyXrYv8Zxyf78TbBfE2TwJ8G2f7J62bkC/khy+TAMI6mAC8Y
         8lNSs2RjeTd0FgO/9inh1VCqQ03O4WxTc7OmcVLfHAB3Edgd/6cCLQyNycruw+Co7i
         vP7iWI/PMNXPHTgJhycMsusLH6wtU6H52BQsDTRMfSWWcXnyayTwyiCUhqL8VfiG/L
         QPX4reT5Za0yR2LohYy0JXTPEXme7fIGEevstDDFIRswSD0f11iUhmgJGM/DDVYD1t
         hEdkvy6LxjQMQ==
Date:   Thu, 5 May 2022 09:48:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Akira Yokosawa <akiyks@gmail.com>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/core: use ReST block quote in
 __dev_queue_xmit() comment
Message-ID: <20220505094858.4a1fcbc6@kernel.org>
In-Reply-To: <20220505082907.42393-1-bagasdotme@gmail.com>
References: <20220505082907.42393-1-bagasdotme@gmail.com>
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

On Thu,  5 May 2022 15:29:07 +0700 Bagas Sanjaya wrote:
>   *	to congestion or traffic shaping.
>   *
>   * -----------------------------------------------------------------------------------
> - *      I notice this method can also return errors from the queue disciplines,
> - *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
> - *      be positive.
>   *
> - *      Regardless of the return value, the skb is consumed, so it is currently
> - *      difficult to retry a send to this method.  (You can bump the ref count
> - *      before sending to hold a reference for retry if you are careful.)
> + *        I notice this method can also return errors from the queue disciplines,
> + *        including NET_XMIT_DROP, which is a positive value.  So, errors can also
> + *        be positive.
>   *
> - *      When calling this method, interrupts MUST be enabled.  This is because
> - *      the BH enable code must have IRQs enabled so that it will not deadlock.
> - *          --BLG
> + *        Regardless of the return value, the skb is consumed, so it is currently
> + *        difficult to retry a send to this method.  (You can bump the ref count
> + *        before sending to hold a reference for retry if you are careful.)
> + *
> + *        When calling this method, interrupts MUST be enabled.  This is because
> + *        the BH enable code must have IRQs enabled so that it will not deadlock.
> + *        --BLG

Rephrase the text as a normal function documentation and drop 
the banner and the signature, please.

The place to give people credit for providing the information 
is the git logs. So you can say something like:

  Rephrase the quote from Ben Greear (BLG) as a normal kdoc.

in the commit message.
