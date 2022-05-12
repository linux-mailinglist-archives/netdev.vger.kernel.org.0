Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7900524C9A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353636AbiELMVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353627AbiELMV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:21:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A406210E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FzhW+Y1FZk1iDi0szaAes3U+QpFm1ViZzMpTZTfXIt4=; b=1v20yNIWmQ3gvY56SGEEG9QBYX
        de9hj5pnypTDMO5lDaFunmDz/0j4Jf4xWr2WRpV01N8vac72v/Ivgqo8h7aLiHF9kSryOTNqUhvqQ
        1rl0jO+0LxxY9rNJuUh/ihAqOw9URsw0JG7jJb9AwmM0JYuM1gMnBTAEsqYkUhr/YbYM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1np7ot-002Rrf-0r; Thu, 12 May 2022 14:21:27 +0200
Date:   Thu, 12 May 2022 14:21:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/14] net: txgbe: Add PHY interface support
Message-ID: <Ynz7x85dmUrk1smo@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511032659.641834-5-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -s32 txgbe_reset_hw(struct txgbe_hw *hw)
> +s32 txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg)
>  {


> +	if (1) {
> +		/* 2. Disable xpcs AN-73 */

You don't use if (1) in kernel quality code.

    Andrew
