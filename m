Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4484A2DF5D2
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 16:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgLTPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 10:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbgLTPSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 10:18:39 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F37C0613CF;
        Sun, 20 Dec 2020 07:17:57 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id s26so17612710lfc.8;
        Sun, 20 Dec 2020 07:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7e0LepHwj7nYia6u6S4PeKtDYxxlSlm1C6EG28R9AXI=;
        b=OLW1s/WNHCx7Jx2XhDZBCLncjTN1M868BCUTETZYtEmbOGMV4GQka4yNY824UAjZxZ
         eXG5B5Fdq9BZJze9x99gUBnftrIH41nRCcDK3QPfY9becL9rnXjGp6oz/n23zou8PuQF
         LPOl32382BayvGLvzMQ+DKkYxLcPIpOz/slNU3Qeczaar2j6yJTRcCgNd6bIcpIWsG0F
         /7XTk6uhpY9vnSuQ34L3HjJ3vD/J2rvCoynJpYNVWG/yiJOfMfBTvCCMiaEy9eaC58Kv
         kfk2aTp1irQUdHHbr9MMq0dTiIEqWuE+20cRYEyRFDRQF0gZIFfTziAvBeOnnRBLBF47
         Zn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7e0LepHwj7nYia6u6S4PeKtDYxxlSlm1C6EG28R9AXI=;
        b=edu62oy1laEw5VZWDjgykaMZiyJM+BZeBV1vFv43f4gFI6tYsuLTp2WH00ovhuk6L9
         o1ACIOKfAjTpQY3Ckpf4Ngp4EdXIzYgMWXu9FaBXTQp7EeGmKj2rXtLtPFfw6Z818QF1
         8mBGdMvxI+GxJEHtgNfAgfvSiq3poi8B0Cy1relcIB6vY3T0po6zJAlefVRFa+l8qoGL
         x63C1VG3aG+vahfW0V0r7nEjWDkKHjL0yzBGg4ZXJndSrhiRxqet5eHYKBJhJ9vXTSAi
         q3v0fZNumSApI07UscmuxEg27HEMDxltYrgjxXPFLhTBTd/TA8MmkrAk4/2MeCBd8qcY
         8DJQ==
X-Gm-Message-State: AOAM5334tWSkP8+bDSjRlncMAVH6Xe3fZp0mlMK65XbGuQ5/ujZ3bRbp
        3QD0imcPlgE91CnfDE06c94=
X-Google-Smtp-Source: ABdhPJzs/+UvvfyXtHrDzeDFzBhxrpL4ml36osp+ANrMPr9W9VC0WNqRSW71t3rTQvu5DnFSdadFVg==
X-Received: by 2002:a19:58f:: with SMTP id 137mr5103258lff.0.1608477475198;
        Sun, 20 Dec 2020 07:17:55 -0800 (PST)
Received: from kari-VirtualBox (87-95-193-210.bb.dnainternet.fi. [87.95.193.210])
        by smtp.gmail.com with ESMTPSA id u10sm1676173lfm.156.2020.12.20.07.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 07:17:54 -0800 (PST)
Date:   Sun, 20 Dec 2020 17:17:52 +0200
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Daniel West <daniel.west.dev@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Daniel West <daniel.s.west.dev@gmail.com>
Subject: Re: [PATCH] staging: qlge: Removed duplicate word in comment.
Message-ID: <20201220151752.xadu24n57nocsfeg@kari-VirtualBox>
References: <20201219014829.362810-1-daniel.west.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219014829.362810-1-daniel.west.dev@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 05:48:29PM -0800, Daniel West wrote:
> This patch fixes the checkpatch warning:
> 
> WARNING: Possible repeated word: 'and'
> 
> Signed-off-by: Daniel West <daniel.s.west.dev@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index e6b7baa12cd6..22167eca7c50 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3186,7 +3186,7 @@ static void ql_enable_msix(struct ql_adapter *qdev)
>  		     "Running with legacy interrupts.\n");
>  }
>  
> -/* Each vector services 1 RSS ring and and 1 or more
> +/* Each vector services 1 RSS ring and 1 or more
>   * TX completion rings.  This function loops through
>   * the TX completion rings and assigns the vector that
>   * will service it.  An example would be if there are

Patch it self looks good. I nit pick a little bit because this is
staging and were here to learn mostly. You should use imperative mood
in subject line. So Removed -> Remove. Also no period in subject line.

I'm also confused by your email. Other patch which you send has sign of
is with daniel.s.west.dev and another is daniel.west.dev. So do you use
both? I also think that you made this email becouse you want to get all 
lkml mails. That is perfectly fine and many does this. But many does it
just for reading. That way if someone needs to send you email it wont be
lost because  you do not read that email anymore. Many does that they
still send  messages from they real email so that email do get so many
emails. This is ofcourse your decission I'm just telling you options.

--
Kari Argillander
