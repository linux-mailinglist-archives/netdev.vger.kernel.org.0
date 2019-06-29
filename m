Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778595AD0D
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfF2T2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:28:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfF2T2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:28:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8BFC314C79D5E;
        Sat, 29 Jun 2019 12:28:48 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:28:47 -0700 (PDT)
Message-Id: <20190629.122847.986644252948714439.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, dja@axtens.net, mahesh@bandewar.net
Subject: Re: [PATCHv2 next 3/3] blackhole_dev: add a selftest
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627194309.94291-1-maheshb@google.com>
References: <20190627194309.94291-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:28:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Thu, 27 Jun 2019 12:43:09 -0700

> +config TEST_BLACKHOLE_DEV
> +	tristate "Test BPF filter functionality"

I think the tristate string needs to be changed :-)
