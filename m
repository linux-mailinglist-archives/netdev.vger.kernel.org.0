Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD71C585841
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiG3D0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbiG3DZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:25:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A6013FB1;
        Fri, 29 Jul 2022 20:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A73FB82A26;
        Sat, 30 Jul 2022 03:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2194DC433C1;
        Sat, 30 Jul 2022 03:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659151556;
        bh=UBeLDokSW7Uw91vGweVcIzOUAi+PPAN18+Bhn4VyfhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sjjJXWUhywf2Wjj5sUCR8TORyx9htodxIXWvq/srBOKTtFllaFYXWxsRf9jbtwMpR
         gjl3obD6d0UeuqtuF+GANNvL22FxcF7GgTR+O/W1411iH+ce0E42Rs5JcGq8dut/fz
         8b72O0CNtoKeGA2VLetbmci71SE3ljaf7yxFKuko3qkk30GMfg0lpS8NIrFOAO3sqP
         qiaPADoLlEwLFV6f1qPNglkRgEGDduXvJVvIgHFVmZ5vKDJuQvvvryK+tZqD941MgN
         QzQHIsuZmLWlORluvnKQWPWjVwIy15NBqIH452xpGGnWuQNoEQ6hQ3bGDRKdD7LVW/
         eutfQr2VYssdw==
Date:   Fri, 29 Jul 2022 20:25:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 0/4] Add PTP support for CN10K silicon
Message-ID: <20220729202555.72605f39@kernel.org>
In-Reply-To: <20220728121638.17989-1-naveenm@marvell.com>
References: <20220728121638.17989-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 17:46:34 +0530 Naveen Mamindlapalli wrote:
> This patchset adds PTP support for CN10K silicon, specifically
> to workaround few hardware issues and to add 1-step mode.

You need to CC the PTP maintainer on ptp patches:

Richard Cochran <richardcochran@gmail.com>

please repost.
