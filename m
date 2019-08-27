Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DEB9DACA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 02:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfH0An1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 20:43:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfH0An1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 20:43:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DA031536B4D2;
        Mon, 26 Aug 2019 17:43:26 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:21:04 -0700 (PDT)
Message-Id: <20190826.172104.1007571386058192114.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net-next] nfp: add AMDA0058 boards to firmware list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826223041.21100-1-jakub.kicinski@netronome.com>
References: <20190826223041.21100-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 17:43:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 26 Aug 2019 15:30:41 -0700

> Add MODULE_FIRMWARE entries for AMDA0058 boards.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Applied.
