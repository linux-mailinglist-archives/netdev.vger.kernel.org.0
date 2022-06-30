Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B428561924
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiF3L3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiF3L3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:29:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9C944750;
        Thu, 30 Jun 2022 04:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A3160F42;
        Thu, 30 Jun 2022 11:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CECC34115;
        Thu, 30 Jun 2022 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588579;
        bh=6cAA7tioO8XW62gXON9ZehgKH3LZQ256fjbDgBircbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YOqvBouL7DvkCgvnCfshgWvXaZlnhU8PfNxQtZz7JzQp5ODQBm0O79gL0xOXVuulc
         Ovy/K829ECuKEZsZlkcHYs9zXR5QK0pSjZtsnPyYMc1/ONzgsjxZ2sfQQtIrhcm5wj
         1nts6c0cV5WuTJDete+LVeNuvtuzQqyrcwmHCg4M=
Date:   Thu, 30 Jun 2022 13:29:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        masterzorag <masterzorag@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH 5.10 v2 3/3] commit e109e3617e5d ("rtw88: rtw8821c:
 enable rfe 6 devices")
Message-ID: <Yr2JIdo6254QY8nT@kroah.com>
References: <20220628134351.4182-1-tangmeng@uniontech.com>
 <20220628134351.4182-3-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628134351.4182-3-tangmeng@uniontech.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:43:51PM +0800, Meng Tang wrote:
> These commits can fix the problem of wifi not loading properly. At
> least in my 5.10 kernel environment, the following error message is
> reported:
> 
> rtw_8821ce 0000:01:00.0: rfe 6 isn't supported
> rtw_8821ce 0000:01:00.0: failed to setup chip efuse info
> rtw_8821ce 0000:01:00.0: failed to setup chip information
> 
> so I think that 5.10 need to merge these commits.
> 
> The patch 1/3 and patch 2/3 need to be merged synchronously, otherwise it
> will cause OE and then kernel exception.

This is not in the original commit log at all.  Shouldn't this be in the
0/3 email instead?

And yes, this hardware is not supported in the 5.10 kernel tree, please
move to 5.15 or newer and it will be fine.

thanks,

greg k-h
