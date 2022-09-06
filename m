Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7DF5AEF61
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiIFPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiIFPuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:50:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586E21DD
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F3DsM4pxSO2AsDPVuFJe30VQtaTAqyoBGp8wWOgMI50=; b=AzXWxmuXK6T2tK5GM/m52i5CZn
        ukUUChdUHljrrNET2ppBEbd6xjjIp3loKEymKZF9NIfJqUla9mi1xDohk77WDuWpRdfX5o5aA4ORo
        xeSOX++kKj5lJD47QvQmlBh7XfLvLBdrNj3DNorRxuWlE5Qeb6V9QYWLqzWtd09zFZhI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVZgI-00Fl9Q-1f; Tue, 06 Sep 2022 16:36:02 +0200
Date:   Tue, 6 Sep 2022 16:36:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 net-next] net: sparx5: fix function return type to
 match actual type
Message-ID: <Yxda0mGgvq8pUinU@lunn.ch>
References: <20220906065815.3856323-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906065815.3856323-1-casper.casan@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:58:15AM +0200, Casper Andersson wrote:
> Function returns error integer, not bool.
> 
> Does not have any impact on functionality.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
