Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109AA605C72
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJTKgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiJTKgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C035130D41;
        Thu, 20 Oct 2022 03:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3042E61A94;
        Thu, 20 Oct 2022 10:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F5BC433D6;
        Thu, 20 Oct 2022 10:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666262170;
        bh=TxJ5faWpbSfa0bETdnEE+/lmvNhhQlgn0Q1+RqtkgiY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UGhaIyUdMBPik/GWxDGCyS1WX15SOg21/WbfqPP3J5I6dnFS7sRoqaAOdy9NrbgNY
         JgzfeIBRf4gfWvYY5RNBt+6g6aT8I9jNGQso/I3dz22ChYf7y6H5St/UQ32qNP84/j
         bQ46DjtQIo9lmHG/z3uzcE4qV2O75zcf33deVedAcFN5vOQN7PuI7cHpj+iBHs3nSk
         oZKzRrQ9TaUDEB9+jsIKP4mQc41Q1V3Re6eCtr5d38mHKQBHTB0fMi5l9eaYN08qRb
         c1iSheflwdyZzCpKiDg5ftVVJViP+8D8/u+WutLuDHSK9twuhsEg2sFJcLkA7x2C3O
         qSzFSdHzaqRDA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v3] wifi: rt2x00: use explicitly signed or unsigned types
References: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
        <20221019155541.3410813-1-Jason@zx2c4.com>
        <20221020102920.GA95289@wp.pl>
Date:   Thu, 20 Oct 2022 13:36:03 +0300
In-Reply-To: <20221020102920.GA95289@wp.pl> (Stanislaw Gruszka's message of
        "Thu, 20 Oct 2022 12:29:20 +0200")
Message-ID: <87edv23hpo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislaw Gruszka <stf_xl@wp.pl> writes:

> On Wed, Oct 19, 2022 at 09:55:41AM -0600, Jason A. Donenfeld wrote:
>> On some platforms, `char` is unsigned, but this driver, for the most
>> part, assumed it was signed. In other places, it uses `char` to mean an
>> unsigned number, but only in cases when the values are small. And in
>> still other places, `char` is used as a boolean. Put an end to this
>> confusion by declaring explicit types, depending on the context.
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
>> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
>> Cc: Kalle Valo <kvalo@kernel.org>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Thanks, I'll queue this to v6.1.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
