Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A26D6612E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfGKVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:30:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfGKVaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:30:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B36014CFC090;
        Thu, 11 Jul 2019 14:30:53 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:30:52 -0700 (PDT)
Message-Id: <20190711.143052.1773408891723438773.davem@davemloft.net>
To:     joe@perches.com
Cc:     akpm@linux-foundation.org, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, andrew@aj.id.au, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-mmc@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1562734889.git.joe@perches.com>
References: <cover.1562734889.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:30:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue,  9 Jul 2019 22:04:13 -0700

> These GENMASK uses are inverted argument order and the
> actual masks produced are incorrect.  Fix them.
> 
> Add checkpatch tests to help avoid more misuses too.

Patches #7 and #8 applied to 'net', with appropriate Fixes tags
added to #8.
