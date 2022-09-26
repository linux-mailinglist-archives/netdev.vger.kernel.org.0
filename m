Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5DC5EAC56
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiIZQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiIZQUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19419E2358;
        Mon, 26 Sep 2022 08:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 996CD6068B;
        Mon, 26 Sep 2022 15:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE34C433D6;
        Mon, 26 Sep 2022 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664204952;
        bh=pwuba6jvnTrO2156q7RLZabQFaxzkBuXtJWFTVuY/0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PfYF18eblSgPjJouJIX7YJwYI0k5lXq75DjzVHsQRAhH8JAZB6QEW28Gdl2+upjrY
         ladwjCF28jOU8R6OJYBxg+YOeXXoXVeWAUfFFWDjbvlnSEjX+pQZ+7TFzDyP+v5dVa
         LpFet7Ytx36Be12QfNw7Q4dVXe7jCqAXP6+vjGXknSRB5oPkJ2Bs5ok6D0E92KKO2i
         WtPT3/J9ygO5hpVc7pKEzcqW4ZR9p84qr/ZeFykA0h2MXVu7cBHhsjJj/nJOzih9Ng
         TXVcgN9KcZkPCitUb0DsjxEZ3W85+6WH/U0qmpX4jw3YDTIW1AzOxN2KGGQYU18Gx2
         bxFiKJWrg50/Q==
Date:   Mon, 26 Sep 2022 08:09:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 0/7] cpumask: repair cpumask_check()
Message-ID: <20220926080910.412408f9@kernel.org>
In-Reply-To: <CAAH8bW-TtZrvR5rZHVFXAHtfQySD85fqerxAAjUTN+eoh1bP2g@mail.gmail.com>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
        <CAAH8bW-TtZrvR5rZHVFXAHtfQySD85fqerxAAjUTN+eoh1bP2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Sep 2022 08:47:24 -0700 Yury Norov wrote:
> Ping?

Sugar sweet, you really need to say more than ping. You put the entire
recipient list in the To:, I have no idea what kind of feedback you
expect and from whom.
