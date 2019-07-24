Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AB74082
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbfGXU5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:57:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfGXU5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:57:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C467A15435681;
        Wed, 24 Jul 2019 13:57:31 -0700 (PDT)
Date:   Wed, 24 Jul 2019 13:57:29 -0700 (PDT)
Message-Id: <20190724.135729.1733088727967530186.davem@davemloft.net>
To:     pavel@ucw.cz
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4: cleanup error condition testing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724100611.GA7516@amd>
References: <20190724100611.GA7516@amd>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 13:57:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>
Date: Wed, 24 Jul 2019 12:06:11 +0200

> Cleanup testing for error condition.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

Applied.
