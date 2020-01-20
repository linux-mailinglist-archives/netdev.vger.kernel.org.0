Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CBB1427D8
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 11:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgATKGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 05:06:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATKGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 05:06:51 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69A29153DAC71;
        Mon, 20 Jan 2020 02:06:49 -0800 (PST)
Date:   Mon, 20 Jan 2020 11:06:47 +0100 (CET)
Message-Id: <20200120.110647.1431085662863704351.davem@davemloft.net>
To:     fthain@telegraphics.com.au
Cc:     tsbogend@alpha.franken.de, chris@zankel.net, laurent@vivier.eu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 00/19] Fixes for SONIC ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 02:06:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is a mix of cleanups and other things and definitely not bug fixes.

Please separate out the true actual bug fixes from the cleanups.

The bug fixes get submitted to 'net'

And the rest go to 'net-next'

Thank you.
