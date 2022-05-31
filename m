Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93C85396E6
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiEaTUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiEaTUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365F28CB0A
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7D9561200
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1069C385A9;
        Tue, 31 May 2022 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654024817;
        bh=8THaHmAAbCTmq1YUyBXhoSw10XxLNW0Cv7tBdOZo99k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gCxeHluLZE8jFWTS8lhuA+qOJplImzDa6Ux1Z7v9u+Bv0aAYj3+EYo4CQ8dEPDSMw
         x98jbRVdy5BsZSFrEAIu6qWeaIE5OFJj29mhyygZ3A2yPvUITYqbbBiM6M17mk6oCD
         MFOEDTWhNtgxAs4fyGuZZU8/eALz+YtzUzMeqk4p6kiJnl2ooP7QgsW1GJPmZ2iBwW
         PUfyVObEQZV9cf8e7Xpv6fvMvvIe7O9fXa79zIqtUMjWB+Hh7je6TwT4C1DIHzzsBO
         6iGAQmnZe/uGjbxAl7M29JN/Zv41VFBuDriHbHo28Wunq28XB09N6+oyx5ZfsABiEa
         ICL17AQh+/Hcw==
Date:   Tue, 31 May 2022 12:20:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Message-ID: <20220531122016.03dcea09@kernel.org>
In-Reply-To: <20220531121829.01d02463@kernel.org>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
        <20220530111745.7679b8c4@kernel.org>
        <20220531121829.01d02463@kernel.org>
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

On Tue, 31 May 2022 12:18:29 -0700 Jakub Kicinski wrote:
> TLS_INFO_ZC_SENDFILE

I copy/pasted the diag name, this should be TLS_TX_ZEROCOPY_SENDFILE.
