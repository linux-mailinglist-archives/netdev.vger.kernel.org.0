Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5C4EEDDC
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbiDANLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346178AbiDANLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:11:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83F84F9EA;
        Fri,  1 Apr 2022 06:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iy4Rz5QZFsaUrFeBI8fimRQmk8AXqHuXTCyiRPViZGU=; b=pV1Np3qG9Ae5xhgZi3/z2WeRSG
        odao5nzhMbODV/qE2tf7Vy29HsHexCzpOOAzoQfng5ZdtNNjbZILNOFj2kNg1ux9vBB9uG0j9tv7g
        aYQQEFdR1tQZj34e0nWU3QLO5j/YfPHoWl3Ujk+xtFGh89M1sUPC2nIII9LuwYlwwcog=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naH1l-00Dfrx-Ui; Fri, 01 Apr 2022 15:09:21 +0200
Date:   Fri, 1 Apr 2022 15:09:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipw2x00: use DEVICE_ATTR_*() macro
Message-ID: <Ykb5gajW19kkO15N@lunn.ch>
References: <20220401053138.17749-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401053138.17749-1-tangmeng@uniontech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 01:31:38PM +0800, Meng Tang wrote:
> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.

Hi Meng

Thanks for doing what i suggested. Looks good.

Please take a look at https://docs.kernel.org/networking/netdev-FAQ.html

There are a few process issues to work out, like the branch name in
the subject, and that the merge window is currently closed so you will
need to repost next week.

     Andrew
