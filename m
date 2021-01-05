Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556A72EB614
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbhAEXU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbhAEXU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:20:59 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45472C061574;
        Tue,  5 Jan 2021 15:20:19 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4F0E14CE685B6;
        Tue,  5 Jan 2021 15:20:18 -0800 (PST)
Date:   Tue, 05 Jan 2021 15:20:13 -0800 (PST)
Message-Id: <20210105.152013.235710636729472240.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com, kuba@kernel.org,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RESEND net-next 0/4] enetc: code cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201228130034.21577-1-michael@walle.cc>
References: <20201228130034.21577-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 15:20:18 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Mon, 28 Dec 2020 14:00:30 +0100

> This are some code cleanups in the MDIO part of the enetc. They are
> intended to make the code more readable.

Series applied, thank you.
