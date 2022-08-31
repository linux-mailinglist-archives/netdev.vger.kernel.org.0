Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520DB5A8816
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiHaV2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiHaV2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADDEF72F3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 14:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7951361AA6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B6EC433C1;
        Wed, 31 Aug 2022 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661981281;
        bh=9QJhBFPKZqWfS8WS8K7M2XUF24Z05zYlT+q7pfG7DNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JQO4XvDG/7YLBVA4cpnG7ZtwX/ZQb291spsKq9/LuZbRjU1i2oXq6VAsXIV07cfQq
         rcLf5qvpbpsggOJNk4Xjot5yVijxFnZMjTsluAVnhpjHAvXQAZkOkJiz9H98i0V1IB
         KkPXmdR6zNKlPPEy3uhHzO9Ds7drEePrI74dEiZm8awtOB4MUHXzbt4ih75gy7pHFS
         NnALKXb6w4z7C5UW/XcGPgg9G+P8/vw9igHU1ixgdgCMu8/+3vovpy+LhKgLSjFmXn
         TewlWGJxB0ABJB//s9omJBy6jNn/38bw7PZJVUd5O1ppOodAaURoOrw9abFh2Vt4iH
         DvAfRYgRZWXYw==
Date:   Wed, 31 Aug 2022 14:28:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220831142800.26924fc8@kernel.org>
In-Reply-To: <20220831171259.GA147052@francesco-nb.int.toradex.com>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
        <20220831171259.GA147052@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 19:12:59 +0200 Francesco Dolcini wrote:
> > Fixes: 91c0d987a9788dcc5fe26baafd73bf9242b68900
> > Fixes: 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5
> > Fixes: f79959220fa5fbda939592bf91c7a9ea90419040  
> 
> Just
> 
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")

Yup, and please remove any empty lines between tags of all types.
