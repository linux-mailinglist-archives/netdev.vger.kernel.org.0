Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7A6E5084
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDQTB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDQTBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:01:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AA249DD;
        Mon, 17 Apr 2023 12:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40DB611BF;
        Mon, 17 Apr 2023 19:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6FEC433EF;
        Mon, 17 Apr 2023 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681758113;
        bh=pUQsRK2HHtBTEizrDJUqpSN9HwdIy8SdQUjD/fbmkvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DqXpfZ6CZUUejW+o7NfwfIHlQohPbq0iVu6KmzFD2akkuTwDI98z3onwKRH5fUk78
         yCZ+Q9EBxBvdqytWYUQcxzm4x6T9WTjCVAxLh8mclqd9dA5RXivrhYJaiQrqkZ9+1E
         KcSK3SNZWXrAV5DhrTgrV/ZRpurStoRYYTPq/Z6a1LnecZeYo064vVzsgCAsaZHQZo
         fu7b//78L7B6unHAYMkF+zg35JON8ZfnpHxzuii9rDHVFRUjG1/jB+8ika8wRYcYr7
         CCU7atasDSCRrQggGuXefenv0kG95IoE7IFF7Mirw7uavLwahQhm/ayj6InEh5zMMi
         zCvxQ1iLc8NPg==
Date:   Mon, 17 Apr 2023 12:01:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Message-ID: <20230417120152.1ac03faf@kernel.org>
In-Reply-To: <20230417170741.1714310-1-shmuel.h@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
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

On Mon, 17 Apr 2023 20:07:38 +0300 Shmuel Hazan wrote:
> This patch series adds support for PTP event capture on the Aramda
> 80x0/70x0. This feature is mainly used by tools linux ts2phc(3) in order
> to synchronize a timestamping unit (like the mvpp2's TAI) and a system
> DPLL on the same PCB. 
> 
> The patch series includes 3 patches: the second one implements the
> actual extts function.

Please wait at least 24h between resends.
Please read the rules:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
