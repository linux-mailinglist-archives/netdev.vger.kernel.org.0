Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5667F46DBE
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfFOCSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:18:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:18:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D55C1340D52C;
        Fri, 14 Jun 2019 19:18:42 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:18:41 -0700 (PDT)
Message-Id: <20190614.191841.882840014163054322.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] nfp: add two user friendly errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612235903.8954-1-jakub.kicinski@netronome.com>
References: <20190612235903.8954-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:18:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 12 Jun 2019 16:59:01 -0700

> This small series adds two error messages based on recent
> bug reports which turned out not to be bugs..

Series applied.
