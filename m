Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6B8F382
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbfHOSeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:34:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbfHOSet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:34:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F32E013E2E21C;
        Thu, 15 Aug 2019 11:34:48 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:34:46 -0700 (PDT)
Message-Id: <20190815.113446.175049349135660993.davem@davemloft.net>
To:     anders.roxell@linaro.org
Cc:     shuah@kernel.org, netdev@vger.kernel.org, tim.bird@sony.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: net: tcp_fastopen_backup_key.sh: fix
 shellcheck issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815075826.13210-1-anders.roxell@linaro.org>
References: <20190815075826.13210-1-anders.roxell@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:34:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 15 Aug 2019 09:58:26 +0200

> When running tcp_fastopen_backup_key.sh the following issue was seen in
> a busybox environment.
> ./tcp_fastopen_backup_key.sh: line 33: [: -ne: unary operator expected
> 
> Shellcheck showed the following issue.
> $ shellcheck tools/testing/selftests/net/tcp_fastopen_backup_key.sh
> 
> In tools/testing/selftests/net/tcp_fastopen_backup_key.sh line 33:
>         if [ $val -ne 0 ]; then
>              ^-- SC2086: Double quote to prevent globbing and word splitting.
> 
> Rework to do a string comparison instead.
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Applied.
