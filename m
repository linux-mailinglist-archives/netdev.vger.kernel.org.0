Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3735A4358DE
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhJUDNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhJUDM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:12:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA78C06161C;
        Wed, 20 Oct 2021 20:10:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t11so17507046plq.11;
        Wed, 20 Oct 2021 20:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=LKUtJj0x5HNA1lDir25VXzXO+gDs3DC1h02o1eB01cc=;
        b=QzoDiFraU1a1PM00HOXBrZLVjITiJ2Jv1Q0V1vgMn5/16iiXPZuvU8IN2vbGDf0pvO
         q0LogBW/dABYTTPI3SQ5RijZpzTbvyANGstUVipoavx4YIaxpEAvVd6x/eeY+dAcJCU1
         Cicz90mRtrlJHGKXsYLvSqt1kOMrVEhYdTb+STBnmbX6rR4i2cHf8gGye8PwMew4hNBq
         KX2FvSf7yC3iaWAe+8oyIOqmen7nOML78Jy6P8K/VKmSJ1JZ7PsC2wQSfK00P3oJXhaF
         BiY4brpryRSXgIvcA6Zw+FPiwVXoRwHqjgkFngrkf2wH5jHtJjDqvJeAWWvplX15Tk0w
         exZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=LKUtJj0x5HNA1lDir25VXzXO+gDs3DC1h02o1eB01cc=;
        b=llQHv3ilggLD5JHyCV3ODJddokBVdBU8wDvoKU57wjYC6tjSPjH9w1Mh1q01O/jIV6
         1kVidQh98mzBxN5ge8LPkJm6L5TBlEdlIcmhqQ0WG02+W4PAk1LQwWE8/KSs5RdThIZQ
         TU7iK8+IzKnfcWUvM8T2zY86rlXWP8J5gm/RfOtx7kRyjRA8N5DToG4aY346fSaJ4J61
         F6V4IMxGvHnjf9KAYiztn+eIlyG1kYOXhKJSMnWkFVgkOrzl2TE0RxW14iBi66mpm9wJ
         1nkEwyRMn/XtBG9Gtg7nnR0rFXkbGjVwUcmO0g0rvSRcyrZipBF0VQRfQNdJTEWQdmTV
         YyYQ==
X-Gm-Message-State: AOAM533VUFzByMP74KCmCDsbfRm8aNWKAFaLSPsLycFIARA79hOiNaaG
        GKBcCavyvZCLw9oSoT8yMG4=
X-Google-Smtp-Source: ABdhPJw1r4kzM4NNvycTJ1Oekjgi9rZ0ViPsPoYnmwu08hWlyWjpGE1ii0KfUWYdSGYUushxmtPBjA==
X-Received: by 2002:a17:90b:3a88:: with SMTP id om8mr3454187pjb.71.1634785844137;
        Wed, 20 Oct 2021 20:10:44 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i18sm3976856pfq.198.2021.10.20.20.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:10:43 -0700 (PDT)
Message-ID: <6170da33.1c69fb81.4050d.c355@mx.google.com>
X-Google-Original-Message-ID: <20211021031041.GA1041483@cgel.zte@gmail.com>
Date:   Thu, 21 Oct 2021 03:10:41 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Pkshih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lv.ruyi@zte.com.cn" <lv.ruyi@zte.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] rtw89: fix error function parameter
References: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
 <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
 <3aa076f0e39a485ca090f8c14682b694@realtek.com>
 <878ryof1xc.fsf@codeaurora.org>
 <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 01:34:25AM +0000, Pkshih wrote:
> 
> > -----Original Message-----
> > From: kvalo=codeaurora.org@mg.codeaurora.org <kvalo=codeaurora.org@mg.codeaurora.org> On Behalf Of Kalle
> > Valo
> > Sent: Wednesday, October 20, 2021 6:04 PM
> > To: Pkshih <pkshih@realtek.com>
> > Cc: cgel.zte@gmail.com; davem@davemloft.net; kuba@kernel.org; lv.ruyi@zte.com.cn;
> > linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zeal Robot
> > <zealci@zte.com.cn>
> > Subject: Re: [PATCH] rtw89: fix error function parameter
> > 
> > Pkshih <pkshih@realtek.com> writes:
> > 
> > >> -----Original Message-----
> > >> From: kvalo=codeaurora.org@mg.codeaurora.org
> > >> <kvalo=codeaurora.org@mg.codeaurora.org> On Behalf Of Kalle
> > >> Valo
> > >> Sent: Wednesday, October 20, 2021 4:50 PM
> > >> To: cgel.zte@gmail.com
> > >> Cc: davem@davemloft.net; kuba@kernel.org; Pkshih
> > >> <pkshih@realtek.com>; lv.ruyi@zte.com.cn;
> > >> linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> > >> linux-kernel@vger.kernel.org; Zeal Robot
> > >> <zealci@zte.com.cn>
> > >> Subject: Re: [PATCH] rtw89: fix error function parameter
> > >>
> > >> cgel.zte@gmail.com wrote:
> > >>
> > >> > From: Lv Ruyi <lv.ruyi@zte.com.cn>
> > >> >
> > >> > This patch fixes the following Coccinelle warning:
> > >> > drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
> > >> > WARNING  possible condition with no effect (if == else)
> > >> >
> > >> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > >> > Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> > >> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> > >>
> > >> Failed to apply, please rebase on top of wireless-drivers-next.
> > >>
> > >> error: patch failed: drivers/net/wireless/realtek/rtw89/rtw8852a.c:753
> > >> error: drivers/net/wireless/realtek/rtw89/rtw8852a.c: patch does not apply
> > >> error: Did you hand edit your patch?
> > >> It does not apply to blobs recorded in its index.
> > >> hint: Use 'git am --show-current-patch' to see the failed patch
> > >> Applying: rtw89: fix error function parameter
> > >> Using index info to reconstruct a base tree...
> > >> Patch failed at 0001 rtw89: fix error function parameter
> > >>
> > >> Patch set to Changes Requested.
> > >>
> > >
> > > I think this is because the patch is translated into spaces instead of tabs,
> > > in this and following statements.
> > > "                if (is_2g)"
> > 
> > Ah, I did wonder why it failed as I didn't see any similar patches. We
> > have an item about this in the wiki:
> > 
> > https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues
> > 
> 
> I don't know why neither.
> 
> I check the mail header of this patch, the mailer is
> "X-Mailer: git-send-email 2.25.1". It should work properly.
> 
> Lv Ruyi, could you help to check what happens?
> 
> --
> Ping-Ke

Thanks for Ping-Ke's suggestion,you are right.The previous patch
is translated into spaces instead of tabs,and I will submitt a
new correct one.
