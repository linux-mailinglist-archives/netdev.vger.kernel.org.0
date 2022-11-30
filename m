Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9463CC7A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 01:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiK3AU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 19:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiK3AU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 19:20:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C16D4B9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nkB0gpWvFUi+ElvQRrbjKMhqLqqAqAWXbY7mu7xVXX8=; b=lS2cg0d/zEgUOXMJgOOo48OBZw
        I2x/Z9ID2iEeUtreFLoshiSLhxokmpnqz7038DtwR3OcFxzR/jrRjdn9/MxNB/93mntlRP5TALReA
        LsgJS1YGawCVaT3UNIFNETBnzQEL3t4XrBoInxkMnlanmebd4YnlyOTprCQDP3Wd3IVk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0AqI-003vBe-Pc; Wed, 30 Nov 2022 01:20:50 +0100
Date:   Wed, 30 Nov 2022 01:20:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 1/3] net/ethtool/ioctl: return -EOPNOTSUPP if we have
 no phy stats
Message-ID: <Y4ah4jM8HN5BV4Ed@lunn.ch>
References: <20221129103801.498149-1-d-tatianin@yandex-team.ru>
 <20221129103801.498149-2-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129103801.498149-2-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:37:59PM +0300, Daniil Tatianin wrote:
> It's not very useful to copy back an empty ethtool_stats struct and
> return 0 if we didn't actually have any stats. This also allows for
> further simplification of this function in the future commits.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
