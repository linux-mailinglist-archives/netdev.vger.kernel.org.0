Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0424C5D9B1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfGCAuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:50:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbfGCAug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:50:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CF7313D13248;
        Tue,  2 Jul 2019 14:13:22 -0700 (PDT)
Date:   Tue, 02 Jul 2019 14:13:21 -0700 (PDT)
Message-Id: <20190702.141321.1791579862346432573.davem@davemloft.net>
To:     ast@domdv.de
Cc:     netdev@vger.kernel.org, sd@queasysnail.net
Subject: Re: [PATCH net 0/2] macsec: fix some bugs in the receive path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <04d1ca9ff24de717746b5e21573656f6cb7069d6.camel@domdv.de>
References: <04d1ca9ff24de717746b5e21573656f6cb7069d6.camel@domdv.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 14:13:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>
Date: Sun, 30 Jun 2019 22:46:38 +0200

> This series fixes some bugs in the receive path of macsec. The first
> is a use after free when processing macsec frames with a SecTAG that
> has the TCI E bit set but the C bit clear. In the 2nd bug, the driver
> leaves an invalid checksumming state after decrypting the packet.
> 
> This is a combined effort of Sabrina Dubroca <sd@queasysnail.net> and me.

Series applied and queued up for -stable, thank you.
