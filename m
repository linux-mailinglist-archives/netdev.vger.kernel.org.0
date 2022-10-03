Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A95F39F6
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJCXm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJCXm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AADC43149
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3063261203
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 23:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DAEC433D6;
        Mon,  3 Oct 2022 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664840544;
        bh=NCSnIOdn9x2Xu4vgIoOahTmx3+X5liixQ8WZBOKnobc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=edz38f5ML0kAScFTr46Jl9wv+0AgpmjXHAtuC1XFbkLNF9wjTqc5tquYJLD/rhs3K
         JyU3EP0NXAtq5FTXd5KnyHAqBDr9fGhwkqXbQMUf4AzeY6PL42IraUHrD1K1okqdE0
         z+U4+XFvNN3zySOa3t8PuZeDSCwDfCTdXwO7zdWfsm2NoIaoDrJSX5VM6Lf6GDIWyK
         WgVodbXO2c6jwHAUoeNBcLJCur43ITt3ZuQoWrdp75Q/jjU5R2NPoAnhecsBXtmtYV
         xOcQxYYaaqJ6U2j7t8UtA1HDII9XdJXqcrD+n1tjqkiZf+L6cg9ZSh4O90cQ6KHoRg
         P3fuKYThX4ePA==
Date:   Mon, 3 Oct 2022 16:42:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>
Subject: Re: [PATCH net-next v2 0/5] Add PLB functionality to TCP
Message-ID: <20221003164223.53f2b4e3@kernel.org>
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
        <20220930045320.5252-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 04:53:15 +0000 Mubashir Adnan Qureshi wrote:
> This patch series adds PLB (Protective Load Balancing) to TCP and hooks
> it up to DCTCP. PLB is disabled by default and can be enabled using
> relevant sysctls and support from underlying CC.
> 
> PLB (Protective Load Balancing) is a host based mechanism for load
> balancing across switch links. It leverages congestion signals(e.g. ECN)
> from transport layer to randomly change the path of the connection
> experiencing congestion. PLB changes the path of the connection by
> changing the outgoing IPv6 flow label for IPv6 connections (implemented
> in Linux by calling sk_rethink_txhash()). Because of this implementation
> mechanism, PLB can currently only work for IPv6 traffic. For more
> information, see the SIGCOMM 2022 paper:
>   https://doi.org/10.1145/3544216.3544226

A bit of an unfortunate timing. Linus just released 6.0 and we went
into feature freeze AKA merge window. Please repost in 2 weeks, after
v6.1-rc1 has been tagged.
