Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59E2D98AC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394044AbfJPRoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:44:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389705AbfJPRoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:44:13 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5853A142387B6;
        Wed, 16 Oct 2019 10:44:12 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:44:11 -0400 (EDT)
Message-Id: <20191016.134411.315258296003464370.davem@davemloft.net>
To:     ben.dooks@codethink.co.uk
Cc:     daniel@iogearbox.net, linux-kernel@lists.codethink.co.uk,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf: add static in net/core/filter.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e3e81678-6c58-191b-3514-629f5f94def2@codethink.co.uk>
References: <e947b15d-1d70-39d9-3b28-0367a3f0f4c0@codethink.co.uk>
        <20191016131020.GE21367@pc-63.home>
        <e3e81678-6c58-191b-3514-629f5f94def2@codethink.co.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:44:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>
Date: Wed, 16 Oct 2019 14:11:52 +0100

> Hmm, your config it does, I get /none/ of these warnings.
> 
> I guess a lot of this is being built whether or not is then used.

When you are making changes like this, unless you have done a full grep
over the tree and are %100 sure it is unrefrenced you should do at
a minimum an allmodconfig build.

Otherwise by definition you are not testing the build of this change.
