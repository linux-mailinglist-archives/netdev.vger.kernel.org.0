Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32D052E0CC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343706AbiESXrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343732AbiESXqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:46:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16327396A5;
        Thu, 19 May 2022 16:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C31FBB828C5;
        Thu, 19 May 2022 23:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FEEC34114;
        Thu, 19 May 2022 23:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653003965;
        bh=WP9Qz2fNWJIb9wb9yT4v0TkabqFVheLP6tznqJmNZuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=crjf8+O92Jda3AFEcX8eQUe5Si5tqDUxpyhrw5FF/ufIRbMoVEKlXE1e5vAX8WbxM
         AEMLkiwQIPd4YIowJOSwgQ4uPH58g5R/g6AG+8OqXj9H86vsU7ZDZUNgpx3+/wehPF
         usNAY07YCI48i3tXfO6jLV5O31Ymn3OHPPD+sgGqHhTFUEvplLwRVJRPMuN06kZJjr
         Ykl1TR0i7ABK+5TwaeI0BI86Cy4GtQtDP7h7FurQq8rX2z4QVzRgE9k3SUCaEwLlOP
         9iVC91+9pHTxTNwWCjt8DQvU+/93TnQ0qCfZU3SbXNInux9NPDr/XgYiUMFhiKIxDe
         m+qqQUJ8oRAYw==
Date:   Thu, 19 May 2022 16:46:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_clockmatrix: fix is_single_shot
Message-ID: <20220519164604.292f45c7@kernel.org>
In-Reply-To: <1652988059-8740-1-git-send-email-min.li.xe@renesas.com>
References: <1652988059-8740-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 15:20:59 -0400 Min Li wrote:
> Subject: [PATCH net] ptp: ptp_clockmatrix: fix is_single_shot

I put your patches in net-next, because I could not understand
whether they were a bug fix or a feature. Please resend this
with [PATCH net-next]

> is_single_shot should return false for the power_of_2 mask
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

And since this clearly is a bug fix it'll need a Fixes: tag.
