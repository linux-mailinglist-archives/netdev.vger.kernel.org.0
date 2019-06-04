Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D963D35168
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDUz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:55:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDUz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:55:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B9F014FC97DF;
        Tue,  4 Jun 2019 13:55:28 -0700 (PDT)
Date:   Tue, 04 Jun 2019 13:55:25 -0700 (PDT)
Message-Id: <20190604.135525.221064103005473136.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net v2 0/2] net/tls: redo the RX resync locking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604190012.6327-1-jakub.kicinski@netronome.com>
References: <20190604190012.6327-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 13:55:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue,  4 Jun 2019 12:00:10 -0700

> Hi!
> 
> Take two of making sure we don't use a NULL netdev pointer
> for RX resync.  This time using a bit and an open coded
> wait loop.
> 
> v2:
>  - fix build warning (DaveM).

:-) Applied and queued up for -stable.
