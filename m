Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8738EB8882
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394386AbfITAVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:21:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33927 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391427AbfITAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:21:41 -0400
Received: by mail-qk1-f193.google.com with SMTP id q203so5476003qke.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YTp5B1qD8E9aflcOxXO4o+LEcSQkbFxZ9MJfYS1B/aY=;
        b=tAi6KJc1ByzYT5nMutazH/kLr1utqSsJFknFvHpj54XCTbUT2K4+0UOf5BbZe7lzdx
         h3t+Xz5lVwr9REvW3R7lKKS+FiULp0arjEPvn03l9VEgBxPHuSNlxieDuQgxBu6VgRpR
         2dwZy6GgWFfQlp47xAywud/3/l3MuMAOJAkl/x4VI3te+AP3LLeCvjyecJ9dsIZN3cfd
         Up9dmNYCbP+TjBSD9UU7Tnf/3yBuqHdaFVQOAb9igELNb7BKGO7rq/JDrIu+oO3oycNR
         6/+qWVkpNdO6YFupeqXgHoDnhbIHbGlKwz7OptlNrluWVc+HyGcc07VeupgsMGehnq98
         z2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YTp5B1qD8E9aflcOxXO4o+LEcSQkbFxZ9MJfYS1B/aY=;
        b=jjhWmQr/iF6UpwJN3epkWdQUgrtkmu/+vIiDVBDOS1LaQQZcV2nDXmtGroKu8tN2pW
         1GIeRb2nftEwfNFi5Mx8GxqLAzxKrB4H+rxgE4hM+Sm+OHzc/yMfuewqUJInRLJhf0FN
         Tv+71TT/U3isGQK+mwrDImcFNkM04BypvwN5ZL9r6Xqn6pgU9DUAneDCmcnF9Cy865fQ
         0o3LV4w6VQ2Bfc6DoFTO+E3xprAixXCQ+RUUb1VuCU3tDN/Gm3x+/N4qb1QOJh8Q2Kej
         D4D8gY0NITdza5Y/zt54GjJMdDtA6gmzwqupNMT3FCUIiDHUxcq1eHQOPV43cfRzGEEJ
         K2uw==
X-Gm-Message-State: APjAAAXUHUeRw+86o672eHO16bPtQgmkUgmoMhBygawkfboF8/yNS0U4
        Yaz27RE8arupo4J+dVUDT8CxIw==
X-Google-Smtp-Source: APXvYqzoVPYrXP2tRPahgitnuE7bPJdek/u+2/XsD7AKfKbgjvGvtGUxVRqbqsjBylkdRiti0acXDg==
X-Received: by 2002:a37:591:: with SMTP id 139mr590821qkf.162.1568938900968;
        Thu, 19 Sep 2019 17:21:40 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c16sm198104qkg.131.2019.09.19.17.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 17:21:40 -0700 (PDT)
Date:   Thu, 19 Sep 2019 17:21:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ionic: Remove unnecessary ternary operator in
 ionic_debugfs_add_ident
Message-ID: <20190919172136.01f0e016@cakuba.netronome.com>
In-Reply-To: <20190917232616.125261-1-natechancellor@gmail.com>
References: <20190917232616.125261-1-natechancellor@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 16:26:16 -0700, Nathan Chancellor wrote:
> clang warns:
> 
> ../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: warning:
> expression result unused [-Wunused-value]
>                             ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
>                                                          ^~~~~~~~~~~
> 1 warning generated.
> 
> The return value of debugfs_create_file does not need to be checked [1]
> and the function returns void so get rid of the ternary operator, it is
> unnecessary.
> 
> [1]: https://lore.kernel.org/linux-mm/20150815160730.GB25186@kroah.com/
> 
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Link: https://github.com/ClangBuiltLinux/linux/issues/658
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thank you!
