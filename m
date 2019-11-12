Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3A2F9AA4
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKLU2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:28:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfKLU2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:28:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 703E7154D4C9B;
        Tue, 12 Nov 2019 12:28:48 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:28:47 -0800 (PST)
Message-Id: <20191112.122847.1174111917347660159.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        bst@pengutronix.de, ecathinds@gmail.com,
        dev.kurt@vandijck-laurijssen.be, maxime.jayat@mobile-devices.fr,
        robin@protonic.nl, ore@pengutronix.de, david@protonic.nl
Subject: Re: pull-request: can-next 2019-10-07,pull-request: can-next
 2019-10-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0d53fe03-50a4-8a96-5605-7f20bd3c17fa@pengutronix.de>
References: <0d53fe03-50a4-8a96-5605-7f20bd3c17fa@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:28:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 12 Nov 2019 16:57:50 +0100

> this is a pull request for net-next/master consisting of 32 patches.

Pulled, thanks Marc.

Your pull request had two Subject: lines, please fix that.
