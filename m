Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94A432133
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 01:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFAXsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 19:48:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFAXsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 19:48:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF397150FC725;
        Sat,  1 Jun 2019 16:48:38 -0700 (PDT)
Date:   Sat, 01 Jun 2019 16:48:38 -0700 (PDT)
Message-Id: <20190601.164838.1496580524715275443.davem@davemloft.net>
To:     Markus.Elfring@web.de
Cc:     johunt@akamai.com, dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ss: Checking efficient analysis for network connections
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
        <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Jun 2019 16:48:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <Markus.Elfring@web.de>
Date: Sat, 1 Jun 2019 10:36:40 +0200

> I imagine then that it would be also nicer to perform filtering based on
> configurable constraints at the data source directly.
> How much can Linux help more in this software area?
> How do you think about such ideas?

If you use netlink operations directly, you can have the kernel filter
on various criteria and only get the socket entries you are interested
in.

This whole discussion has zero to do with what text format 'ss' outputs.
