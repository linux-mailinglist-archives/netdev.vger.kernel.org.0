Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFC2645080
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLGAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLGAkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:40:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B196E61;
        Tue,  6 Dec 2022 16:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=90ljQcvzQMVOckbg5r7iaHufSjKP7tYrNhZkvX0+lUo=; b=qX6kNr8etchUhsUaeaIXwDtFcI
        edXYpstIIZ9cxFMW6bj8wN+sA4UZv7AX3M5aW5+u9c74Cd0nWZ8WFFBR9g4ENtGs3K/yWaAp+mAxT
        nkNGDCNt+Fnr6iEVM06wYK9Od6Vnn0v3WD7QhMZKsmIVvMHBnfBf2lP+Q1KCgtj/WOhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2iTe-004aWD-Qc; Wed, 07 Dec 2022 01:39:58 +0100
Date:   Wed, 7 Dec 2022 01:39:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: driver reviewer rotation
Message-ID: <Y4/g3hj/JO+2kf2H@lunn.ch>
References: <20221206110207.303de16f@kernel.org>
 <CAA93jw6DYKvc4Mk64bap3FiBWXMvRBKB2hMupxnq_S8SxJNu7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA93jw6DYKvc4Mk64bap3FiBWXMvRBKB2hMupxnq_S8SxJNu7g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My principal thing on the ethernet front has been merely to try and
> ensure subsystems like BQL are in new ethernet drivers. If there was
> an AI other than me that could get "triggered" on that front that
> would be great. BQL itself is showing its age, tho...

Feel free to review very specific parts of a new driver. You don't
need to review it all.

I would say in general, the parts of a driver actually moving frames
around is under reviewed. So if anybody does have an interest in that,
i'm sure reviews for just that would be welcome.

    Andrew
