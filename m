Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A895B27C4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIHUfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiIHUe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:34:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52819303E0;
        Thu,  8 Sep 2022 13:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GXvDw1qTIcUMkHFnBOs5wTnQfEyjTmnArBTCDylyWbE=; b=sdea+9TfXrcbQqz1JVt2ens1JX
        qZ4LqRZDxgCZxi7ImH2fN2sGFyJqhqKgRMke3Pbvxgr04f8iQ2T5D7XzCFmoC+nEi1Agml/GUkf3l
        mJ80D55FZuLuIIoJBEHU3WNLn86VtPveCYaAy/Qr1nsJlWoSK9XJZA/qYf/LnFOflSmU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWOET-00G0cF-Ed; Thu, 08 Sep 2022 22:34:41 +0200
Date:   Thu, 8 Sep 2022 22:34:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jingyu Wang <jingyuwang_vip@163.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: Fix some coding style in ah4.c file
Message-ID: <YxpR4f4kFxsPOkZb@lunn.ch>
References: <20220908111251.70994-1-jingyuwang_vip@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908111251.70994-1-jingyuwang_vip@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 07:12:51PM +0800, Jingyu Wang wrote:
> Fix some checkpatch.pl complained about in ah4.c

Please take a look at

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

You should of put v2 in the subject, and under the --- make a comment
about what changed relative to v1.

Please also read:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

	Andrew
