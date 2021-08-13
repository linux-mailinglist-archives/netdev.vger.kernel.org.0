Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59C83EBCAC
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhHMTpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:45:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F27FC061756;
        Fri, 13 Aug 2021 12:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vGxwLQwFO2S7TTjs1yBKTvR75GNMnpeXiG3mZABQ1io=;
        t=1628883905; x=1630093505; b=pk97yo0ziCaTXhJO1U8NwHm2jV76Y1SaMwLWw+oePwsCEI4
        /k80LWcPeO/cALwT9OL5KTQkkm9mEHdtcnFhrJaaBlfgHE8aOrb4x/ZeSluTZXL/didolW5u8Zs9Z
        bdwbalR72Mqq8K97CK7TiMbG1iz2x6MbEZ8YUiMw31HJNn7vBfxDWUXmczj94VPwWq05wTWxE6U0C
        H2v26+p/PcH1k3fe7Dev7l/mECrDmmJWH1PKMDIwkJjmVtFfs492L6GS8qdPDJFCGZA1bsGdxbnTr
        izLUxRkmVFYineHvfmu+L5HCo0cyFqAtG1sXP/U4S/EnF1TotvO9/LYFmwC/zVzw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mEd6u-00ANL4-Up; Fri, 13 Aug 2021 21:44:57 +0200
Message-ID: <6488ed24d2ce0ccb1987c271064e25bc72c30863.camel@sipsolutions.net>
Subject: Re: [PATCH 10/64] lib80211: Use struct_group() for memcpy() region
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Date:   Fri, 13 Aug 2021 21:44:55 +0200
In-Reply-To: <202108130846.EC339BCA@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-11-keescook@chromium.org>
         <a9c8ae9e05cfe2679cd8a7ef0ab20b66cf38b930.camel@sipsolutions.net>
         <202108130846.EC339BCA@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-13 at 08:49 -0700, Kees Cook wrote:
> 
> Ah! Yes, thanks for pointing this out. During earlier development I split
> the "cross-field write" changes from the "cross-field read" changes, and
> it looks like I missed moving lib80211_crypt_ccmp.c into that portion of
> the series (which I haven't posted nor finished -- it's lower priority
> than fixing the cross-field writes).

Oh, OK. I think all of this patch was cross-field read though.

Anyway, the patch itself is fine, just seems incomplete and somewhat
badly organised :)

johannes


