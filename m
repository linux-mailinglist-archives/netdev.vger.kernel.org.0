Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AAA195BB
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEIXh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:37:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIXh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:37:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9EA714DE9A73;
        Thu,  9 May 2019 16:37:57 -0700 (PDT)
Date:   Thu, 09 May 2019 16:37:57 -0700 (PDT)
Message-Id: <20190509.163757.1368663152874971214.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net 0/2] net/tls: fix W=1 build warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509231407.25685-1-jakub.kicinski@netronome.com>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 16:37:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  9 May 2019 16:14:05 -0700

> This small series cleans up two outstanding W=1 build
> warnings in tls code.  Both are set but not used variables.
> The first case looks fairly straightforward.  In the second
> I think it's better to propagate the error code, even if
> not doing some does not lead to a crash with current code.

Series applied, thanks Jakub.

