Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9766B2DC6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 20:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCITcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 14:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCITcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 14:32:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB59F34D3;
        Thu,  9 Mar 2023 11:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9a8kbXtW3WnL+ytHTH3NCo7Jsx9PY0FsP0xSOA869Os=; b=dbLqmD/NwQMrLQ6nBpIH5fUFCf
        6SOu58YSNfp1UvAAQPwRKeM8y6cj71j9vE07uRj0TJnFbNqIQJVnCQIHoTd7664u+FMZt3I4pYpFf
        cPeGwiJcuzG3Yqd4Mo5JUCjtLUGgiSuXN7pWlihn8p4ZRgZLeDuLhCUgZm7lsBNUdu+Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paLyM-006uEx-UZ; Thu, 09 Mar 2023 20:30:42 +0100
Date:   Thu, 9 Mar 2023 20:30:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 net 2/2] net: asix: init mdiobus from one function
Message-ID: <07dd1c76-68a1-4c2f-98fe-7c25118eaff9@lunn.ch>
References: <20230308202159.2419227-1-grundler@chromium.org>
 <20230308202159.2419227-2-grundler@chromium.org>
 <ZAnBCQsv7tTBIUP1@nanopsycho>
 <CANEJEGuK-=tTBXG6FpC4aBb7KbsNZng2-Rmi0k6BJJ7An=Pyxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGuK-=tTBXG6FpC4aBb7KbsNZng2-Rmi0k6BJJ7An=Pyxw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I hope the maintainers can apply both to net-next and only apply the
> first to net branch.

Hi Grant

Please take a look at
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

Please submit the first patch to net. Then wait a week for net to be
merged into net-next, and submit the second patch to net-next.

       Andrew
