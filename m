Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5B6C20AF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjCTTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCTTBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC14269D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58544B810A7
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 18:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9C2C433AE;
        Mon, 20 Mar 2023 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679338428;
        bh=aGTAjjvCaUpBHwx82GdSKeBNOVhRQ4Wo7wkeig9ExLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZncYTl1olKL0humIHpy+FKibbg8cqfQlCoY/LduwEfAm2xo+5ch93YJ7sGiFxJSNr
         oBUkNiP/3T2vJk+p1mXkZVuDsrWEoDcQfPO1XdRypc2JXHZMPrMKZVJHC14/pjKmAR
         6TycYXr4W9hJ2qywWYtzvalGgkqEbIgNOECZEQFhrY3FBi33H3Go4OvVF0pXUhEEGm
         YJ/ALEiyortjN06cCCFsB6Y1tmZqUa5ZMFM0hk6KIM5t2Mo69VNxhmMrZnO3YdVywQ
         tVUfeR0hNM10QJd192iVvYnOpI6+i7DLalhrO2aWLPT86Tl0S76Cf1vA6IYBBci+sx
         UK0e9Z4+0rlzA==
Date:   Mon, 20 Mar 2023 11:53:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 3/4] ynl: replace print with NlError
Message-ID: <20230320115346.3474aa92@kernel.org>
In-Reply-To: <CAKH8qBtaWOOdcfZ2s1Nym6oB1=rC4cxxO6Q5z39yvAyQMgNyAg@mail.gmail.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-4-sdf@google.com>
        <20230317212144.152380b6@kernel.org>
        <CAKH8qBtaWOOdcfZ2s1Nym6oB1=rC4cxxO6Q5z39yvAyQMgNyAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 11:03:24 -0700 Stanislav Fomichev wrote:
> It seems that __repr__ is mostly for repr()? And the rest is using
> __str__? My pythonic powers are weak, can convert to __repr__ if you
> prefer (or understand the difference).

I used to know but I forgot. Let's leave it be unless someone chimes
in and tells us..
