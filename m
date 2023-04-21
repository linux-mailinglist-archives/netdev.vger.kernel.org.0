Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B616EA214
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjDUDAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjDUDAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:00:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF3072BC;
        Thu, 20 Apr 2023 20:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26AD64D67;
        Fri, 21 Apr 2023 03:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BFBC433D2;
        Fri, 21 Apr 2023 03:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682046040;
        bh=hHG84lJEy9C8r6Qs2g7Ws1CEYbPqRRuN8NEErwB+SfY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cIY8u2ALCv/bPPqYlRi+BgDFfdA/OLbh7wIpsjC8iu9Cwo8DveWOLquGLl8v7T6FD
         b+bh8UvBisjp/dg1Siu1e6PyCJNQJ3i+90Bpc2edq3iTk4FGhoGXsG+AA/md4NkksE
         AXmW71OWNInjkPEcqzo6+pSzWD65gLsJ7yPklpRDK0L8kCHJ8aHne7nY4//PwGCZQq
         pPh9VnoGoC1mQ5hmRPplFBUn30aOHMrJIDW9mc328emipIeTDNEGmQJxYqVlVNFNLO
         HCWHrkUythcFpHE8ausBFmSsaEqQwSEkaaq1CWcdist7QXf6uKL8bjujAFx6mNyezs
         MhJXdAPcjdhIw==
Date:   Thu, 20 Apr 2023 20:00:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v2] wwan: core: add print for wwan port
 attach/disconnect
Message-ID: <20230420200038.7b85acc2@kernel.org>
In-Reply-To: <20230420023617.3919569-1-slark_xiao@163.com>
References: <20230420023617.3919569-1-slark_xiao@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 10:36:17 +0800 Slark Xiao wrote:
> Refer to USB serial device or net device, there is a notice to
> let end user know the status of device, like attached or
> disconnected. Add attach/disconnect print for wwan device as
> well.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Looks the same as previous posting, applying, but please make sure you
include review tags you received.

https://lore.kernel.org/all/CAMZdPi_WFxQ_aNU1t6dDh7F_aBB99XyeoFGBW2t6DryoJyFJuA@mail.gmail.com/
