Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A3E5703FE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiGKNQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGKNQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93783E77F;
        Mon, 11 Jul 2022 06:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4588AB80EF0;
        Mon, 11 Jul 2022 13:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C313C34115;
        Mon, 11 Jul 2022 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657545360;
        bh=+HwtIXJAsCRWuLlF+i8sPNt40j+U5+eemCsv8jZKw/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJVNDVFYI0Dh2fWHqJzOV7ezf0FnEEO9mofJSsFYcleYNZ7WMuazfRf4ipitZAlHI
         oEddESHG9bU1pEMkmH/05W+dtw5O7EtPSENCodMkKyvMFPcTHMSiUdJD5WROH2FkHj
         ZcaIRPgtyKibl8x4bQcfkbtMONvqW8zi12vTzZqM=
Date:   Mon, 11 Jul 2022 15:15:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: request to stable branch [PATCH net] net: usb: ax88179_178a
 needs FLAG_SEND_ZLP
Message-ID: <Yswijtbd3nGjVF35@kroah.com>
References: <8353466644205cf9bb2479ac8ced91dd111d9a01.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8353466644205cf9bb2479ac8ced91dd111d9a01.camel@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:04:51AM -0300, Jose Alonso wrote:
> I think that this patch should be include in stable:
> 
> 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
> 
> The problems that it fixes are present in stable branches.

What stable kernels do you want this backported to?

thanks,

greg k-h
