Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1DD7E42
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbfJOR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:57:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfJOR5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:57:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 095AC1504B4A9;
        Tue, 15 Oct 2019 10:57:52 -0700 (PDT)
Date:   Tue, 15 Oct 2019 10:57:52 -0700 (PDT)
Message-Id: <20191015.105752.1912916415404798072.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH net-next] net: Update address for vrf and l3mdev in
 MAINTAINERS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191012024303.86494-1-dsahern@kernel.org>
References: <20191012024303.86494-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:57:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 11 Oct 2019 20:43:03 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> Use my kernel.org address for all entries in MAINTAINERS.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.  Acutally I applied it to 'net' as well.

Thanks.
