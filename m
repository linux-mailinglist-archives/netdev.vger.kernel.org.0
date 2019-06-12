Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A281442C2A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437722AbfFLQ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:27:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405745AbfFLQ1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:27:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FC851513DD1E;
        Wed, 12 Jun 2019 09:27:12 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:27:11 -0700 (PDT)
Message-Id: <20190612.092711.1626983045451710048.davem@davemloft.net>
To:     po-hsu.lin@canonical.com
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/net: skip psock_tpacket test if KALLSYMS was
 not enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612064752.6701-1-po-hsu.lin@canonical.com>
References: <20190612064752.6701-1-po-hsu.lin@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:27:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Wed, 12 Jun 2019 14:47:52 +0800

> The psock_tpacket test will need to access /proc/kallsyms, this would
> require the kernel config CONFIG_KALLSYMS to be enabled first.
> 
> Check the file existence to determine if we can run this test.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Please just add CONFIG_KALLSYMS to "config".
