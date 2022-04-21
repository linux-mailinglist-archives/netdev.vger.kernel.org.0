Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40558509CEC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387980AbiDUJ6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387448AbiDUJ6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:58:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D105252A5;
        Thu, 21 Apr 2022 02:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF281B82394;
        Thu, 21 Apr 2022 09:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3AC385A1;
        Thu, 21 Apr 2022 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650534943;
        bh=Y2O1G2M/9QmAOGqr5GeEsbWJbSBwW3If9ToqHnGH7cQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M5vYEouuZXaTCdAwr7LF8/CcBmqsdYLOseV3BjxmixCeFYErSxE0cntjTCF9LqA7N
         jnvithYWVttEa7zUs8cwLNd2nwIwwDptlxftrOgu6E22G7QtW7xGUACwlMC1flXoNM
         tef2cbLZ4d+f3JuACCtFoPo9nRIvMKBXqo1/btgs=
Date:   Thu, 21 Apr 2022 11:55:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, paskripkin@gmail.com, hbh25y@gmail.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] can: usb_8dev: backport fix for CVE-2022-28388
Message-ID: <YmEqHBFXsprvaTsh@kroah.com>
References: <20220419113834.3116927-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419113834.3116927-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 02:38:33PM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-28388:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d3925ff6433f98992685a9679613a2cc97f3ce2
> 
> Hangyu Hua (1):
>   can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in
>     error path
> 
>  drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> 
> base-commit: 74766a973637a02c32c04c1c6496e114e4855239
> -- 
> 2.17.1
> 

All now queued up, thanks.

greg k-h
