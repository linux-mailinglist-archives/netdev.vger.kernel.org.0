Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B22552AF9A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiERBEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiERBEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F7654024
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4997061586
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888A7C385B8;
        Wed, 18 May 2022 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652835866;
        bh=RJ2h8hVguwTg4NZUSmKguf/5+roiwvvrzwIBgZ/iY4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfaH6IVWsIMRlvmtV2YjGiEhj4Q+R8kRSzyzX/1IOziOfnnMSL4MqV10q2l1wdm8Y
         +258QWSqOcOrMlPTnupnHFyYw7wsTsyLtHIBR0ovevQRha7dkEUc3A2jbyc2XnlROV
         zZaY0S/niew0upn4gvGg8f51fMu9g0546ohShshhpBrGM7Ra80yK0wN2R+6SiKayH2
         6jsQAQ7IjiMiyFZf6Dc7OEaKKBSerz2Z+IA/fhWxiqMzJsWpaf2rCR8Q3xEx6xLwVw
         Sp155bia2OnsngYDxaeZtfSzUmDcMSZEZTPWkdt1Ljy4qBfOe5e7c2AYzG3ZAxDKHZ
         8JcPegza+kQOA==
Date:   Tue, 17 May 2022 18:04:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCHv2 net-next] dn_route: set rt neigh to blackhole_netdev
 instead of loopback_dev in ifdown
Message-ID: <20220517180425.2ab74aa9@kernel.org>
In-Reply-To: <0cdf10e5a4af509024f08644919121fb71645bc2.1652751029.git.lucien.xin@gmail.com>
References: <0cdf10e5a4af509024f08644919121fb71645bc2.1652751029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 21:30:29 -0400 Xin Long wrote:
> Like other places in ipv4/6 dst ifdown, change to use blackhole_netdev
> instead of pernet loopback_dev in dn dst ifdown.
> 
> v1->v2:
>   - remove the improper fixes tag as Eric noticed.
>   - aim at net-next.

nit for future patches - now that we add links to the posting when
applying you can put the changelog under the --- delimiter.

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
