Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3416662B75
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGHWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:30:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfGHWar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:30:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 429AD12D69F7C;
        Mon,  8 Jul 2019 15:30:46 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:30:45 -0700 (PDT)
Message-Id: <20190708.153045.962075559598375223.davem@davemloft.net>
To:     b.spranger@linutronix.de
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        bigeasy@linutronix.de, kurt@linutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v3 0/2] Document the configuration of b53
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705095719.24095-1-b.spranger@linutronix.de>
References: <20190705095719.24095-1-b.spranger@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:30:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benedikt Spranger <b.spranger@linutronix.de>
Date: Fri,  5 Jul 2019 11:57:17 +0200

> this is the third round to document the configuration of a b53 supported
> switch.

Series applied.

There was some trailing whitespace which I took care of for you this
time.

Thanks.
