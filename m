Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA75604C89
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiJSQA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiJSQAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:00:01 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A10133314
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:59:05 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 36270 invoked from network); 19 Oct 2022 10:52:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1666169540; bh=NIX+/XIDPx31JkzAurZEsilsnChQ7mhpNsrPpjBK6EU=;
          h=From:To:Cc:Subject;
          b=nvVICedQWNbxeeqOdbUBGWeTCVUfhPTLPY/8i8gqL3NtqNhOKKBZt4Zu732fir/da
           7/1rqzdlfTsc7UXV3rUjBeaLhWSxauS4Mo4YHaIhtFGov3TqB1lo0k9i+Cc3ja9gbo
           G/7TC7ZGXe6n6qUbJSvg/FlfIXMKxRKlzR+q3t5s=
Received: from 89-64-7-202.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.7.202])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <Jason@zx2c4.com>; 19 Oct 2022 10:52:20 +0200
Date:   Wed, 19 Oct 2022 10:52:19 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <20221019085219.GA81503@wp.pl>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018202734.140489-1-Jason@zx2c4.com>
X-WP-MailID: f57518a0a28b280264a1c7083b794b6e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8WMk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> On some platforms, `char` is unsigned, which makes casting -7 to char
> overflow, which in turn makes the clamping operation bogus. Instead,
> deal with an explicit `s8` type, so that the comparison is always
> signed, and return an s8 result from the function as well. Note that
> this function's result is assigned to a `short`, which is always signed.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

I prefer s8 just because is shorter name than short :-)

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>


