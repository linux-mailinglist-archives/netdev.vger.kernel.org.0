Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8C64A53D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiLLQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLLQtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:49:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB2A38A7
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 08:49:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0103AB80DCA
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 16:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725C8C433D2;
        Mon, 12 Dec 2022 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670863750;
        bh=e3LtydWM385mORGg/FvVsNW+NS0mPQVQAQQo33CRQgM=;
        h=Date:From:To:Cc:Subject:From;
        b=lbvR83h3J4fOCqlsIzEYnxeIUIsuCbYmzsqtFOr1vS4RUkxEV928q87FDIU7oFXO2
         +FSHvcUUw2m3fm78RTWfF6EEagEYwDLsqbGtarVzANvjR7UmKDm6WuHeg/K+yRItAx
         +dNzpG1620ejSqkDnQDNCTz86lltdQZaPNf7uxqs0xxEtgxzPec5tUthu8Cy7k0qw8
         uJmnFw9gFVASW5q5nZ/aKjAlG0h8of4GlANrmIKdd16gk60YOXgMi2FzZU67R5gh1w
         kkSaCWaP9q7O3w3oyLCz9hE8Ts+6x2sZU2UA9iRhd15WVsgsZ1AMIU1klpaDwmUUK3
         DwHm3fIRlLbWQ==
Date:   Mon, 12 Dec 2022 08:49:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: net-next is CLOSED
Message-ID: <20221212084909.55d2b5c8@kernel.org>
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

Hi,

as is tradition, net-next is closed for the duration 
of the merge window.
