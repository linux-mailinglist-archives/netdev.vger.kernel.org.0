Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0085C288
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfGASCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:02:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGASCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:02:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04CF714C24B50;
        Mon,  1 Jul 2019 11:02:33 -0700 (PDT)
Date:   Mon, 01 Jul 2019 11:02:33 -0700 (PDT)
Message-Id: <20190701.110233.1212603438736048972.davem@davemloft.net>
To:     danieltimlee@gmail.com
Cc:     brouer@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] samples: pktgen: add some helper functions for
 port parsing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190629133358.8251-1-danieltimlee@gmail.com>
References: <20190629133358.8251-1-danieltimlee@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 11:02:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>
Date: Sat, 29 Jun 2019 22:33:57 +0900

> This commit adds port parsing and port validate helper function to parse
> single or range of port(s) from a given string. (e.g. 1234, 443-444)
> 
> Helpers will be used in prior to set target port(s) in samples/pktgen.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied.
