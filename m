Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2346242FC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiKJNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiKJNLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:11:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8CE7377E
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=c4MGnbsvKRCXaf/Kyi11r9lyyKVwcxEKBuNsHyugxXo=; b=dWPowMVML0oZfoT+5SB0g4cze4
        0pb+jiUr9ENnc60muU0xtMrlu11jdmYcr//+EfGFu6b4MQvmXs5wjeBed53LZeVH2FwTYv91WTBmI
        LeVC+nnwvDoGbgPSH9+mJzHuC/O7YYb0mI8vF8ew9A41t4w7Es+9U0ALzZ89matO5I6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7Kt-00226W-Fn; Thu, 10 Nov 2022 14:11:15 +0100
Date:   Thu, 10 Nov 2022 14:11:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo.dureghello@timesys.com>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: enable set_policy
Message-ID: <Y2z4c+iYL+RTy3AG@lunn.ch>
References: <20221110091027.998073-1-angelo.dureghello@timesys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110091027.998073-1-angelo.dureghello@timesys.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 10:10:27AM +0100, Angelo Dureghello wrote:
> Enabling set_policy capability for mv88e6321.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
