Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0620EE3EC4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfJXWGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:06:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfJXWGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:06:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 062E214B73C47;
        Thu, 24 Oct 2019 15:06:43 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:06:43 -0700 (PDT)
Message-Id: <20191024.150643.616424177339719258.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH v5 0/2] mv88e6xxx: Allow config of ATU hash algorithm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024024256.GL5707@lunn.ch>
References: <20191022013436.29635-1-andrew@lunn.ch>
        <20191023.191830.347702095940587406.davem@davemloft.net>
        <20191024024256.GL5707@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:06:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 24 Oct 2019 04:42:56 +0200

> It was intended for net-next. Sorry. It could be that Viviens port
> list patches got in the middle so that these did not cleanly apply to
> net-next.

Please respin, thank you.

>> Please give me some guidance and use [PATCH net-next .. ] in the future.
> 
> I wonder if we could get checkpatch to warn about this?

I'm sure it's possible.
