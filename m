Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6F4CC73C
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfJEBgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:36:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:36:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D6B914F36388;
        Fri,  4 Oct 2019 18:36:45 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:36:45 -0700 (PDT)
Message-Id: <20191004.183645.258251595025395623.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        dsahern@gmail.com
Subject: Re: [PATCH net] selftests/net: add nettest to .gitignore
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191005003650.32246-1-jakub.kicinski@netronome.com>
References: <20191005003650.32246-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:36:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri,  4 Oct 2019 17:36:50 -0700

> nettest is missing from gitignore.
> 
> Fixes: acda655fefae ("selftests: Add nettest")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
