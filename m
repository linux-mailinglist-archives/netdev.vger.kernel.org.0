Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F98556F81
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359261AbiFWAeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359258AbiFWAeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:34:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC83F2E681
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5733FB82172
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3CDC34114;
        Thu, 23 Jun 2022 00:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655944444;
        bh=yMQsPZyQTYVtAhJqgeNyVsBYBKOvC8wc+c47F5qs1+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BUusCdGcUVC0fUxE7cU+QaYT1qB6LxWE9WRfMLceFcjyDcucj2rR6ZHPYkydEHFLC
         CHjToZ7tlNOJoDCa2ihV2EXk0Scor03fUJ89WMqEe1uLMJqW8CBLHmxM9EpwGMH1Yk
         e8nPy5v9NUIgIzrUxzNqRJeqJsqMjKA8zW5OKrVvN6xvoVyuGdkyXo08g19dt2gLZq
         gF6goO/Q2u7aQ4rkMCiJY2Bwp6Wdqvs5sb5pceut8GWR/6WkbNOGYa7eqqpgLhEhFZ
         CpWm9jaaV1qrWNQopOcDE8sz6mFoYs8snEqc3MOq9q22p1QQpGMeI+gelac1kU0x1H
         yKe/HikfE46Zw==
Date:   Wed, 22 Jun 2022 17:34:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 00/19] ipmr: get rid of rwlocks
Message-ID: <20220622173402.190223f3@kernel.org>
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
References: <20220622051255.700309-1-edumazet@google.com>
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

On Wed, 22 Jun 2022 05:12:36 +0000 Eric Dumazet wrote:
>   ipmr: conver /proc handlers to rcu_read_lock()

convert

>   ipmr: convert mrt_lock to a spinlock
>   ip6mr: convert mrt_lock to a spinlock

patch 19 did not make it :(
