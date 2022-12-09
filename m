Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2144A647AED
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLIAqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIAqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:46:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FFB51332;
        Thu,  8 Dec 2022 16:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E46D620FB;
        Fri,  9 Dec 2022 00:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA65C433D2;
        Fri,  9 Dec 2022 00:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670546777;
        bh=LXDU2h27bGgWhtnv4m35zMPuHlR57ei0FUGmguYr3ys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQ//6m0ccAaFP9uMJ6DziqlCbEuKBU4qFzTWOlmOuRJgS/FrK3kMamNJHPac2vjWc
         vkvFRLnHRmvueBboiRXxJvJpaFgfd1QVDqEOMpHFlqEjmJldz5XB71ohQHDHeegIXM
         ayYI8kWs33y/W/OkwdmstoQ0LVrkqHcS+dT6BHiKfG4pkziXSoLhnKLHRMStli8AnJ
         o7iyZVX16GS7JRARRtQvRozyhYnE4ifxlR07zmwlC26Osf97XreufCy6Ib9bfsCLqE
         MNvAbWcn/KkU+q+1ReFRelHE/zwHn77uzLWVzojE20Hpisfmftlq8Hb7GFxENuI0z6
         xqJA+rybjWXvA==
Date:   Thu, 8 Dec 2022 16:46:16 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next v2 4/6] tsnep: Prepare RX buffer for XDP support
Message-ID: <Y5KFWAX5QV/k6Ngw@x130>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-5-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 06:40, Gerhard Engleder wrote:
>Reserve XDP_PACKET_HEADROOM in front of RX buffer if XDP is enabled.
>Also set DMA direction properly in this case.
>
>Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

LGTM:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>

