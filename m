Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A5B52D9B6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiESQDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiESQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3A33FBE2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 09:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3159BB82552
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA22C385AA;
        Thu, 19 May 2022 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652976189;
        bh=JmWLNtXD4YSmMOEEfLM3maiZaMWQT6fNiCZllw+odiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FoKUI9eT6DcGOLXtdPwlrpJ6mznCRXHmvfNgWC+fFjSlH/dcTI38WaVoYJHusAVks
         I5su5kJtW5TsITEoPMXP5mWM5RBVbha/ZBpEqMT9714GzaRW95vXTfIcU+638B3Ved
         nLwbqwfV3kbg4YAeoc0bUrHxh4CqF7c8wRnV7BkHZoIpgXALTzaI2CxE6hSGx/2HVt
         oOhjSF24yhg8rU50gFKDgmSQ4gaPY4ZwYf1uoWi8P+ucU1wwm2JmAT3VEEpWJgB9+k
         6TQjSyg5J1NNWLf6tnj4TwFqrUK0AsV8RGl7w1Y6/tbHbTORJXSahX0hkUsXHkTfxs
         glbnqQhLVCT5g==
Date:   Thu, 19 May 2022 09:03:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [regression] dpaa2: TSO offload on lx2160a causes fatal
 exception in interrupt
Message-ID: <20220519090308.77e37ffb@kernel.org>
In-Reply-To: <763a84db-d544-6468-cbaa-5c88f9bb3512@leemhuis.info>
References: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
        <20220504080646.ypkpj7xc3rcgoocu@skbuf>
        <20220512094323.3a89915f@kernel.org>
        <20220518221226.3712626c@kernel.org>
        <763a84db-d544-6468-cbaa-5c88f9bb3512@leemhuis.info>
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

On Thu, 19 May 2022 08:07:15 +0200 Thorsten Leemhuis wrote:
> ICYMI

Oh, I forsurely missed it, don't look at the bz.

> There was some activity in bugzilla nearly ten days ago and Ioana
> provided a patch, but seems that didn't help. I asked for a status
> update yesterday, but no reply yet:
> https://bugzilla.kernel.org/show_bug.cgi?id=215886

Well, GTK, thanks.
