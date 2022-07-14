Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141E95741FB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiGNDlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGNDlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937BD13FA1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FD7361E19
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607B9C34114;
        Thu, 14 Jul 2022 03:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657770061;
        bh=frE/IVU0aw4awEWRr7WTSnJ37ka5+JeZfsQPkK6jkSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FW0C3nIocN761YJeujV8TcpGx7K9AN9psk9SrXE/V7bvWKwEk+U5qfFwtcGgGwTGh
         GmaNdtxONGJi1t/HZZl7Lx5/qzrqLdyXTyngGQHpxGdlehkXmoKry14ceEVQJnDJf3
         v7owsI8YFrsvYRjidmYqK/TD2lINV0k3VVxZ6fRMLWvPTM03QeOw7bgyyBylfnk+/i
         YVhhSmpDLBaAdMIpcgzgziPd6cveJnJcKHJ/M4iTiSjtuoA7Mg0wNSt1se7iT3bEuz
         fRhPq7NRsAPboEGidrqG6RhRgTWYiFIx9REiyqc8GuYTSWZZNQZqWEfunwj0xkt0Qd
         ZrSnApPIyyNJQ==
Date:   Wed, 13 Jul 2022 20:41:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: flower: configure tunnel neighbour on cmsg rx
Message-ID: <20220713204100.6fd9b277@kernel.org>
In-Reply-To: <20220713085620.102550-1-simon.horman@corigine.com>
References: <20220713085620.102550-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 10:56:20 +0200 Simon Horman wrote:
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> 
> nfp_tun_write_neigh() function will configure a tunnel neighbour when
> calling nfp_tun_neigh_event_handler() or nfp_flower_cmsg_process_one_rx()
> (with no tunnel neighbour type) from firmware.
> 
> When configuring IP on physical port as a tunnel endpoint, no operation
> will be performed after receiving the cmsg mentioned above.
> 
> Therefore, add a progress to configure tunnel neighbour in this case.
> 
> Fixes: f1df7956c11f("nfp: flower: rework tunnel neighbour configuration")

Missing space between the hash and the subject.
