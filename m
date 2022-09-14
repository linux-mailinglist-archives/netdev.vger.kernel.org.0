Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F895B8E88
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiINSFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiINSFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:05:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1387C18D;
        Wed, 14 Sep 2022 11:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B72B3B81C4D;
        Wed, 14 Sep 2022 18:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC59C433C1;
        Wed, 14 Sep 2022 18:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663178732;
        bh=65NLlhfzs4TUVr824POtrhzkFPo7RR9Jq9fnhrW5roo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LM+JPeIoCW1b+QUSMwrRFC04M7h9/6i20KNdNNgGIGxRhLzN9fu8waUG5Rby121iN
         nRcqK5p7AzIt2GBHDiQcFqK/ZxuaB6+hHIwsTo7aY2Z8vLUu6QRhZdD54/jM0QOfSJ
         Abraj9FjRNp2quMdktmVnvJyFXmVt3PLS28ZE63A=
Date:   Wed, 14 Sep 2022 20:05:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hayeswang@realtek.com, aaron.ma@canonical.com,
        jflf_kernel@gmx.com, dober6023@gmail.com, svenva@chromium.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] r8152: Replace conditional statement with
 min() function
Message-ID: <YyIYBT9gZlY3TteE@kroah.com>
References: <20220914162326.23880-1-cui.jinpeng2@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914162326.23880-1-cui.jinpeng2@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 04:23:26PM +0000, cgel.zte@gmail.com wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Use the min() function instead of "if else" to get the minimum value.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> ---
>  drivers/net/usb/r8152.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Sorry, but again, no, we can not take your patches as you know.  Please
stop sending them.

greg k-h
