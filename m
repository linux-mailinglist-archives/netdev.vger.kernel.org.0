Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43ADA7C746
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfGaPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:47:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39422 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfGaPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:47:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE9C0133F3B2B;
        Wed, 31 Jul 2019 08:47:26 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:47:26 -0700 (PDT)
Message-Id: <20190731.084726.1953796309631404531.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Test coverage for DSCP leftover fix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1564568595.git.petrm@mellanox.com>
References: <cover.1564568595.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:47:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Wed, 31 Jul 2019 10:30:25 +0000

> This patch set fixes some global scope pollution issues in the DSCP tests
> (in patch #1), and then proceeds (in patch #2) to add a new test for
> checking whether, after DSCP prioritization rules are removed from a port,
> DSCP rewrites consistently to zero, instead of the last removed rule still
> staying in effect.

Series applied.
