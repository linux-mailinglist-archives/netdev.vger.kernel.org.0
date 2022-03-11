Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEEB4D6890
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbiCKSlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiCKSli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:41:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5C75C649
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=csrRl/oZWXAWrSgXxOu/PFaszxEIsQ0ZFJwOAseXfAM=; b=gJYOdWIJeySAEQkzyy0m58sTnT
        yZXW6WUX12yqtw1dRzM/hbCVHmaSHWerZAcWYHS9E6MQVa5+GEhVgN7eZYh2cxoADp312wxUWT/qa
        8ePiEtopqRBf6DvDnirUCjcjuxLaiyOQrGOA593j+pM4do3LRDqWk581Ela3JF/+JDBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nSkBj-00AMhs-D1; Fri, 11 Mar 2022 19:40:31 +0100
Date:   Fri, 11 Mar 2022 19:40:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH] net: phy: marvell: Fix invalid comparison in
 marvell_{suspend,resume}()
Message-ID: <YiuXnx2C1tMzSZ+G@lunn.ch>
References: <20220311155542.1191854-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311155542.1191854-1-kurt@x64architecture.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 10:55:42AM -0500, Kurt Cancemi wrote:
> This bug resulted in not resuming and suspending both the fiber and copper
> modes. Only the current mode would be suspended.
> 
> Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>

Hi Kurt

Please take a look at the netdev FAQ. You should put the tree where
this should be merged into in the subject line.

Since this is a fix, you should also include a Fixes: tag indicating
where the bug was introduces. That helps with backporting.

Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
