Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAA531C6C
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiEWSo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbiEWSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F7C21828
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E39661181
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 18:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0763C385A9;
        Mon, 23 May 2022 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653330375;
        bh=hmHzslQw1K/btMOCgYOyRzpqkqU/zn0gvrnjzi+wr/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uvsPslKn9+TsvLqUD1LiqvKXH4PNnp1ROUAv71jLUmEfiijQ1gkP6eGImWeGQvH4L
         NtQ+cJbz6OmE5rB+uGMmSWF6u6mos2YxGVUfGsQw7RwwGWj29Iz08OmYQRFawGHJBy
         qqKkvTPNmkcDXSb5A+HBC5QMfCSu0AS75fmkiixPznZHWJyk3sGrFTly0wnqOXY4p0
         EMNK2Bc0XwQP+HgbXLOs0FmlbZPZkAlXBqSo7tudAjy0SGbCd5a+Af6wCTiTFYzVdz
         ERCNzQOpYU3PbSCwD6HKgIA5HiEvAEI6TvLmVQ3QsJHOKfzkgnzJHZjaM+je7Z/mhW
         B/y6ibPOOCbNQ==
Date:   Mon, 23 May 2022 11:26:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH net-next 03/19] net: add dev_hold_track() and
 dev_put_track() helpers
Message-ID: <20220523112614.1f9c9c90@kernel.org>
In-Reply-To: <CANn89iKUV+brdTa0SZYi_pov8hKEL-9nXo-wKQsLP6xtY261UQ@mail.gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
        <20211202032139.3156411-4-eric.dumazet@gmail.com>
        <20220523110315.6f0637ed@kernel.org>
        <CANn89iKUV+brdTa0SZYi_pov8hKEL-9nXo-wKQsLP6xtY261UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 11:14:27 -0700 Eric Dumazet wrote:
> > Hi Eric, how bad would it be if we renamed dev_hold/put_track() to
> > netdev_hold/put()? IIUC we use the dev_ prefix for "historic reasons"
> > could this be an opportunity to stop doing that?  
> 
> Sure, we can do that, thanks.

Thanks! I'll send a rename after the merge window.
