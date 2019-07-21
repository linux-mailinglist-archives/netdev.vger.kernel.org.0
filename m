Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35586F4BD
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGUSoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:44:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfGUSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:44:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95DC615258BCA;
        Sun, 21 Jul 2019 11:44:00 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:44:00 -0700 (PDT)
Message-Id: <20190721.114400.1362591908782044731.davem@davemloft.net>
To:     jeremy@azazel.net
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net] kbuild: add net/netfilter/nf_tables_offload.h to
 header-test blacklist.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721113105.19301-1-jeremy@azazel.net>
References: <20190719100743.2ea14575@cakuba.netronome.com>
        <20190721113105.19301-1-jeremy@azazel.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:44:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 21 Jul 2019 12:31:05 +0100

> net/netfilter/nf_tables_offload.h includes net/netfilter/nf_tables.h
> which is itself on the blacklist.
> 
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Applied.
