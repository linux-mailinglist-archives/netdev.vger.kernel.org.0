Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0844C994B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiCAX0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiCAX0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD6D3818C;
        Tue,  1 Mar 2022 15:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6034B81E9B;
        Tue,  1 Mar 2022 23:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD09C340EE;
        Tue,  1 Mar 2022 23:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646177158;
        bh=51tGkB1qpUqmpT5Cc43/7n/OjIgMSooZatoxuPB4eUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NcHlJVXzwDBnY5VOffqydsyaGaMm3jnEPkxrXr9rhkWm51OoGAlSk7d/gghRdg1Cr
         TigkAioKjUMC4AE28nKK2u3QvfNnuvsWj3ZHNPcCgVcIWobqLlnl23of+DQPGVAjlw
         eyC/vSWFTjwIbiizSh9nWvE0ALsffkw4YCwg/XIxIfMxnVBeGgkW6+syNLrXXBM5XZ
         nlGbFWf2pT4ZI0tPubhASbbV8zIsrH9OkMQ44oh9T7Bx3vRuqWCUZxK4V4lxd/SqrS
         qou1hH6Z1J33h3OaLKzkcUrjrj3NJIn8+iyOc2t3QBqCtJa7f9DMjFToGprWyEZteC
         GVVn3zuix4M8w==
Date:   Tue, 1 Mar 2022 15:25:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] wireguard: device: clear keys on VM fork
Message-ID: <20220301152557.35f1efed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301231038.530897-4-Jason@zx2c4.com>
References: <20220301231038.530897-1-Jason@zx2c4.com>
        <20220301231038.530897-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Mar 2022 00:10:38 +0100 Jason A. Donenfeld wrote:
> I wasn't planning on sending other WireGuard changes to net-next this
> cycle, and this one here depends on previous things in my random.git
> tree. Is it okay with you if I take this through my tree rather than
> net-next?

Yup,

Acked-by: Jakub Kicinski <kuba@kernel.org>
