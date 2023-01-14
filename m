Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBAA66ABC5
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 14:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjANNrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 08:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjANNqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 08:46:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724D3A9B;
        Sat, 14 Jan 2023 05:46:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7060DB808CD;
        Sat, 14 Jan 2023 13:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6713BC433EF;
        Sat, 14 Jan 2023 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673704001;
        bh=uBcrKz57WGqNdhpKMGqIMKlBdqZrPQ0w7Sb911aM5u8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEQRwL2uXx4hT4CEXENbukF4Bt56TBCyg/j7EBj7vcnpIbZMio/urexP9S4+pYifX
         uydupyZxIZ7lrm4mfH0OW4eywana3e3MfwG3XyYSC/2ZYMeTSeW4W0C0w0RouYGzy2
         039SBaIj2qGUkiyHOfr+XNORsfaIuAcHJoklSuQ4=
Date:   Sat, 14 Jan 2023 14:46:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] mt76: move mt76_init_tx_queue in common code
Message-ID: <Y8KyPYrTlN6Xr094@kroah.com>
References: <Y8AD4jdyOpqrPT9a@kroah.com>
 <20230113150445.39286-1-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113150445.39286-1-n.zhandarovich@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 07:04:45AM -0800, Nikita Zhandarovich wrote:
> My apologies, I should've have explained my reasoning better.

Reasoning for what?

Sorry, I have no context here, please properly quote emails so that we
have a hint as to what is going on.  Remember, some of us get 1000+ a
day that we need to process somehow...

thanks,

greg k-h
