Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C505E21863B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgGHLfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgGHLfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:35:09 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FCBC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:35:08 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z2so26299826wrp.2
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/hafEpgse99+DA+r/Az58pAMZ7VKTM94BFXdZWlmA6E=;
        b=WEYZPUYGYmULN+137H/tCq6ky25Ym5YSH36cys6eF7p6FAFPslBBKOZXuSCQ429Txo
         qIZdRVuqLRRdMHTK3nwriF/wr5iKP0TrqJnwJ6Zn9nSea1EHZqt2cQsBWhNrPIXjoF+K
         RcqGfGj6eGi85wiVuPlJ1sttRqdQcIdNPOABBDt4wXE5SgkQFuN4EieZ43W4uR+4gkXW
         wD0K40ZLulpQuJiWOePllBkK50KpeN7zFm8udq2pa3E0dKb+B6pTnXaJpwe4b/EdqJdF
         /33m8NwsPfCHKQ1giisheKFkNp3mqm2wHKCUmXVSyQZdm+Stf6FVKl4Y+XDKESAV6W4T
         lQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/hafEpgse99+DA+r/Az58pAMZ7VKTM94BFXdZWlmA6E=;
        b=o0IIaIGPl9r3Rmsoi+RqMBYtp3MHVv9OxERPP3nQp+EBPmvUPPIPKRoHOmrMZ/rA74
         aI9UmqUfO8a/SL/81ZAVig03YxloT7iVTbN7vtO9gdv0iS6z/IUEtGqF5ksqSDct9YtB
         g1kqrIiVByhCS5yLlrH4zMfiMfxsHABNz9sFA2vf3iuYUf9k7aTvs1wlMAbRp3WlFrGA
         wNToiiZEPQsLs/CK207UARHQNvtBRinqQmyuYCAWH3wIILu5J6jx1foftdkytRELFYNn
         7rXeVIZ8paYKs9kUnE5ZEw/nTfihvj8sRiZ77VI7Uvt2fPGd4AIznHqjLg1SkueSliQ1
         uzdg==
X-Gm-Message-State: AOAM531kJPCOy6FjJz8zeQY/Q4YSqsQiGc330Xt8Tezfdag8U/9LpHgI
        dtta7pmkoQ+1ZxRULC9oHAECig==
X-Google-Smtp-Source: ABdhPJwIqgWQieB55/KrfECgWnmDzy79medLXflbQrL8RQmzSWvlpXD4nZ86XuLt+6E3qThpDGENnw==
X-Received: by 2002:adf:8462:: with SMTP id 89mr57153510wrf.420.1594208107604;
        Wed, 08 Jul 2020 04:35:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r1sm5277718wrt.73.2020.07.08.04.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:35:06 -0700 (PDT)
Date:   Wed, 8 Jul 2020 13:35:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@gmail.com,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200708113505.GA3667@nanopsycho.orion>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200705110301.20baf5c2@hermes.lan>
 <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 08, 2020 at 11:40:12AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Sun, Jul 5, 2020 at 11:33 PM Stephen Hemminger
><stephen@networkplumber.org> wrote:
>>
>> On Mon, 29 Jun 2020 13:13:04 +0530
>> Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
>>
>> > Add support for reading board serial_number to devlink info
>> > subcommand. Example:
>> >
>> > $ devlink dev info pci/0000:af:00.0 -jp
>> > {
>> >     "info": {
>> >         "pci/0000:af:00.0": {
>> >             "driver": "bnxt_en",
>> >             "serial_number": "00-10-18-FF-FE-AD-1A-00",
>> >             "board.serial_number": "433551F+172300000",
>> >             "versions": {
>> >                 "fixed": {
>> >                     "board.id": "7339763 Rev 0.",
>> >                     "asic.id": "16D7",
>> >                     "asic.rev": "1"
>> >                 },
>> >                 "running": {
>> >                     "fw": "216.1.216.0",
>> >                     "fw.psid": "0.0.0",
>> >                     "fw.mgmt": "216.1.192.0",
>> >                     "fw.mgmt.api": "1.10.1",
>> >                     "fw.ncsi": "0.0.0.0",
>> >                     "fw.roce": "216.1.16.0"
>> >                 }
>> >             }
>> >         }
>> >     }
>> > }
>>
>> Although this is valid JSON, many JSON style guides do not allow
>> for periods in property names. This is done so libraries can use
>> dot notation to reference objects.
>Okay, I will modify the name to board_serial_number and resend the
>patch. Thanks.

Does not make sense. We have plenty of other items with ".". Having one
without it does not resolve anything, only brings inconsistency. Please
have ".".


>
>>
>> Also the encoding of PCI is problematic
>>
>>
