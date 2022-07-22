Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945AF57E5BA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiGVRhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiGVRhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:37:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC178EEED;
        Fri, 22 Jul 2022 10:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D66B829C6;
        Fri, 22 Jul 2022 17:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0526FC341C6;
        Fri, 22 Jul 2022 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658511471;
        bh=MZHah33Q/RjQJRP+KgiWX1KH7CBqjB5/nEQHt5RSPN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AMCy899mwwwx38SabBUAi8bJzl1BiwuD+uOSw3Y0O4g0KgpWLFwS1JG2x1GJQX6h5
         o+6cBAiIom26A85U0M8Z5bblaIsSxxOByak/IngpcrmB7VTVWu9u7i95ahqRK/jAID
         8xSYbzbilTJGSEeGuRV54CGSGgFPxEB+4r8PwOCEPJiRAvoaJsxrZL9kNvrNltl0pI
         2RTqO74ew4f3EUpvj20l39S7HRKiT+o8ohTLQMDUjGslO+U12tdA+PUpAk280eFopR
         iNdFQM7sLgfiFln/ct4UQ0teGN+jzPI1sZH0uEUONIDdCNmP+nwlir5obM24If0z/a
         ewic3FRzQOHPg==
Date:   Fri, 22 Jul 2022 10:37:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bernard f6bvp <f6bvp@free.fr>
Cc:     davem@davemloft.net, duoming@zju.edu.cn, edumazet@google.com,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org
Subject: Re: [PATCH] net: rose: fix unregistered netdevice: waiting for
 rose0 to become free
Message-ID: <20220722103750.1938776d@kernel.org>
In-Reply-To: <9c033c36-c291-1927-079b-b4aee5f7ac08@free.fr>
References: <20220715154314.510ca2fb@kernel.org>
        <9c033c36-c291-1927-079b-b4aee5f7ac08@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 18:41:28 +0200 Bernard f6bvp wrote:
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
>  Thunderbird/91.11.0

Still whitespace damaged, can you try git send-email ?
