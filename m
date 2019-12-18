Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19F2125194
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfLRTMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:12:35 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44020 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRTMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:12:35 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so3370282ljm.10;
        Wed, 18 Dec 2019 11:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=imHiZexO5gB1oYoKS2la2qSlq4WlB0r7VycYXAA4s/o=;
        b=sQqbD3Mz+RZ6Z1MUd7DPSgWvdfSGAk51I/o6rzFjc+Xv632r5ibELypjtoSqTdVWDh
         GEJWdHR5XWNPbx/iHVRGBNblyhXADWI4OKYdkHjfrLPfC4+eSY1S+8QYBKq3i3Mw+s4j
         iLtrdc+r0n0ypO33q/4d4pOd0hFvhsU8VaqDMmawJ9zf0U5byvU9V7AfDwf9zbwTqvWl
         lSQUzYAbksIdxR3UZGaP4Usqs0CL3c0bf5L215ke9+1vf2vtSTWyhwAf/8ud1ScLNJLc
         XquOmAtVL4f+SB9MKreLyJMNWEij6T9Ucuvfz6K2YXwC5l/yHxh0gIp28NoS/krB+O+7
         q36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=imHiZexO5gB1oYoKS2la2qSlq4WlB0r7VycYXAA4s/o=;
        b=HS1H6FKrqgyG/6w8h3eVkNlXsS1zBZ+SWa7sjZlKJNZ7lXZPkPtQAZcwioA2+LQeQ0
         QDOFJvgkDUsRBQthDsKWLF0P1pD3G07QFfyO3P71GzdbCCDA4Xel7AZs7plMorgKJta+
         kiI+U7n6jTej+f1j35EBgiHXU4mxYBG8xVvuj3iihCjscxQayTG1JaBbHhMQkawcX3cK
         ERWyHGTM3ZdrEv+O+4oGewGyE4ewsLjemrTnvAyQB6SXk413fEZxmDvXjSJ+dubrK09+
         k15wqcXTBdM54VvQxaqR1VZephCaBkpUXhcsBwrzmRBnG1N/TuVEUIEcys06HBfeLZ0R
         04sA==
X-Gm-Message-State: APjAAAW6KwQDIG29o3/ZIsEUtydtDaWDqp4X03VQj5IpHPqs1GOzzGsQ
        MbAqcPwcR2GuyUhhiGTBpcldt7wVboI0a4bS0C8=
X-Google-Smtp-Source: APXvYqxn5bDtvU5FDUKdrFEaDxvDh2DKt212ij5keCSeXMtaOLOnCu2OROZYjJXHxP7p2tHwqXaTHgSEk0Ip9J22DII=
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr3084567ljj.26.1576696352864;
 Wed, 18 Dec 2019 11:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20191213203512.8250-1-makiftasova@gmail.com>
In-Reply-To: <20191213203512.8250-1-makiftasova@gmail.com>
From:   Roman Gilg <subdiff@gmail.com>
Date:   Wed, 18 Dec 2019 20:12:37 +0100
Message-ID: <CAJcyoyusgtw0++KsEHK-t=EFGx2v9GKv7+BSViUCaB3nyDr2Jw@mail.gmail.com>
Subject: Re: [PATCH] Revert "iwlwifi: mvm: fix scan config command size"
To:     Mehmet Akif Tasova <makiftasova@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 9:36 PM Mehmet Akif Tasova
<makiftasova@gmail.com> wrote:
>
> Since Linux 5.4.1 released, iwlwifi could not initialize Intel(R) Dual Band
> Wireless AC 9462 firmware, failing with following error in dmesg:
>
> iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD
>
> whole dmesg output of error can be found at:
> https://gist.github.com/makiftasova/354e46439338f4ab3fba0b77ad5c19ec
>
> also bug report from ArchLinux bug tracker (contains more info):
> https://bugs.archlinux.org/task/64703

Since this bug report is about the Dell XPS 13 2-in1: I tested your
revert with this device, but the issue persists at least on this
device. So these might be two different issues, one for your device
and another one for the XPS.

> Reverting commit 06eb547c4ae4 ("iwlwifi: mvm: fix scan config command
> size") seems to fix this issue  until proper solution is found.
>
> This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.
>
> Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> index a046ac9fa852..a5af8f4128b1 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
> @@ -1213,7 +1213,7 @@ static int iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
>                 cmd_size = sizeof(struct iwl_scan_config_v2);
>         else
>                 cmd_size = sizeof(struct iwl_scan_config_v1);
> -       cmd_size += num_channels;
> +       cmd_size += mvm->fw->ucode_capa.n_scan_channels;
>
>         cfg = kzalloc(cmd_size, GFP_KERNEL);
>         if (!cfg)
> --
> 2.24.1
>
