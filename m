Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CF16BC7C4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCPHxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCPHxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:53:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D0EEB48;
        Thu, 16 Mar 2023 00:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=JwnXjalenYgwzyY4GkAtgH6oCJhNYPp0tAoIKqsKcQA=;
        t=1678953197; x=1680162797; b=nIIPdX+1QXHHJxTsi2ACWnuJZPEOr+rcwuim2uBPzJ326pw
        PrUKQ2uiibm8EhE3rAcrTqG4RXLoPE9MfTGUFF5EJwXZIE6NG3o8tcddRw9BdDlaAkC5wcp1fT4sB
        HFFmgdnMS8VqIFP8IrjkpzZxHnCy0SYMw+2VuD6oM/Bz28ML0JD/ugASKHifylGLkO/IBm7asZFzA
        l2Og0KkPqUqyFz5CVFtbZIBnWhAjq7L4hAQj8+mgNd43fEzPjQdyEwAs5er+hWfQUgYozPFOnMT1o
        tPEByDxWyFDIVUWPJq66zc1CUrQYM+Das9MOLddVSwgBJjzucHtqAYSJq2vF8b2g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pciPr-0053EN-23;
        Thu, 16 Mar 2023 08:52:52 +0100
Message-ID: <b9a4671bef0ad931a79c2911986286f1d9bb3ae9.camel@sipsolutions.net>
Subject: Re: [PATCH next] wifi: iwlwifi: Avoid disabling GCC specific flag
 with clang
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com
Cc:     kvalo@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Date:   Thu, 16 Mar 2023 08:52:50 +0100
In-Reply-To: <20230315-iwlwifi-fix-pragma-v1-1-ad23f92c4739@kernel.org>
References: <20230315-iwlwifi-fix-pragma-v1-1-ad23f92c4739@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-15 at 20:28 -0700, Nathan Chancellor wrote:
> Clang errors:
>=20
>   drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c:15:32: error: unknown=
 warning group '-Wsuggest-attribute=3Dformat', ignored [-Werror,-Wunknown-w=
arning-option]
>   #pragma GCC diagnostic ignored "-Wsuggest-attribute=3Dformat"
>                                  ^
>   1 error generated.

Oops.

> The warning being disabled by this pragma is GCC specific. Guard its use
> with CONFIG_CC_IS_GCC so that it is not used with clang to clear up the
> error.
>=20

Thanks.

johannes
