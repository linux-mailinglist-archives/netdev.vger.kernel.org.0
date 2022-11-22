Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F02633F52
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiKVOu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiKVOuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:50:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5752B663D2;
        Tue, 22 Nov 2022 06:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JTXHliGkwFbAvvGXxfkFbQkqDVWqZZH0nH2iHGLdV0I=; b=EkR7AvwKw7/77Gyqk9CslT4+jV
        pB50ssBJUZg5FnA9n3hQwmtXjFZ19xqpQ3pjIJkuQ4vEV5geB15AssZ4e3u/DCLkSmExSPERidtVt
        omfBId4VblVuw/07rEPHBiwutZuGiTLkfVI272K4yikc3bglh16cqZtUqobSdWPQF40Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxUai-00383o-NA; Tue, 22 Nov 2022 15:49:40 +0100
Date:   Tue, 22 Nov 2022 15:49:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v3] ethtool: avoiding integer overflow in
 ethtool_phys_id()
Message-ID: <Y3zhhLE8G2zspVvR@lunn.ch>
References: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 03:29:01PM +0300, Maxim Korotkov wrote:
> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
