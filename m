Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A2A6D2331
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjCaOzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjCaOzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:55:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E407687;
        Fri, 31 Mar 2023 07:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C2F5CE2FCB;
        Fri, 31 Mar 2023 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7D9C433D2;
        Fri, 31 Mar 2023 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274468;
        bh=PxZaaHZiaq9xhJ+g2mqYC69I0zEF+qwUWU324UF3nFw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SwzHMOeaH8VpuTI/w8RQB8SzRQRSKEGTALdUit4QJ625pnaS+tncLesw4n1udmONz
         z9uuf7IIXY4qrYKj7ChDupjxHR0gRf3U/N0TbuUvkCL+LPeRvxBQI5XsXpubswHWtO
         dk5z8Tby2+vArakpPG/sRmtqPcrfm0GMxhzDe4016PzQeNVpvVKFEnO3rCsWsw8+aw
         qQAIoLEgVd30k0ATf6kJzm0iqWYHkM/FOKRNz5euJ5WAr2NDFxsY1ijWkPLN7LvUKE
         axcwmpbA3tnhTDqRbeu9AVoLwMfISgezjiV8Q3vD9l9DUsMn5bydLV0v4kh6CEoodY
         KZLod5JPmXpNA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mwifiex: remove unused evt_buf variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230329131444.1809018-1-trix@redhat.com>
References: <20230329131444.1809018-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027446281.32751.11192277533347007123.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:54:25 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> clang with W=1 reports
> drivers/net/wireless/marvell/mwifiex/11h.c:198:6: error: variable
>   'evt_buf' set but not used [-Werror,-Wunused-but-set-variable]
>         u8 *evt_buf;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

074d0a1ae1fe wifi: mwifiex: remove unused evt_buf variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230329131444.1809018-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

