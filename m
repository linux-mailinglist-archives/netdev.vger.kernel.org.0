Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240496E873B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjDTBLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjDTBLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B8949C4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E666444C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37332C433EF;
        Thu, 20 Apr 2023 01:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953084;
        bh=aWpynGCqmUP+VoZfK4M4QoEqrKAm9+CWhno2Gk2xz4M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cHUjq/oeWNUY/+XoMTXKJ9eWacOtC6nAJuYL+TzSMO1daoMueSdK2Dju5WK2k0Y3M
         kSbuYnaiDk1AVxcOHjIN/HjPotAQ8MrKG9I8k5PH8YOSAUxN1cIAjUpqz09Fg8BuRn
         wtgTi6jtFqX43X+p8fTe/lr4X/QzkVnagalk3v7Pq04UuLldaSHyXzTBlLSVs34BmY
         D4S2XgV6TS2pUyKeoGmbzogkImBFM4f4EHrJ0IBtbk6PWfXz8wcREyasqpxQyPJdgN
         DDt4+RkftJyXa/YqYvMUoaKomlvzAIceCBD5k6YlywTqH0zec7LlpQEE3vaNjkaZMT
         sYDSQ7k/We2TA==
Date:   Wed, 19 Apr 2023 18:11:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <martineau@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net-next] MAINTAINERS: Resume MPTCP co-maintainer role
Message-ID: <20230419181123.15028d0f@kernel.org>
In-Reply-To: <20230418231318.115331-1-martineau@kernel.org>
References: <20230418231318.115331-1-martineau@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 16:13:18 -0700 Mat Martineau wrote:
> I'm returning to the MPTCP maintainer role I held for most of the
> subsytem's history. This time I'm using my kernel.org email address.

Small world, welcome back :)
