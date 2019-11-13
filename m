Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C73FB97D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfKMUMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:12:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfKMUMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:12:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 285751203B43C;
        Wed, 13 Nov 2019 12:12:52 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:12:51 -0800 (PST)
Message-Id: <20191113.121251.281951092601245932.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2019-11-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113123759.5551-1-stefan@datenfreihafen.org>
References: <20191113123759.5551-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 12:12:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Wed, 13 Nov 2019 13:37:59 +0100

> An update from ieee802154 for *net-next*
> 
> I waited until last minute to see if there are more patches coming in.
> Seems not and we will only have one change for ieee802154 this time.
> 
> Yue Haibing removed an unused variable in the cc2520 driver.
> 
> Please pull, or let me know if there are any problems.

Pulled, thanks Stefan.
