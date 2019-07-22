Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA54709B2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfGVT1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:27:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfGVT1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:27:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10D09147B190A;
        Mon, 22 Jul 2019 12:27:43 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:27:42 -0700 (PDT)
Message-Id: <20190722.122742.1159354440931037262.davem@davemloft.net>
To:     loganaden@gmail.com
Cc:     dave.taht@gmail.com, netdev@vger.kernel.org
Subject: Re: Request for backport of
 96125bf9985a75db00496dd2bc9249b777d2b19b
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAOp4FwSPJ8iKQYJmcm-KK0huBX6tUdae8Onz85R0ohBhX07gww@mail.gmail.com>
References: <CAOp4FwQszD4ocAx6hWud5uvzv5EtuTOpYqJ10XhR5gxkXSZvFQ@mail.gmail.com>
        <CAA93jw7raM7F6jmXGbPyekCtjdhFmobk5sKXnNqJMeE+w1Goyg@mail.gmail.com>
        <CAOp4FwSPJ8iKQYJmcm-KK0huBX6tUdae8Onz85R0ohBhX07gww@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:27:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Loganaden Velvindron <loganaden@gmail.com>
Date: Mon, 22 Jul 2019 23:25:49 +0400

> ping davem

I really don't want to send it to -stable, sorry...
