Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8F60709A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJUG6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJUG6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB6C2441A6;
        Thu, 20 Oct 2022 23:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4341DB80B3C;
        Fri, 21 Oct 2022 06:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58385C433C1;
        Fri, 21 Oct 2022 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666335486;
        bh=VHvHEITeEb1KROF6Jgb7EtxFPIB7ogg1S2oIxZcvZTw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TYe9KIVMKKWyhLE0SRafHcD9pLhiKFncocwh/rnteVgxS3Fi3qmPvU+1G6ZwUVKZ0
         RoO1ypP//Eff91b220/Vm772SXSCyBW6LUzIJmo9hYhiq8eC8wgFF63oZhFkr9kE6l
         Kb70RP6biY2mccn5wvHk9yVHJpB9GhyaYHelW0JC7xFWQrAoWMp2KLxLY00z7QB3pl
         RaicmxpsPzFAxOuJSQNYPDvV2TNk2FKsxC2fKln0ZYe5k5G5L6X4gij3bL5on0qf7p
         FoSfGtlOhA6I/UK/SmSjah/d/ibkgfzZ2s5PUI8AVChFfPFujH/M5KDYnGTWqQRZAQ
         kfHGD6Ikf41Wg==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v3] wifi: rt2x00: use explicitly signed or unsigned types
References: <20221019155541.3410813-1-Jason@zx2c4.com>
        <166633490836.19505.7036640684401652888.kvalo@kernel.org>
Date:   Fri, 21 Oct 2022 09:58:03 +0300
In-Reply-To: <166633490836.19505.7036640684401652888.kvalo@kernel.org> (Kalle
        Valo's message of "Fri, 21 Oct 2022 06:48:31 +0000 (UTC)")
Message-ID: <87r0z11x50.fsf@kernel.org>
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

Kalle Valo <kvalo@kernel.org> writes:

> "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
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
>> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
>
> Patch applied to wireless.git, thanks.
>
> 3347d22eb90b wifi: rt2x00: use explicitly signed or unsigned types

Please disregard this commit id, I used a wrong baseline so I need to
apply this again.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
