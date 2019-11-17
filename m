Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC2EFFB58
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 19:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfKQS1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 13:27:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35250 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 13:27:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 720E4153E178E;
        Sun, 17 Nov 2019 10:27:13 -0800 (PST)
Date:   Sun, 17 Nov 2019 10:27:10 -0800 (PST)
Message-Id: <20191117.102710.2088931518235560478.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-11-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <aa01a6e5-e155-af3d-5b74-77bff8d679ea@iogearbox.net>
References: <20191115221855.27728-1-daniel@iogearbox.net>
        <20191115.150906.1714221627473925259.davem@davemloft.net>
        <aa01a6e5-e155-af3d-5b74-77bff8d679ea@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 Nov 2019 10:27:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sun, 17 Nov 2019 13:25:24 +0100

> Do you have a chance to double check, seems the PR did not yet get
> pushed
> out to the net tree [0,1].

I don't know how that happened, sorry.

It should be there now :-/
