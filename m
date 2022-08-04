Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C811589EB2
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbiHDPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiHDPaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:30:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1868A3B7;
        Thu,  4 Aug 2022 08:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=HWzgi6uBWpB5rhqNaRtoiEzQti+73ocf7Ubun9+AjiQ=; b=pS
        z7K2lW0Dt1zpz7H6lCRzQQQCOgmmTp1z36PT1CD5wQlc3G56UVXANJO7L48LGWgkzUfBX0kAXlTBM
        25WrUYC1f1JvnChQf8l4aP8j+hfivOL+6sjsmCgQ4gxJkFJRxTOl5kGtVKqwLgBWDANNUy+rbdNfI
        J8ILrgdK9QZorBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJcnO-00CRC6-Fq; Thu, 04 Aug 2022 17:29:58 +0200
Date:   Thu, 4 Aug 2022 17:29:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Message-ID: <Yuvl9uKX8z0dh5YY@lunn.ch>
References: <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
 <20220803164045.3585187-2-adel.abushaev@gmail.com>
 <Yuq9PMIfmX0UsYtL@lunn.ch>
 <4a757ba1-7b8e-6012-458e-217056eaee63@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a757ba1-7b8e-6012-458e-217056eaee63@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 11:51:59AM -0700, Adel Abouchaev wrote:
> Andrew,
> 
>    Could you add more to your comment? The /proc was used similarly to kTLS.
> Netlink is better, though, unsure how ULP stats would fit in it.

How do tools like ss(1) retrieve the protocol summary statistics? Do
they still use /proc, or netlink?

     Andrew
