Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAAC75C14
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 02:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGZA0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 20:26:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGZA0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 20:26:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1194512650647;
        Thu, 25 Jul 2019 17:26:08 -0700 (PDT)
Date:   Thu, 25 Jul 2019 17:26:07 -0700 (PDT)
Message-Id: <20190725.172607.810507030631025709.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        willemb@google.com, quentin.monnet@netronome.com
Subject: Re: [PATCH net] selftests/net: add missing gitignores
 (ipv6_flowlabel)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725000714.10200-1-jakub.kicinski@netronome.com>
References: <20190725000714.10200-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 17:26:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 24 Jul 2019 17:07:14 -0700

> ipv6_flowlabel and ipv6_flowlabel_mgr are missing from
> gitignore.  Quentin points out that the original
> commit 3fb321fde22d ("selftests/net: ipv6 flowlabel")
> did add ignore entries, they are just missing the "ipv6_"
> prefix.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied.
