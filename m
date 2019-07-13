Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8114678BD
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 08:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGMGHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 02:07:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfGMGHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 02:07:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E13414EF712C;
        Fri, 12 Jul 2019 23:07:51 -0700 (PDT)
Date:   Fri, 12 Jul 2019 23:07:48 -0700 (PDT)
Message-Id: <20190712.230748.1491964275720335140.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     netdev@vger.kernel.org, linux-ppp@vger.kernel.org,
        paulus@samba.org, linux-crypto@vger.kernel.org, tiwai@suse.de,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH net] ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190712233931.17350-1-ebiggers@kernel.org>
References: <20190712233931.17350-1-ebiggers@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 23:07:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 12 Jul 2019 16:39:31 -0700

> From: Eric Biggers <ebiggers@google.com>
> 
> Commit 0e5a610b5ca5 ("ppp: mppe: switch to RC4 library interface"),
> which was merged through the crypto tree for v5.3, changed ppp_mppe.c to
> use the new arc4_crypt() library function rather than access RC4 through
> the dynamic crypto_skcipher API.
> 
> Meanwhile commit aad1dcc4f011 ("ppp: mppe: Add softdep to arc4") was
> merged through the net tree and added a module soft-dependency on "arc4".
> 
> The latter commit no longer makes sense because the code now uses the
> "libarc4" module rather than "arc4", and also due to the direct use of
> arc4_crypt(), no module soft-dependency is required.
> 
> So revert the latter commit.
> 
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied.
