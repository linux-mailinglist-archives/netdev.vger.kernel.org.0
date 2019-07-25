Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B675B04
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 00:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfGYW4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 18:56:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfGYW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 18:56:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 347F91264D99B;
        Thu, 25 Jul 2019 15:56:02 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:56:01 -0700 (PDT)
Message-Id: <20190725.155601.13278901756820444.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 0/2] tipc: link changeover issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724015612.2518-1-tuong.t.lien@dektech.com.au>
References: <20190724015612.2518-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 15:56:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed, 24 Jul 2019 08:56:10 +0700

> This patch series is to resolve some issues found with the current link
> changeover mechanism, it also includes an optimization for the link
> synching.

Series applied, thank you.
