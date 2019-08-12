Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6918A243
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfHLP2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:28:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfHLP2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:28:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BAE6615448AD7;
        Mon, 12 Aug 2019 08:28:02 -0700 (PDT)
Date:   Mon, 12 Aug 2019 08:28:02 -0700 (PDT)
Message-Id: <20190812.082802.570039169834175740.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace
 accounting for fib entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812083635.GB2428@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
        <20190811.210218.1719186095860421886.davem@davemloft.net>
        <20190812083635.GB2428@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 08:28:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 12 Aug 2019 10:36:35 +0200

> I understand it with real devices, but dummy testing device, who's
> purpose is just to test API. Why?

Because you'll break all of the wonderful testing infrastructure
people like David have created.
