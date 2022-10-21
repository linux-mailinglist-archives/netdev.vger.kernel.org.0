Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5236E60795E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiJUOSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJUOSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:18:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25FF27C979;
        Fri, 21 Oct 2022 07:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693DAB82BD0;
        Fri, 21 Oct 2022 14:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B41C433C1;
        Fri, 21 Oct 2022 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666361888;
        bh=cj0PcKH8K2weaWqrFtWeMxzDNkvCU5FZmqFQCOR6fPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v9+7bZ/1ozN/Ny2ciX3IuBvNq3wlyAJuzbuY7v9tJI+crll1difA1UUH800vdzdB8
         jEgnFtfZiY/eHbWXkZAtJ51svPWGPHdXbq90uvvtn2KZd1rgz+QTX9m4es+I36CDf6
         VWGWcT0r9fOl4AAitqgLwEyNsG6l9JPSleagzhdg=
Date:   Fri, 21 Oct 2022 16:18:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10] inet: fully convert sk->sk_rx_dst to RCU rules
Message-ID: <Y1KqHHvb8+VghMSr@kroah.com>
References: <20221021133207.3135568-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021133207.3135568-1-cmllamas@google.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 01:32:07PM +0000, Carlos Llamas wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 8f905c0e7354ef261360fb7535ea079b1082c105 upstream.

Thanks for the backport.  Now queued up to 4.14.y, 4.19.y, 5.4.y, and
5.10.y.  Do you happen to have a backport for 4.9.y?

thanks,

greg k-h
