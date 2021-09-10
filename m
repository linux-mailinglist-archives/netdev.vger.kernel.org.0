Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81540703E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhIJRJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhIJRI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 13:08:56 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B02EC061574;
        Fri, 10 Sep 2021 10:07:45 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id l11so5431597lfe.1;
        Fri, 10 Sep 2021 10:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EWy58abE7wQKFwno9NTJgHwAGMTNwSj4jCgL1ep39jk=;
        b=MXe0B6Bs7bWV+hXPkKEIsRw17vUt++zY93S2ZfmvE6hCOVyIjm1I6q5mprr5sHodsg
         0+19z2pi6AHF1iruDzJOJw+bV/W3iPi8U5klm3UHq7N84dRITibT7JPm0OJjpPE1t/ou
         Fwgg/4gucn0zmHTRQ91qtQn/2fGGsajVCmvuWo4cPWX/WZSMARQfQTJiXGC8RmRuPZbV
         sly7AajWjB/xIqmJ8n70mPXKXrZsRq25kGJwNmgSapnuhhNpYajdXY1CIctCcE2Na5jU
         FX3a6owUQUTUdB0U6gvYadadUUnwBqTdoh5aQuSDQJtklfvX8weeoyI/bMX1oZVBa2PM
         m+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EWy58abE7wQKFwno9NTJgHwAGMTNwSj4jCgL1ep39jk=;
        b=muj8wJrZoHMFVpy8qMgkV2P40a0O3f9CorQ/yOcAZ2S+oIJdWY8uVrUvxDBsJbfHZ3
         lQaQRLr55aA5cTb38EiZ9pTNiYDZsK3n4e2QS2F/YZtXkahVAhwTy8rLbLSDwPndX2IZ
         XUBHf9wA+i8qEiK3P3j6WbbGBY19K78CbNPngA4Rqihsw4dYsD3j7N/0H4IAHbamJ3n0
         XMG3cNeQOHDlazs+TQ79PxAz4GzPdGTimEfw5zBVDia1uqSmvB6VP3aG+HKZRkljB+79
         jOfXCH/2SKNJlVaZjKQ+fY8D0e3EPYV/PIF+0d73WAI+2+6rXI+pqxSgyIgH9xm0ZoBM
         t8Nw==
X-Gm-Message-State: AOAM530vCuiDvs7xt2DuJWAwih4JcztRt1mRfCJerMdFLzfN4uhQKg8k
        5YlRuz8WwWuDiImUAimhoEE=
X-Google-Smtp-Source: ABdhPJxcgZIUm8EBfkLeTuXnSAKfX4Qaa+sHl2gIh5zQVgZOEOxvPB0UD2BIZBjw8SkBg9whkejIBQ==
X-Received: by 2002:a05:6512:22cc:: with SMTP id g12mr4692860lfu.456.1631293663389;
        Fri, 10 Sep 2021 10:07:43 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id z5sm653402lfu.50.2021.09.10.10.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:07:43 -0700 (PDT)
Date:   Fri, 10 Sep 2021 20:07:41 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/31]  [PATCH 00/31] staging/wfx: usual maintenance
Message-ID: <20210910170741.qzl6qwbhxdz5o2hq@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:04:33PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hi,
> 
> The following PR contains now usual maintenance for the wfx driver. I have
> more-or-less sorted the patches by importance:
>     - the first ones are fixes for a few corner-cases reported by users
>     - the patches 9 and 10 add support for CSA and TDLS
>     - then the end of the series is mostly cosmetics and nitpicking

Nicely formated patch series. Should be pretty easy to review. I just
check for fast eyes. But overall nice clean up series.

> 
> I have wait longer than I initially wanted before to send this PR. It is
> because didn't want to conflict with the PR currently in review[1] to
> relocate this driver into the main tree. However, this PR started to be
> very large and nothing seems to move on main-tree side so I decided to not
> wait longer.
> 
> Kalle, I am going to send a new version of [1] as soon as this PR will be
> accepted. I hope you will have time to review it one day :-).
> 
> [1] https://lore.kernel.org/all/20210315132501.441681-1-Jerome.Pouiller@silabs.com/
> 
> Jérôme Pouiller (31):
>   staging: wfx: use abbreviated message for "incorrect sequence"
>   staging: wfx: do not send CAB while scanning
>   staging: wfx: ignore PS when STA/AP share same channel
>   staging: wfx: wait for SCAN_CMPL after a SCAN_STOP
>   staging: wfx: avoid possible lock-up during scan
>   staging: wfx: drop unused argument from hif_scan()
>   staging: wfx: fix atomic accesses in wfx_tx_queue_empty()
>   staging: wfx: take advantage of wfx_tx_queue_empty()
>   staging: wfx: declare support for TDLS
>   staging: wfx: fix support for CSA
>   staging: wfx: relax the PDS existence constraint
>   staging: wfx: simplify API coherency check
>   staging: wfx: update with API 3.8
>   staging: wfx: uniformize counter names
>   staging: wfx: fix misleading 'rate_id' usage
>   staging: wfx: declare variables at beginning of functions
>   staging: wfx: simplify hif_join()
>   staging: wfx: reorder function for slightly better eye candy
>   staging: wfx: fix error names
>   staging: wfx: apply naming rules in hif_tx_mib.c
>   staging: wfx: remove unused definition
>   staging: wfx: remove useless debug statement
>   staging: wfx: fix space after cast operator
>   staging: wfx: remove references to WFxxx in comments
>   staging: wfx: update files descriptions
>   staging: wfx: reformat comment
>   staging: wfx: avoid c99 comments
>   staging: wfx: fix comments styles
>   staging: wfx: remove useless comments after #endif
>   staging: wfx: explain the purpose of wfx_send_pds()
>   staging: wfx: indent functions arguments
> 
>  drivers/staging/wfx/bh.c              |  33 +++----
>  drivers/staging/wfx/bh.h              |   4 +-
>  drivers/staging/wfx/bus_sdio.c        |   8 +-
>  drivers/staging/wfx/bus_spi.c         |  22 ++---
>  drivers/staging/wfx/data_rx.c         |   7 +-
>  drivers/staging/wfx/data_rx.h         |   4 +-
>  drivers/staging/wfx/data_tx.c         |  87 +++++++++--------
>  drivers/staging/wfx/data_tx.h         |   6 +-
>  drivers/staging/wfx/debug.c           |  54 ++++++-----
>  drivers/staging/wfx/debug.h           |   2 +-
>  drivers/staging/wfx/fwio.c            |  26 ++---
>  drivers/staging/wfx/fwio.h            |   2 +-
>  drivers/staging/wfx/hif_api_cmd.h     |  14 +--
>  drivers/staging/wfx/hif_api_general.h |  25 ++---
>  drivers/staging/wfx/hif_api_mib.h     |  85 ++++++++--------
>  drivers/staging/wfx/hif_rx.c          |  23 ++---
>  drivers/staging/wfx/hif_rx.h          |   3 +-
>  drivers/staging/wfx/hif_tx.c          |  61 +++++-------
>  drivers/staging/wfx/hif_tx.h          |   6 +-
>  drivers/staging/wfx/hif_tx_mib.c      |  14 +--
>  drivers/staging/wfx/hif_tx_mib.h      |   2 +-
>  drivers/staging/wfx/hwio.c            |   6 +-
>  drivers/staging/wfx/hwio.h            |  20 ++--
>  drivers/staging/wfx/key.c             |  30 +++---
>  drivers/staging/wfx/key.h             |   4 +-
>  drivers/staging/wfx/main.c            |  39 +++++---
>  drivers/staging/wfx/main.h            |   3 +-
>  drivers/staging/wfx/queue.c           |  43 ++++----
>  drivers/staging/wfx/queue.h           |   6 +-
>  drivers/staging/wfx/scan.c            |  55 +++++++----
>  drivers/staging/wfx/scan.h            |   4 +-
>  drivers/staging/wfx/sta.c             | 135 +++++++++++++++-----------
>  drivers/staging/wfx/sta.h             |   8 +-
>  drivers/staging/wfx/traces.h          |   2 +-
>  drivers/staging/wfx/wfx.h             |  14 ++-
>  35 files changed, 457 insertions(+), 400 deletions(-)
> 
> -- 
> 2.33.0
> 
