Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210D85A0737
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiHYCRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHYCRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A4A8FD4E;
        Wed, 24 Aug 2022 19:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C52AB826DB;
        Thu, 25 Aug 2022 02:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D89CC433D6;
        Thu, 25 Aug 2022 02:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661393858;
        bh=kq1JidIMwZaAE/E4q/UVs6JBseqoK4aZ6GCspgj6cRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XwAL8YZPhz4UjlVFJERhp0AY12rfsSxLwDvV6PUKmshvG1mZQZRoO2D/lZ8CuobPK
         t/N2DsxTPUyMOd/3Wjm6iWfdOlqc1NKOMVJTQwPy1nZGemau3fi52xltWz50uuHwKn
         BNZwPxd/JW4/Lfj+B+8VjdU2U/XJKsfXpcB/FRy9Wxm2O1NQUabez9OTBwVc/FEKIL
         jU3CQ9BSs1dwp6NJHZUId5oRjnkHvSlLN/kM/WQTmcmFu/XFhH+Lcrp4O4OexXhH+v
         Kze4O84C1b7V1IjuVp0E/SSlMYMFss9vxdMTaXQp7vpNVIGY/Sqb7rpa5dTA3cjRZV
         qbvlq0Z7/H4fw==
Date:   Wed, 24 Aug 2022 19:17:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 14/14] netfilter: nf_defrag_ipv6: allow
 nf_conntrack_frag6_high_thresh increases
Message-ID: <20220824191737.27369f7f@kernel.org>
In-Reply-To: <20220824220330.64283-15-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
 <20220824220330.64283-15-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 00:03:30 +0200 Pablo Neira Ayuso wrote:
> Fixes: 8db3d41569bb ("netfilter: nf_defrag_ipv6: use net_generic infra")

Incorrect hash here, should have been:

Fixes: 8b0adbe3e38d ("netfilter: nf_defrag_ipv6: use net_generic infra")
