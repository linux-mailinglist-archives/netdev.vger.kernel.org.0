Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A065831582
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfEaTmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:42:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfEaTme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:42:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 365C91500620C;
        Fri, 31 May 2019 12:42:34 -0700 (PDT)
Date:   Fri, 31 May 2019 12:42:33 -0700 (PDT)
Message-Id: <20190531.124233.433361004598297362.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY
 in fixed or 802.3z mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5d866394-39c0-bea9-a775-ce4a4b2fde2a@sedsystems.ca>
References: <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
        <20190531.122918.1149944019162498846.davem@davemloft.net>
        <5d866394-39c0-bea9-a775-ce4a4b2fde2a@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 12:42:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Fri, 31 May 2019 13:41:05 -0600

> On 2019-05-31 1:29 p.m., David Miller wrote:
>> 
>> So many changes to the same file that seem somehow related.
>> 
>> Therefore, why didn't you put this stuff into a formal patch series?
> 
> The phy/phydev patches I submitted should all be independent changes
> that aren't directly related or go in any particular order. (Though I
> did notice I somehow managed to make some of them be reply chained to
> others - whoops..)
> 
> They could potentially be a series though.

If they are truly independent I guess it's ok.
