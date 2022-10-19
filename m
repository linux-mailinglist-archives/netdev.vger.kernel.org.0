Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544AB603815
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJSC3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJSC3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2F66D9F7;
        Tue, 18 Oct 2022 19:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC9BB61757;
        Wed, 19 Oct 2022 02:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC34C433D6;
        Wed, 19 Oct 2022 02:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666146546;
        bh=XaMinZPA6FphhuKxsMEDvnDI0O6vGbqFBXSn9EvEMzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nq2rbg4nhr2EYB4wSOHKcIRTCvJogAODraO/mzJKBbb0Pj+ddVdp9d784KG9KO4IN
         v8yveHyKHgh8AWMBY8C04GGQAx5luw2+ypUoz4kTiS34UNjCT0HqYeL9dRHQTdENzX
         sMzyuHdq73VYmiPiKBEw4ojPXcAAMpYJeYOhlanhpOHT75qv4EB+Fuo0g7NtHxNuR2
         KvYE5uUJk1tGLDCWOVLH1kEWf+wChQGsRlpqQrUkNnVbhgvkkj/wkCAUj1nMFKZYCQ
         DcNN+BMJcZhV4pUWRZI2pcoclaBzF79mGbxEjBUhUpim9+aYGcGpF1vycaFdcqwEpT
         iV1ttqJkS0mHg==
Date:   Tue, 18 Oct 2022 19:29:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bcmgenet: add RX_CLS_LOC_ANY support
Message-ID: <20221018192904.4beb2f41@kernel.org>
In-Reply-To: <20221017213237.814861-1-opendmb@gmail.com>
References: <20221017213237.814861-1-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 14:32:37 -0700 Doug Berger wrote:
> +	__u32 tmp;

nit: please name this more appropriately and use normal u32 or unsigned
int type, __u* types are for uAPI definitions only.
