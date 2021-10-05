Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF1422AE1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhJEOWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:22:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22175 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235356AbhJEOW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:22:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633443638; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=iXaHQCDcTat4B7XjXBM6ERGc8OaY+eIv7u8gl6/j0qg=; b=gTZFpQbN1GihyrgRYpCzbcJFJ2N3XYD1JYGgBqApliAOOC4zPWcxUZUDkuqQ91W69PLSODUD
 Q1ByXG2XOnkSz7VXgWqeNQVJAnYzqsjIIXS/HwU9D11JilJKZRux5mRD8I5tH11X52G5giBZ
 TlwpuUdjTnlCCT1NSrXLU6WZe8E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 615c5f2aff0285fb0ab466d9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 14:20:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 087F0C4361B; Tue,  5 Oct 2021 14:20:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF3B7C4338F;
        Tue,  5 Oct 2021 14:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EF3B7C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v8 00/24] wfx: get out from the staging area
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Date:   Tue, 05 Oct 2021 17:20:19 +0300
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Tue, 5 Oct 2021 15:53:36 +0200")
Message-ID: <871r4zft98.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Hello,
>
> I think the wfx driver is now mature enough to be accepted in the
> drivers/net/wireless directory.
>
> The firmware is now a part of the linux-firmware repository since relase
> 20210315[1]. It had taken a bit of time because I have worked with the le=
gal
> department to simplify the redistribution terms of the firmware.
>
> [1]: https://lore.kernel.org/linux-firmware/2833354.gXvVfaC4I7@pc-42/
>
>
> As requested by Kalle[2], I send one file per patch. At the end, all the
> patches (or at least the patches 3 to 24) will be squashed (therefore, I
> didn't bother to write real commit messages).
>
> [2]: https://lore.kernel.org/lkml/87ft6p2n0h.fsf@codeaurora.org/
>
> Here is a diagram of the global architecture that may help to understand
> the code:
>
>     ,------------------------------------.
>     |                mac80211            |
>     `------------------------------------'
>     ,------------+-----------+-----------.
>     |    sta     |           |           |
>     |    scan    |           |           |
>     |    main    |           |           |
>     +------------+  data_tx  |           |
>     |    key     |           |  data_rx  |
>     | hif_tx_mib |   queue   |           |
>     |   hif_tx   |           |           |
>     |   hif_rx   |           |           |
>     |  hif_api_* |           |           |
>     +------------+-----------+-----------+--------.
>     |                  bh                |  fwio  |
>     +------------------------------------+--------+
>     |                     hwio                    |
>     +---------------------------------------------+
>     |                   bus_sdio                  |
>     |                   bus_spi                   |
>     `---------------------------------------------'
>     ,---------------------------------------------.
>     |                  spi / sdio                 |
>     `---------------------------------------------'
>
> Roughly, I have sent the files from the bottom to the top.
>
>
> v8:
>   - Change the way the DT is handled. The user can now specify the name of
>     the board (=3D chip + antenna) he use. It easier for board designers =
to
>     add new entries. I plan to send a PR to linux-firmware to include PDS
>     files of the developpement boards belong the firmware (I also plan to
>     relocate these file into wfx/ instead of silabs/). (Kalle, Pali)
>   - Prefix visible functions and structs with "wfx_". I mostly kept the
>     code under 80 columns. (Kalle, Pali, Greg)
>   - Remove support for force_ps_timeout for now. (Kalle)
>   - Fix licenses of Makefile, Kconfig and hif_api*.h. (Kalle)
>   - Do not mix and match endianess in struct hif_ind_startup. (Kalle)
>   - Remove magic values. (Kalle)
>   - Use IS_ALIGNED(). (BTW, PTR_IS_ALIGNED() does not exist?) (Kalle)
>   - I have also noticed that some headers files did not declare all the
>     struct they used.
>
>   These issues remain (I hope they are not blockers):
>   - I have currently no ideas how to improve/simplify the parsing PDS fil=
e.
>     (Kalle)
>   - We would like to relate the SDIO quirks into mmc/core/quirks.h, but t=
he
>     API to do that does not yet exist. (Ulf, Pali)

So is this a direct version from staging-next? If yes, what commit id did
you use? Or do you have your own set of patches on top of staging-next?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
