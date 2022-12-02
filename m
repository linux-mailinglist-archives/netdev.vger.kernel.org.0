Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C681463FF4E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiLBEFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiLBEFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:05:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F01D03BC;
        Thu,  1 Dec 2022 20:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3750FCE1DE3;
        Fri,  2 Dec 2022 04:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4B1C433D6;
        Fri,  2 Dec 2022 04:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669953936;
        bh=eQduLD1CaQJBrT16fPY+PEEtH9DVBuaJ5vuTkbvSwLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LfJwcjSBZ+d5QuNRXGHPmFKWG5HONHQmPePDHYer4pmeUtEP/tnWnPpnWE7bpqVaB
         dtvqeK5E9tivaM6NhbwT6TnOZ45aYNMznwBl7CgEW3vl4BdoXyvIfragX9fu2vu7U0
         o5cAWqu/xn9kRocnRLcSmCqo3okpQikValkI6LX9oijsvgASs2ftA21smjKRfoR3mO
         ZwBRdjQ9/8iMf8BerSFBrqbk5A4/CcFOrWheVTTTojN7VHhOZ9VWGOcbQqXcsNcmYw
         BdNrPAeYKelsyBz6FMIrpPAU8PQrOCLcdpebBL5j+dyC4dYta25ZQpUzgOqRzB9n5X
         e2mnkJvwhw7PQ==
Date:   Thu, 1 Dec 2022 20:05:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 06/11] mptcp: add pm listener events
Message-ID: <20221201200535.14e208ac@kernel.org>
In-Reply-To: <20221130140637.409926-7-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
        <20221130140637.409926-7-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 15:06:28 +0100 Matthieu Baerts wrote:
> +	kfree_skb(skb);

nlmsg_free(), could you inspect the code and follow up?
