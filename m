Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D9B6CB2DC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 02:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC1Aru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 20:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1Art (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 20:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89911B7;
        Mon, 27 Mar 2023 17:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6540B61567;
        Tue, 28 Mar 2023 00:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E786C4339B;
        Tue, 28 Mar 2023 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679964467;
        bh=2FYeD8ffkScZEMUU1n9D4Z2yo1o8/hHsEDpNFpRN6Fs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AC9M3oSvknEW32Xo9AiEtaaHlb3z9lISYBVOFBhFwONU5D8pIxL/q4jQL8lJ9jqPT
         agBKKrw7hJoOHyGnpej/pQLv4KqKaZ4MQ+FjlM6tpAvP236Oc9KEOOxGlHKCJahTDB
         3iRL4LBTxDIUqHhC9nLAs4w9YIXIKJ7B51Zm0Wa3PeI9S4ZLHZCn0QIgnR5U3WbkyN
         thsAov+HLXMRcnRUI/p+/tn6FpZaDrSsHKRCXfUPHAFyNWVmPVcBOTaML0V6s3jqko
         jDAzxffJv31Kxodua+Hww5LgtY56W1FwC9Z/Ble3WNzmgzEdedLFTZa7Pca0Tp8X0b
         IfPGWqaXkW/mQ==
Date:   Mon, 27 Mar 2023 17:47:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shinu Chandran <s4superuser@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_clock: Fix coding style issues
Message-ID: <20230327174746.499fe945@kernel.org>
In-Reply-To: <20230325163135.2431367-1-s4superuser@gmail.com>
References: <20230325163135.2431367-1-s4superuser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Mar 2023 22:01:35 +0530 Shinu Chandran wrote:
> Fixed coding style issues

If Richard acks we'll take it but as a general rule we try to avoid
taking pure formatting changes in networking. Too much churn.
