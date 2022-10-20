Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB87605C49
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiJTK3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJTK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:29:31 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42512116A
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:29:23 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 7365 invoked from network); 20 Oct 2022 12:29:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1666261761; bh=QP5lyw9wMaG0rx9I3puF3cDmA4+/kDxY9RqpTzTK17w=;
          h=From:To:Cc:Subject;
          b=l+EqhWtshcWHJJWaA0cP8FrgbWHj8Jir/v/Fi7AoIZ5tqgHuoMqKPMBf7VAEmc+Dd
           nrNzbJkzavN6zn51gnJk88oGLcMAO+kLnRI0fs08t89EuPgj9ggS7nl8KbsXi2n72Q
           DfkavDJu4FmOj6+5+nrJUoEXtA1i6I171rUPNPm0=
Received: from 89-64-7-202.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.7.202])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <Jason@zx2c4.com>; 20 Oct 2022 12:29:20 +0200
Date:   Thu, 20 Oct 2022 12:29:20 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH v3] wifi: rt2x00: use explicitly signed or unsigned types
Message-ID: <20221020102920.GA95289@wp.pl>
References: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
 <20221019155541.3410813-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019155541.3410813-1-Jason@zx2c4.com>
X-WP-MailID: 346509f71554380dbf7e61fed8b55964
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sQN0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 09:55:41AM -0600, Jason A. Donenfeld wrote:
> On some platforms, `char` is unsigned, but this driver, for the most
> part, assumed it was signed. In other places, it uses `char` to mean an
> unsigned number, but only in cases when the values are small. And in
> still other places, `char` is used as a boolean. Put an end to this
> confusion by declaring explicit types, depending on the context.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
