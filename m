Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272BB6CABA7
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjC0RO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjC0ROY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:14:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC2840CD;
        Mon, 27 Mar 2023 10:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3CA2B817AE;
        Mon, 27 Mar 2023 17:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D36FC433EF;
        Mon, 27 Mar 2023 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679937252;
        bh=EzT1iCSlFcSK5kKiy7ySRjlo9lEivUJvFagXJJrkHMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KNGNA3JYx+BGQxqz6/k8Sf9hXW9nwgtoyLyMvzqYET0WovZftIGncJBE1YR9H7I/g
         Qzr1n63Up6N6Qay4kMOxi3FnAKiuQf+CXg6kX/pl+hKjSfiwKVk3osOlaNDOMLV/Za
         Ha8XJ9MojDzP2VZ+xrA6KzN818r/+DJGXq+jfvn0JDSY0JW+GRU50R50lzWzKiDg55
         dbcTJXX5z3pOq6UbOspKTdwyiupsQCSMkEVeXbGjMNR5cVaj9a4zUM9mExpkzxZQTD
         7xody3sQRCTx6uQagDjPO8a7EErjfmYSZMa+AuzVOWiVTPerTCYX4hLGu7oaUw7mdt
         sdJHqISqEK33Q==
Date:   Mon, 27 Mar 2023 10:14:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/14] net/sysctl: Rename kvfree_rcu() to
 kvfree_rcu_mightsleep()
Message-ID: <20230327101411.5298b38c@kernel.org>
In-Reply-To: <CAEXW_YR7njsiRxZtGpUftBQ0hFOzfzsLGQwfrgPwanucO8wATw@mail.gmail.com>
References: <20230315181902.4177819-1-joel@joelfernandes.org>
        <20230315181902.4177819-5-joel@joelfernandes.org>
        <CAEXW_YR7njsiRxZtGpUftBQ0hFOzfzsLGQwfrgPwanucO8wATw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Mar 2023 08:28:45 -0400 Joel Fernandes wrote:
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: David S. Miller <davem@davemloft.net>  
> 
> Could anyone from the networking side Ack this patch so we can take it for 6.4?
> 
> Eric or David?

Let me help you. Perhaps it's a data point against keeping maintainers 
in an alphabetical order :-)

Acked-by: Jakub Kicinski <kuba@kernel.org>
