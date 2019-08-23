Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF299B870
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 00:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390764AbfHWWMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 18:12:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390281AbfHWWMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 18:12:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C42431543C8CE;
        Fri, 23 Aug 2019 15:12:21 -0700 (PDT)
Date:   Fri, 23 Aug 2019 15:12:21 -0700 (PDT)
Message-Id: <20190823.151221.2082080792623428244.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     alexey.kodanev@oracle.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv4: mpls: fix mpls_xmit for iptunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <38b351be-b24e-cb05-7c93-74134796a9d7@gmail.com>
References: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
        <38b351be-b24e-cb05-7c93-74134796a9d7@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 15:12:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Fri, 23 Aug 2019 13:59:05 -0400

> I am traveling today and doubt I will be able to take a deep look at
> this until Monday.

I'll wait until you've had a chance to review this properly.
