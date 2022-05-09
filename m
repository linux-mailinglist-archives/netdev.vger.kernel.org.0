Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C1151FEE2
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiEIN5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbiEIN5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:57:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6C12D1C0;
        Mon,  9 May 2022 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kxxyg1HZnQSs/qeLzfqToEvB7I7JnrqLFn5Ofm/34bY=; b=mkpF3BTb9sYAwjiKkfmAKvRtRR
        ta5V+lcRSuTlh4plsa5nFCL0LXnihub+nNgTIzgxSU1xT7urt4+VNvXnAP/AnSCOLVBobQsOmhgBW
        pz/K0YRJlb4ZwMUDrFsRojpY4T2ELh3V6rI11kweNRCSvQz3J/QOhMgVeSNyqbbfrLtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no3p5-001x4a-GG; Mon, 09 May 2022 15:53:15 +0200
Date:   Mon, 9 May 2022 15:53:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Fix incorret variable type in micrel
Message-ID: <Ynkcy0VhJ/HTfqMU@lunn.ch>
References: <20220509134951.2327924-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509134951.2327924-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 09:49:51PM +0800, Wan Jiabing wrote:
> In lanphy_read_page_reg, calling __phy_read() might return a negative
> error code. Use 'int' to check the negative error code.

Hi Wan

As far as the code goes, this looks good.

Please could you add a Fixes: tag, to indicate where the problem was
introduced. Please also read the netdev FAQ, so you can correctly set
the patch subject. This should be against the net tree, since it is a
fix.

Thanks
	Andrew
