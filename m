Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC25B59F2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiILMHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiILMHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:07:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DD932BAD;
        Mon, 12 Sep 2022 05:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z8frw41f+UOM2n0PSa8iYjBK8hFsCgjVi+qoP5r1cD8=; b=FIC7TCcE2+/NWD6ta+5QLIv4A5
        J67MatHMWs99h8n3OcpdNXm4t3X/Dp2tB6Cuku4Tv0xVONqs9Lhv3Olcg2TyuPIF8HjayeJHh3aYH
        8ELyqqcXBaNkfPq30+WaMZF/s9476FiUd1o/4LfUyhA4vVGkAI86RzvR1mjhHJVJEFl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXiDS-00GT9Q-Qv; Mon, 12 Sep 2022 14:07:06 +0200
Date:   Mon, 12 Sep 2022 14:07:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net 1/2] Revert "fec: Restart PPS after link state change"
Message-ID: <Yx8g6vz/36glufFx@lunn.ch>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
 <20220912070143.98153-2-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912070143.98153-2-francesco.dolcini@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 09:01:42AM +0200, Francesco Dolcini wrote:
> This reverts commit f79959220fa5fbda939592bf91c7a9ea90419040, this is
> creating multiple issues, just not ready to be merged yet.
> 
> Link: https://lore.kernel.org/all/20220905180542.GA3685102@roeck-us.net/
> Link: https://lore.kernel.org/all/CAHk-=wj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5WMj8eheb3A9WHw@mail.gmail.com/
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
