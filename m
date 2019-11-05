Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3B6F08F7
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfKEWDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:03:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfKEWDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:03:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04641150689E4;
        Tue,  5 Nov 2019 14:03:23 -0800 (PST)
Date:   Tue, 05 Nov 2019 14:03:23 -0800 (PST)
Message-Id: <20191105.140323.1324058477518607844.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] icmp: move duplicate code in helper
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 14:03:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Sat,  2 Nov 2019 01:12:02 +0100

> Remove some duplicate code by moving it in two helper functions.
> First patch adds the helpers, the second one uses it.

Series applied.
