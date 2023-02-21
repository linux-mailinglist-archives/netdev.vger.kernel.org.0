Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAADA69D77E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjBUA05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUA04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:26:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1741EBE3;
        Mon, 20 Feb 2023 16:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 865FE60B07;
        Tue, 21 Feb 2023 00:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192CDC433EF;
        Tue, 21 Feb 2023 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676939214;
        bh=hu7rvLmlNgm7a3RchvkDuFXTBYUf3LXo5h8oEwJoGbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B6Lmt3dMESb4cFh5ZYgWY6e8u/uBRvvFLN6L1PhrOUFKuL7h8DLjs9FVBnZxKrNc1
         zp495ma1RdN8FMUvUg0aq1B5FlRAnX3AUj2rBFHhxKsD219e/jOC2PVH7V6kPajMsq
         YYOXwZ5/Hmw+4ExrW3b/KaBAxZ61xUwIpQMkqkLYYPGu1qNUL6kZjGDYTe2wFjlr8d
         OblSEE6EGROY9IVnPkvlYTR/PWUBM76qD49dG2JfVrEns+unvwB7IMNxvS/3jFeHmN
         kuwvrbvj7k3vXjxqnlVgssHJ3onqf5Kof8ZpyPEEQYbkpVsNOcRTICJ+bJS/Ohlzjp
         yavCXiu2O83aQ==
Date:   Mon, 20 Feb 2023 16:26:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Shevchenko <andy@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/2] string: Make memscan() to take const
Message-ID: <20230220162653.0836ebfc@kernel.org>
In-Reply-To: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
References: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Feb 2023 13:42:33 +0200 Andy Shevchenko wrote:
> Make memscan() to take const so it will be easier replace
> some memchr() cases with it.

Let's do this after the merge window.
