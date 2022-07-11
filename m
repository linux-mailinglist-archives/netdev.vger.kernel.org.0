Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D48956D75A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiGKIFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKIFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:05:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBDE1CFDF;
        Mon, 11 Jul 2022 01:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25027B80DE7;
        Mon, 11 Jul 2022 08:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B9EC34115;
        Mon, 11 Jul 2022 08:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657526715;
        bh=q4hZ5dAOv+NEWL4wDWpk+yHIaXbKs/PWCF6KRLMu/O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v1A4TmeOjf5P4w0Juk+VqmGfXpqMWOOzO3QijyvW2pesY1ns7ly+dbG8kqjAlHAVF
         8IQTd8QBKdBKxCWQemkp7m+QXHDI+MgucdBv4GapsncP6mhmS56DAzBCsMgYn+eYV4
         xvyerp/GZ2xiKTi3K8O+b63ZxkaKbggtF5Mo6CBM=
Date:   Mon, 11 Jul 2022 10:05:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Binyi Han <dantengknight@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <YsvZuPkbwe8yX8oi@kroah.com>
References: <20220710210418.GA148412@cloud-MacBookPro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710210418.GA148412@cloud-MacBookPro>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> Fix indentation issue to adhere to Linux kernel coding style,
> Issue found by checkpatch. Change the long for loop into 3 lines. And
> optimize by avoiding the multiplication.
> 
> Signed-off-by: Binyi Han <dantengknight@gmail.com>
> ---
> v2:
> 	- Change the long for loop into 3 lines.
> v3:
> 	- Align page_entries in the for loop to open parenthesis.
> 	- Optimize by avoiding the multiplication.

Please do not mix coding style fixes with "optimizations" or logical
changes.  This should be multiple patches.

Also, did you test this change on real hardware?  At first glance, it's
not obvious that the code is still doing the same thing, so "proof" of
that would be nice to have.

thanks,

greg k-h
