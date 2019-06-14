Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884B14637A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfFNP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:57:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfFNP5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:57:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04D36148FDEAA;
        Fri, 14 Jun 2019 08:57:16 -0700 (PDT)
Date:   Fri, 14 Jun 2019 08:57:16 -0700 (PDT)
Message-Id: <20190614.085716.1980194253965933200.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     marcelo.leitner@gmail.com, dcaratti@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        john.hurley@netronome.com, mkubecek@suse.cz,
        netdev@vger.kernel.org, paulb@mellanox.com,
        simon.horman@netronome.com, toke@redhat.com
Subject: Re: [PATCH net-next] sched: act_ctinfo: use extack error reporting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614090943.82245-1-ldir@darbyshire-bryant.me.uk>
References: <20190613200849.GH3436@localhost.localdomain>
        <20190614090943.82245-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 08:57:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Fri, 14 Jun 2019 10:09:44 +0100

> Use extack error reporting mechanism in addition to returning -EINVAL
> 
> NL_SET_ERR_* code shamelessy copy/paste/adjusted from act_pedit &
> sch_cake and used as reference as to what I should have done in the
> first place.
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Applied.
