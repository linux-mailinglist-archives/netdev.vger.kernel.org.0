Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDC512538B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLRUhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:37:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRUhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:37:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42C76153D61EE;
        Wed, 18 Dec 2019 12:37:17 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:37:16 -0800 (PST)
Message-Id: <20191218.123716.1806707418521871245.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     ldir@darbyshire-bryant.me.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218095340.7a26e391@cakuba.netronome.com>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
        <20191218095340.7a26e391@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:37:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 18 Dec 2019 09:53:40 -0800

> On Wed, 18 Dec 2019 14:05:13 +0000, Kevin 'ldir' Darbyshire-Bryant
> wrote:
>> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
>> previous implementation of diffserv tins.  Since the variable isn't used
>> in any calculations it can be eliminated.
>> 
>> Drop variable and places where it was set.  Rename remaining variable
>> and consolidate naming of intermediate variables that set it.
>> 
>> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> 
> Checkpatch sayeth:
> 
> WARNING: Missing Signed-off-by: line by nominal patch author 'Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>'

Which is kinda rediculous wouldn't you say? :-)

The warning stops to be useful if it's going to be applied in situations
like this where merely a nickname 'ldir' is added to the middle of the
person's formal name.

I would never push back on a patch on these grounds, it just wastes time.
