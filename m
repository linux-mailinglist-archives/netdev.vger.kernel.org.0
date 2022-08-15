Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EAE592E4C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiHOLlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiHOLlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:41:07 -0400
X-Greylist: delayed 604 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 04:41:05 PDT
Received: from mail.flokli.de (mail.flokli.de [IPv6:2a01:4f8:1c1e:e12f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E741087
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 04:41:05 -0700 (PDT)
Date:   Mon, 15 Aug 2022 18:30:52 +0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flokli.de; s=mail;
        t=1660563055; bh=H8Z6InoKdHUzVCyOe/ov3dS6/gRYg/gr1dctVtmMoLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=FGqSTwno7hcHEYNyDTqtiaHnAgbdblu/5NBHGMnqlmS6mEGXBGfWdCvEXmAGAQqDG
         AYwKfSmSJSHmC3wWXUFT+lkqQU3CGaxX6rygjnWjr9WK3eMSIP+d9go660Y+FhDnop
         1telYYRBKdAfd/L81qmVSh4I/rBCytqA5Q7LoB4c=
From:   Florian Klink <flokli@flokli.de>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: Re: [PATCH net-next] net: wwan: iosm: Enable M.2 7360 WWAN card
 support
Message-ID: <20220815113052.2yqidrrkr7bf6plt@tp.flokli.de>
References: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
 <1c9240af-dbf4-0c11-ab25-bec5af132c24@siemens.com>
 <fb700c62-eca4-879b-1b1a-966d9232fd4d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb700c62-eca4-879b-1b1a-966d9232fd4d@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

On 22-02-10 21:46:21, Kumar, M Chetan wrote:
>On 2/10/2022 9:08 PM, Jan Kiszka wrote:
>>On 10.02.22 16:34, M Chetan Kumar wrote:
>>>This patch enables Intel M.2 7360 WWAN card support on
>>>IOSM Driver.
>>>[…]
>>
>>Hey, cool! I'll be happy to try that out soon. Any special userland
>>changes required, or will it "just work" with sufficiently recent
>>ModemManager or whatever?
>
>It need some changes at ModemManager side.

There's some people trying out this patchset in
https://github.com/xmm7360/xmm7360-pci/issues/31.

With the changes merged in, apparently the modem still reports a "SIM
not inserted" error.

https://github.com/xmm7360/xmm7360-pci/issues/31#issuecomment-1181936111
suggests it might be the "FCC lock" feature, but even then, it doesn't
seem to work.

There's now a ModemManager issue at
https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/issues/612,
which is probably the more appropriate way to discuss this, rather than
another out-of-tree kernel driver.

If you have any more insights on what's missing to get this to work in
NetworkManager/ModemManager, any comment would be appreciated.

Thanks!
Florian
