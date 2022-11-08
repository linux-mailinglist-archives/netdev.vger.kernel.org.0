Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B2C621E31
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 22:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKHVDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 16:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHVDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 16:03:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5F5EFA1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 13:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=z8dEI7wcV7HmzRxbhpcJELSxkLJm2lYmI/e6fpyUZW4=; b=O9spS5uJNXJG8q4dWtef3XcK65
        dg60r6DH7UxyecNY5At1/vTKl+aluDrFy5sFYxz3Gshv6fkli857RJqsjdAKCJD5HLvseaZs2/HzP
        7wPTHqBPI/2Kwj+fj8KgeK0qFWfMUff7eXGTFEtm3HUFDJz/f+ZLkRGeUlHBMxMKAOqM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osVkS-001rHl-0J; Tue, 08 Nov 2022 22:03:08 +0100
Date:   Tue, 8 Nov 2022 22:03:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 3/5] net: txgbe: Support to setup link
Message-ID: <Y2rEC21tO2bzEg+h@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-4-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108111907.48599-4-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 07:19:05PM +0800, Mengyuan Lou wrote:
> From: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> Get link capabilities, setup MAC and PHY link, and support to enable
> or disable Tx laser.

You should probably take a look in driver/net/pcs, drivers/phy/ for
configuring low level SERDES properties, and
driver/net/phy/phylink*. You need to use these frameworks, not invent
your own.

	Andrew
