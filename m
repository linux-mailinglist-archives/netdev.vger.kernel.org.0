Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA67772178
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfGWV1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:27:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfGWV1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:27:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 890DB153BFAF0;
        Tue, 23 Jul 2019 14:27:39 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:27:38 -0700 (PDT)
Message-Id: <20190723.142738.638894843366352833.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 06/19] ionic: Add basic adminq support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-7-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-7-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:27:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 22 Jul 2019 14:40:10 -0700

> +struct queue {
 ...
> +struct cq {
 ...
> +struct napi_stats {
 ...
> +struct q_stats {
 ...
> +struct qcq {

Using names like these and "dev_queue" are just asking for conflicts with the
global datastructure namespace both now and in the future.

Please put ionic_ or similar as a prefix to these data structure names.

Thank you.
