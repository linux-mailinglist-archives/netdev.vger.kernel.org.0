Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5376E26DD1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbfEVTon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:44:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732458AbfEVT2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:28:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DD611500C571;
        Wed, 22 May 2019 12:28:06 -0700 (PDT)
Date:   Wed, 22 May 2019 12:28:05 -0700 (PDT)
Message-Id: <20190522.122805.1501991128965297285.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com
Subject: Re: [PATCH net 0/3] net/tls: fix device surprise removal with
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522020202.4792-1-jakub.kicinski@netronome.com>
References: <20190522020202.4792-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 12:28:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 21 May 2019 19:01:59 -0700

> This series fixes two issues with device surprise removal.
> First we need to take a read lock around resync, otherwise
> netdev notifier handler may clear the structures from under
> our feet.
> 
> Secondly we need to be careful about the interpretation
> of device features.  Offload has to be properly cleaned
> up even if the TLS device features got cleared after
> connection state was installed.

Series applied and queued up for -stable, thanks.
