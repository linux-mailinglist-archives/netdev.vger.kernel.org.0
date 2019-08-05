Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7BC8271B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfHEVpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:45:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEVpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:45:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C2A41543B3EA;
        Mon,  5 Aug 2019 14:45:10 -0700 (PDT)
Date:   Mon, 05 Aug 2019 14:45:09 -0700 (PDT)
Message-Id: <20190805.144509.1987672257878718335.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-08-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190802120038.18154-1-mkl@pengutronix.de>
References: <20190802120038.18154-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 14:45:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri,  2 Aug 2019 14:00:34 +0200

> this is a pull request of 4 patches for net/master.
> 
> The first two patches are by Wang Xiayang, they force that the string buffer
> during a dev_info() is properly NULL terminated.
> 
> The last two patches are by Tomas Bortoli and fix both a potential info leak of
> kernel memory to USB devices.

Pulled, thanks Marc.
