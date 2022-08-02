Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1258825A
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiHBTOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiHBTOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:14:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4559452DCD;
        Tue,  2 Aug 2022 12:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD84561474;
        Tue,  2 Aug 2022 19:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84D9C433D7;
        Tue,  2 Aug 2022 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659467681;
        bh=oZTLylDfp4JMPlyy1lSjX6hB/wP6iaMaNGYUspTOTw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DQfXyWI4jeRSSjfcL5AYN+97LEiE5S7UHWhgFsT2j5yKU+UwVhcjJs0JOZAjrZhbE
         G7W2EVmnjFd5WQOnf3mXPgOTg0yRkZQLTQBw4gROUiDRFkbqzgV1W7MU2LC/mZ1alM
         7u8Qc621JiVSeFC119VhRpKsBP6iMRgE+Xwqj2a6TR+XMO9YBAOH0WC3t16xX779X3
         7YhLLpTiErYp5fsryNdyd5W5K9qwHlNOCW55d+UJXdAWcSdpLdn40P2lbJeLFkVVPS
         P4EaZWA/cqtS32EQceiefuBgYNiueVzWlzVhrthLtiC3jiKNUpEONg85hBhhb7hhDa
         r8QlgjNW+2SAA==
Date:   Tue, 2 Aug 2022 12:14:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <richardcochran@gmail.com>
Cc:     Naveen Mamindlapalli <naveenm@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
Subject: Re: [net-next PATCH v2 0/4] Add PTP support for CN10K silicon
Message-ID: <20220802121439.4d784f47@kernel.org>
In-Reply-To: <20220730115758.16787-1-naveenm@marvell.com>
References: <20220730115758.16787-1-naveenm@marvell.com>
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

On Sat, 30 Jul 2022 17:27:54 +0530 Naveen Mamindlapalli wrote:
> This patchset adds PTP support for CN10K silicon, specifically
> to workaround few hardware issues and to add 1-step mode.

Hi Richard, any thoughts on this one? We have to make a go/no-go
decision on it for 6.0.
