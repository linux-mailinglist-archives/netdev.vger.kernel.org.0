Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2EE2992
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406634AbfJXEdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:33:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfJXEdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:33:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DDA514B7ED45;
        Wed, 23 Oct 2019 21:33:39 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:33:39 -0700 (PDT)
Message-Id: <20191023.213339.209906621274098778.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024024935.GM5707@lunn.ch>
References: <20191022011817.29183-1-andrew@lunn.ch>
        <20191023.191320.2221170454789484606.davem@davemloft.net>
        <20191024024935.GM5707@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 21:33:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 24 Oct 2019 04:49:35 +0200

> I tried to avoid that, but a lot of drivers are not reverse christmas
> to start with. In which case i tried to not break it any more. But i
> can review my changes.

Please give it a shot, thank you.

I guess I can live with the cases that don't cheeck for errors now
remaining that way.
