Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61B35429E4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiFHIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiFHIvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886A91F0A4F;
        Wed,  8 Jun 2022 01:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBCA615BA;
        Wed,  8 Jun 2022 08:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB481C34116;
        Wed,  8 Jun 2022 08:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654675352;
        bh=hff+p9zArgrmQROBhByJgUoot02ijHcUk2SxTMWafGU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QEoqHaABFoBzHKVseuF6OsuPJsNrsLIBzbvMYwUNMKRb0lT3LcMEVlTGmjjQB7uWE
         +BjKvnjdu9YlJposcmoqzV1yX4sjCHqN0PTUbO2OiXr/zOAyGq/XopnjoeuexBMIvb
         jjCcbZMOYr4I1mOgL8gawoWk9gX3Td1M+mNx7u56r1Osc8TeOqadQcawuiRNKSpsFx
         77O2CNerHGhNV3E6IlQr1PTb1XzV95V9xzblIm/PblIJ26fExnAWsgRozgkaNMjrf2
         ITcCjEmzZTW0te5uu4scQg7PbI++NORxEMq5JoOCyOtqwIVMsZlvmgW03LJ7Yfc9Ma
         sxxez4xy4w9jg==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     cgel.zte@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] staging: wfx: Remove redundant NULL check before release_firmware() call
References: <20220606014237.290466-1-chi.minghao@zte.com.cn>
        <5637060.DvuYhMxLoT@pc-42>
Date:   Wed, 08 Jun 2022 11:02:27 +0300
In-Reply-To: <5637060.DvuYhMxLoT@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Mon,
        06 Jun 2022 08:36:37 +0200")
Message-ID: <87leu7shv0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Monday 6 June 2022 03:42:37 CEST cgel.zte@gmail.com wrote:
>> From: Minghao Chi <chi.minghao@zte.com.cn>
>>=20
>> release_firmware() checks for NULL pointers internally so checking
>> before calling it is redundant.
>>=20
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

[...]

> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

I'll change this to Acked-by, s-o-b should be used only when you are
part of patch distribution:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when=
-to-use-acked-by-cc-and-co-developed-by

And please edit your quotes, otherwise using patchwork will be painful.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
