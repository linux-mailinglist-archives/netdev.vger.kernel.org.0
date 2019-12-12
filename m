Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E017C11D716
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbfLLTez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:34:55 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45724 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730543AbfLLTez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:34:55 -0500
Received: by mail-pj1-f65.google.com with SMTP id r11so1483415pjp.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 11:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IFlryiLHUodkFUHyul9JRSETVpiYHsZY3o54mIdwFns=;
        b=FizTWvyU1A4ExbDpT2UuE4aYCU60rctg1gBJ5WR5COxthL7GosaRt/pb368fkQ+b22
         QVMeuCeehi1v7G9Unrekbp7x5SiaZ/OtXQz9f5Xznvj4Rntb3UR3ca5leZ5LYBtJRKx2
         x612miCMaPY5Sv/asIc2gkKqfcGBxqETTxVWP0ZIFnkfmOVcUFfW3GFdYuCzaiNPiUQp
         JSG2MdKiSkmTGiNsT34dxA4fuk/ygNxj+SZxJfwIO2KhT5Ms1fTqPrQqnUf20764qcZC
         5+s/wsVW23J/fLWInGM+jKaKU8E5+g+Wyu/mDw10wTueRwCD+g1G8NTRURscJIHDhq3l
         NPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IFlryiLHUodkFUHyul9JRSETVpiYHsZY3o54mIdwFns=;
        b=s0DZ7bcTNrk+M+mJwBHppN83NZTAVZVPNXq6BSBaZhsRYHWM8wki/u43aJIJ/gDO0g
         HR+5cWMuXr3mkrSFdx3F5uDRq3WqfHaiIKx6piVtqtqhsNnaZnAmAeZhPC4LV97puhSd
         oKWDczRYOMnjlho0pVEuKgIxB5Pd92qZ9Y3GlTtsIp4agvUpgEBg4V6rLidqFBi2C5dp
         gy7dt1FwyuMHg1R3MTeawpb8f+owaUiN5YLkOllA5uD+clF0gSDBoAcsEfJPHMK4mfcV
         IqjuLuBXi3s5FhPS5cdZBUsWZ8nps7HHi3nn2mCFucngF22mjHix10UzbZi/vqt5WAj/
         oEWw==
X-Gm-Message-State: APjAAAWCN1HBTNAuqlc730b3D5ejGoxIYlGNXWAFNRv7Dkd72az6K029
        Dyk48MDFpgAGjJVPnbo6KQZ2acXSAI5t8FLVLeoF7g==
X-Google-Smtp-Source: APXvYqxDpjUCjUlCSd9D5HpG6l7mTCkwfCtR7gUjYNbmchtdSnj5MHHiXYtrS4dEMdidCEtwEUrq9Fm+jAazbPtXwiU=
X-Received: by 2002:a17:902:8ec8:: with SMTP id x8mr10932263plo.119.1576179293980;
 Thu, 12 Dec 2019 11:34:53 -0800 (PST)
MIME-Version: 1.0
References: <20191211192252.35024-1-natechancellor@gmail.com>
In-Reply-To: <20191211192252.35024-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 12 Dec 2019 11:34:42 -0800
Message-ID: <CAKwvOdmQp+Rjgh49kbTp1ocLCjv4SUACEO4+tX5vz4stX-pPpg@mail.gmail.com>
Subject: Re: [PATCH] ath11k: Remove unnecessary enum scan_priority
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:23 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> drivers/net/wireless/ath/ath11k/wmi.c:1827:23: warning: implicit
> conversion from enumeration type 'enum wmi_scan_priority' to different
> enumeration type 'enum scan_priority' [-Wenum-conversion]
>         arg->scan_priority = WMI_SCAN_PRIORITY_LOW;
>                            ~ ^~~~~~~~~~~~~~~~~~~~~
> 1 warning generated.
>
> wmi_scan_priority and scan_priority have the same values but the wmi one
> has WMI prefixed to the names. Since that enum is already being used,
> get rid of scan_priority and switch its one use to wmi_scan_priority to
> fix this warning.
>
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Link: https://github.com/ClangBuiltLinux/linux/issues/808
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Further, it looks like the member `scan_priority` in `struct
wmi_start_scan_arg` and `struct wmi_start_scan_cmd` should probably
use `enum wmi_scan_priority`, rather than `u32`.  Also, I don't know
if the more concisely named enum is preferable?  Either way, thanks
for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/ath/ath11k/wmi.h | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
> index 4a518d406bc5..756101656391 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.h
> +++ b/drivers/net/wireless/ath/ath11k/wmi.h
> @@ -2896,15 +2896,6 @@ struct wmi_bcn_offload_ctrl_cmd {
>         u32 bcn_ctrl_op;
>  } __packed;
>
> -enum scan_priority {
> -       SCAN_PRIORITY_VERY_LOW,
> -       SCAN_PRIORITY_LOW,
> -       SCAN_PRIORITY_MEDIUM,
> -       SCAN_PRIORITY_HIGH,
> -       SCAN_PRIORITY_VERY_HIGH,
> -       SCAN_PRIORITY_COUNT,
> -};
> -
>  enum scan_dwelltime_adaptive_mode {
>         SCAN_DWELL_MODE_DEFAULT = 0,
>         SCAN_DWELL_MODE_CONSERVATIVE = 1,
> @@ -3056,7 +3047,7 @@ struct scan_req_params {
>         u32 scan_req_id;
>         u32 vdev_id;
>         u32 pdev_id;
> -       enum scan_priority scan_priority;
> +       enum wmi_scan_priority scan_priority;
>         union {
>                 struct {
>                         u32 scan_ev_started:1,
> --
> 2.24.0
>
> --

-- 
Thanks,
~Nick Desaulniers
