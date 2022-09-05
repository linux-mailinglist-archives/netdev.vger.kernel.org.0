Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F245E5ACC80
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiIEHSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiIEHSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:18:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ACA4CA0C;
        Mon,  5 Sep 2022 00:12:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0183B80EA6;
        Mon,  5 Sep 2022 07:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47571C433C1;
        Mon,  5 Sep 2022 07:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662361881;
        bh=KEeK/plLeSx5m/ZM2c1u6quOMC2MIqanMz4aSL/KzLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jgJJNvLPNFuIfmP5WdeYTMTprXhJFyVqbsfpqFrxvhltGKVV9gVpE/On6qmPzuCZC
         Y1+kI10KrGk+nIvcTVm6FWQetNFpOnckro2JbPCqGX4hpQOrbNsoqMyzw0xKVIpEWi
         t4uEQGQD0x+b3wB3pEeyQr1RhAjSd6n/m8oWnkDM=
Date:   Mon, 5 Sep 2022 09:11:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: setns() affecting other threads in 5.10.132 and 6.0
Message-ID: <YxWhFuwM1y28ZRGf@kroah.com>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 02:05:20PM +0000, David Laight wrote:
> Sometime after 5.10.105 (5.10.132 and 6.0) there is a change that
> makes setns(open("/proc/1/ns/net")) in the main process change
> the behaviour of other process threads.

Can you use 'git bisect' to find the offending commit?

thanks,

greg k-h
