Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D846599AF5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348793AbiHSLXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348682AbiHSLXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:23:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03A2C6FFE;
        Fri, 19 Aug 2022 04:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAC861772;
        Fri, 19 Aug 2022 11:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270EDC433D6;
        Fri, 19 Aug 2022 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660908186;
        bh=hnttYLqb9dk7bb0JclIZVL0NbVbYYPFxWtSbXQQOsBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgSxC7w5k2hBp7tpldSGiukqlcpjM69Y4pnHW5nRuBod2I7uMBhSmnG+NO9+2PLuU
         1gYXdkdrIHUSHuRwFEH3JitoLJdJ59CZNorj41BjrlhCk1KXyqU6F+R7J4iBGZT0hC
         qqNYUC2xnWDZOPNKwtf4q4u2Vd9vuJ0dZ3L/6klQ=
Date:   Fri, 19 Aug 2022 13:23:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 0/1] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Message-ID: <Yv9ymGE9ZNPfUjBm@kroah.com>
References: <20220819103852.902332-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819103852.902332-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:38:51PM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-1679:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ac4827f78c7ffe8eef074bc010e7e34bc22f533
> 
> Pavel Skripkin (1):
>   ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
> 
>  drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> 
> base-commit: 6eae1503ddf94b4c3581092d566b17ed12d80f20
> -- 
> 2.37.1
> 

This is already queued up for 5.10.  You forgot the backports to older
kernels, which is also already queued up.

thanks,

greg k-h
