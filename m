Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB643ACF7
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbfFJC0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:26:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbfFJC0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:26:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B13214EAC228;
        Sun,  9 Jun 2019 19:26:14 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:26:11 -0700 (PDT)
Message-Id: <20190609.192611.564245872261064747.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next 0/2] SFP polling fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
References: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:26:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Fri,  7 Jun 2019 10:42:34 -0600

> This has an updated version of an earlier patch to ensure that SFP
> operations are stopped during shutdown, and another patch suggested by
> Russell King to address a potential concurrency issue with SFP state
> checks.

Series applied.
