Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6C1694770
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBMNvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMNvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:51:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0EE55AD
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UMBDiNHTbKLZe4mUK1knUr5TViDm6HmvkPUEdhTq36k=; b=s1sSa5BXKC5PuHszpM2PuBq+IM
        dDnGTas5/ZY5CuVMGAMqn1Dwr9XEGl6nZ7CzaXMRmVP0d8oJIJMa5cSanXGSTMzT8CSvc9FWf/wyH
        S6YEokEbVWUORVDHavKMQLI4zuWhd+gGKOZ0ylZ5t7+VcN4wBBkF/sDVaGVSK8URaOq8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRZEi-004qMx-K6; Mon, 13 Feb 2023 14:51:16 +0100
Date:   Mon, 13 Feb 2023 14:51:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2] net: wangxun: Add base ethtool ops
Message-ID: <Y+pAVPSR4h3jSEY5@lunn.ch>
References: <20230213095959.55773-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213095959.55773-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 05:59:59PM +0800, Mengyuan Lou wrote:
> Add base ethtool ops get_drvinfo for ngbe and txgbe.

The netdev FAQ
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
says to wait at least 24 hours between new versions of patches, so
reviewers have time to review the code. Please make sure to address
the issues i pointed out in version 1 of you patch.

    Andrew
