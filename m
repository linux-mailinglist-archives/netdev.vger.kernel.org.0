Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F9C58E468
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 03:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiHJBTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 21:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiHJBTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 21:19:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B52F66109
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 18:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UaNHEpkgk6wNwqmudBtAcpn/Q6XoVs4mxR7wN+UJqeQ=; b=BdfOaeJcFT4vJgJkf+CFeogibj
        aRKeJehoInEmb1MmniB+oNVT9Z8TSq9BXTGQ9qIXgRYi1yeZjSbqUe0epZ5cv8AHi/qq51SP+0H6f
        3XFFDxATCuXouC7eqEX+Ezl6HoBTdg1drCxEoRO4Mlbc9xx88Cb+DAqXzDqq6cnEiE2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLaNj-00CtOO-KX; Wed, 10 Aug 2022 03:19:35 +0200
Date:   Wed, 10 Aug 2022 03:19:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Philipp Rossak <embed3d@gmail.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com,
        philipp.rossak@formulastudent.de
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) -
 kernel 5.19
Message-ID: <YvMHp0K65a/L0pa4@lunn.ch>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 12:55:58AM +0200, Philipp Rossak wrote:
> Hi,
> 
> I currently have a project with a Toradex Colibri IMX8X SOM board whith an
> onboard Micrel KSZ8041NL Ethernet PHY.
> 
> The hardware is described in the devictree properly so I expected that the
> onboard Ethernet with the phy is working.
> 
> Currently I'm not able to get the link up.
> 
> I already compared it to the BSP kernel, but I didn't found anything
> helpful. The BSP kernel is working.
> 
> Do you know if there is something in the kernel missing and got it running?

dmesg output might be useful.

Do you have the micrel driver either built in, or in your initramfs
image?

	Andrew
