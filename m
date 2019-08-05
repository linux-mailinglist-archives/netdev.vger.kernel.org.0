Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B52825E9
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfHEUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:16:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:16:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B767154316E4;
        Mon,  5 Aug 2019 13:16:18 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:16:17 -0700 (PDT)
Message-Id: <20190805.131617.1371789843534121864.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Subject: Re: [PATCH net 2/2] selftests/tls: add a litmus test for the
 socket reuse through shutdown
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801213602.19634-2-jakub.kicinski@netronome.com>
References: <20190801213602.19634-1-jakub.kicinski@netronome.com>
        <20190801213602.19634-2-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:16:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  1 Aug 2019 14:36:02 -0700

> Make sure that shutdown never works, and at the same time document how
> I tested to came to the conclusion that currently reuse is not possible.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
