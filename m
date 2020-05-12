Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8DD1CE96C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgELAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELAAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:00:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B3C061A0C;
        Mon, 11 May 2020 17:00:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC6AA12118540;
        Mon, 11 May 2020 17:00:49 -0700 (PDT)
Date:   Mon, 11 May 2020 17:00:49 -0700 (PDT)
Message-Id: <20200511.170049.154263930278676490.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     joe@perches.com, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] checkpatch: warn about uses of ENOTSUPP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511170807.2252749-1-kuba@kernel.org>
References: <20200511170807.2252749-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 17:00:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 11 May 2020 10:08:07 -0700

> ENOTSUPP often feels like the right error code to use, but it's
> in fact not a standard Unix error. E.g.:
> 
> $ python
>>>> import errno
>>>> errno.errorcode[errno.ENOTSUPP]
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> AttributeError: module 'errno' has no attribute 'ENOTSUPP'
> 
> There were numerous commits converting the uses back to EOPNOTSUPP
> but in some cases we are stuck with the high error code for backward
> compatibility reasons.
> 
> Let's try prevent more ENOTSUPPs from getting into the kernel.
> 
> Recent example:
> https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/
> 
> v3 (Joe):
>  - fix the "not file" condition.
> 
> v2 (Joe):
>  - add a link to recent discussion,
>  - don't match when scanning files, not patches to avoid sudden
>    influx of conversion patches.
> https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/
> 
> v1:
> https://lore.kernel.org/netdev/20200510185148.2230767-1-kuba@kernel.org/
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Joe Perches <joe@perches.com>

Applied, thanks Jakub.
