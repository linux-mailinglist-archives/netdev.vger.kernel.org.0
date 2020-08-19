Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D118824A76C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHSUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:05:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D198C061757;
        Wed, 19 Aug 2020 13:05:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2346611E45766;
        Wed, 19 Aug 2020 12:48:44 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:05:29 -0700 (PDT)
Message-Id: <20200819.130529.1551760851592543597.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     sergei.shtylyov@gmail.com, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: renesas,ether: Improve schema
 validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819124539.20239-1-geert+renesas@glider.be>
References: <20200819124539.20239-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 12:48:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Wed, 19 Aug 2020 14:45:39 +0200

>   - Remove pinctrl consumer properties, as they are handled by core
>     dt-schema,
>   - Document missing properties,
>   - Document missing PHY child node,
>   - Add "additionalProperties: false".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> v2:
>   - Add Reviewed-by.

Who will take this patch or should it go via my networking tree?

Thank you.
