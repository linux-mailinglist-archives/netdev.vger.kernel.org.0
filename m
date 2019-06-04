Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D75351EA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDVeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:34:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:34:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DDAA1500FF5A;
        Tue,  4 Jun 2019 14:34:08 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:34:07 -0700 (PDT)
Message-Id: <20190604.143407.2125129264920529668.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next 0/8] net/tls: small general improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:34:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon,  3 Jun 2019 15:16:57 -0700

> This series cleans up and improves the tls code, mostly the offload
> parts.
> 
> First a slight performance optimization - avoiding unnecessary re-
> -encryption of records in patch 1.  Next patch 2 makes the code
> more resilient by checking for errors in skb_copy_bits().  Next
> commit removes a warning which can be triggered in normal operation,
> (especially for devices explicitly making use of the fallback path).
> Next two paths change the condition checking around the call to
> tls_device_decrypted() to make it easier to extend.  Remaining
> commits are centered around reorganizing struct tls_context for
> better cache utilization.

Series applied, thanks.
