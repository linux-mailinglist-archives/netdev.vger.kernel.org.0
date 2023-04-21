Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849506EA24F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjDUDZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjDUDZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:25:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB69F10E3;
        Thu, 20 Apr 2023 20:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44D8860ACF;
        Fri, 21 Apr 2023 03:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A51C4339B;
        Fri, 21 Apr 2023 03:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682047551;
        bh=YDu3KLe7lykirea3rL8THfo3mJjSppTvOkZadvSlh1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VhySG3GQ7RyWXIa6FWJOGd51C/GQb6U1cMQUTbWrRe5ZWvCxVaCB/dqLNjUVl9HXr
         EgOZyZTibq/itlMJ6rWU6Z+sofVuC4tx3XMzgK9u9dihH/N9GQ3DQy1vKMZttQqZje
         nt/YhDjgVZfsxZi6ua1Kag7uJB5rTbZEDoL9bmy2SLYh+P8wZ1SNI6MzySCwJm9esv
         +NxN6xGRdH4j4ptd4dqNXvDBK0U2CxwnXfN4wF4bhBtCB4lorv0+rsNLDTAZM8ykv5
         fVax+vNHU/YeazCOZYI0AF7nexbY0/m3If6tIP0EhAk2WRxIloIzncT1xs3QAHkGUG
         LgF30Z4nnNpAw==
Date:   Thu, 20 Apr 2023 20:25:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 0/2] Netfilter fixes for net
Message-ID: <20230420202550.1b466802@kernel.org>
In-Reply-To: <20230420170657.45373-1-pablo@netfilter.org>
References: <20230420170657.45373-1-pablo@netfilter.org>
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

On Thu, 20 Apr 2023 19:06:55 +0200 Pablo Neira Ayuso wrote:
> 1) Set on IPS_CONFIRMED before change_status() otherwise EBUSY is
>    bogusly hit. This bug was introduced in the 6.3 release cycle.
> 
> 2) Fix nfnetlink_queue conntrack support: Set/dump timeout
>    accordingly for unconfirmed conntrack entries. Make sure this
>    is done after IPS_CONFIRMED is set on. This is an old bug, it
>    happens since the introduction of this feature.

It missed our PR anyway so please resend with a signed tag.
