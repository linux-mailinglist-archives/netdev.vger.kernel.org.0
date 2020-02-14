Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35215DB09
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgBNPfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:35:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgBNPft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:35:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4261315C4F157;
        Fri, 14 Feb 2020 07:35:49 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:35:48 -0800 (PST)
Message-Id: <20200214.073548.663034267022658721.davem@davemloft.net>
To:     per.forlin@axis.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, o.rempel@pengutronix.de
Subject: Re: [PATCH net 0/2] net: dsa: Make sure there is headroom for tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213143710.22811-1-per.forlin@axis.com>
References: <20200213143710.22811-1-per.forlin@axis.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:35:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Per Forlin <per.forlin@axis.com>
Date: Thu, 13 Feb 2020 15:37:08 +0100

> Sorry for re-posting yet another time....
> I manage to include multiple email-senders and forgot to include cover-letter.
> Let's hope everyhthing is in order this time.
> 
> Fix two tag drivers to make sure there is headroom for the tag data.

Series applied and queued up for -stable.
