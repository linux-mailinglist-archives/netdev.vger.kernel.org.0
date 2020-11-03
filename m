Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11472A3F4E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgKCIvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgKCIvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:51:16 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FB9C0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 00:51:16 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c18so11872494wme.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 00:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b3+HIsWi1AedrWg7oxdBDjDdUOraxKNDgYRkOWYcZvM=;
        b=UpE98w0OTZIOKnigD2k/LgzPsqj3EKr54YY6li9RtXeauX2BiAwlAXn4Q3fNhCOfhT
         MaYu+p0Iy4LGqbk+9vSGuhldkYBKWpbyfLe9xjSjjUHqS04iZRbDD5PcQEwznzpemNIQ
         pLVuXkTGue6wf4GXhvIst28UY7iGdcoprxmQJDbymaCqbU4vGxeSW56+bOdFg6u1f/4D
         bHjp4XcGc7MUPWgVGEisytWV4H1pn9n7xmqS9SiPG6P5u+7nahPWg5IxMogT/wUroNPF
         uLUIwvk2ft0R/hkT4VXZwM1SoMRcO3VMOPhWyasm47G2uqTTe9UUUfG2QJV91XI65XbW
         v8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b3+HIsWi1AedrWg7oxdBDjDdUOraxKNDgYRkOWYcZvM=;
        b=Bx8niL5KFGrio9oHoShOPAHQ6duhDoR1Ppbg/LYEFvw04cWXSYf+ZNsWa7XMRyvmdG
         3rjPrkJETRr2+k3wLaKX2YNq2eI738zOkKZPatk2pARjdrGQSmv5GCDgpwgbneghvVoZ
         02ZpajomqTIW5fKF5bLU9/C+FntFy3klegFk49iPSHF5R1TQgfpFUMnbzHQbMzA92A6Q
         gYV2vRUhckPtU/axSpOz8ZSk6dVcXbRockXKNxvxqPZuaqgDR6iWq6Uc5AGRAihkN3EZ
         btTNcACeMlq4WC7jhT2V+O7dy8+l7EFSLOeBQ8eQhWfJXphwHpsNh73ZOY+9fwM0xFZz
         wI5Q==
X-Gm-Message-State: AOAM530GQImOaDijNK+9MWswzpYMTF0tneokR8THAHTHAirHhHsF9FM5
        r1WoGzjGxdMeRvH5yZUMf2kNgoivn716kaXm
X-Google-Smtp-Source: ABdhPJzHi2/dP9J3DrISHqG0ySKb5+SyHjcVMl5wOXbDKq8DMovF6w1qMvGebMQZO+s8ChvJk+2aBA==
X-Received: by 2002:a1c:790c:: with SMTP id l12mr2250014wme.47.1604393475162;
        Tue, 03 Nov 2020 00:51:15 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id b5sm24502928wrs.97.2020.11.03.00.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 00:51:14 -0800 (PST)
Date:   Tue, 3 Nov 2020 08:51:12 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/41] rtl8192cu: trx: Demote clear abuse of kernel-doc
 format
Message-ID: <20201103085112.GK4488@dell>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
 <20201102112410.1049272-6-lee.jones@linaro.org>
 <be7ae9a4-a9ec-8670-208b-44f9117e0f04@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be7ae9a4-a9ec-8670-208b-44f9117e0f04@lwfinger.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020, Larry Finger wrote:

> On 11/2/20 5:23 AM, Lee Jones wrote:
> > Fixes the following W=1 kernel build warning(s):
> > 
> >   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:455: warning: Function parameter or member 'txdesc' not described in '_rtl_tx_desc_checksum'
> > 
> > Cc: Ping-Ke Shih <pkshih@realtek.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> > index 1ad0cf37f60bb..87f959d5d861d 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> > @@ -448,7 +448,7 @@ static void _rtl_fill_usb_tx_desc(__le32 *txdesc)
> >   	set_tx_desc_first_seg(txdesc, 1);
> >   }
> > -/**
> > +/*
> >    *	For HW recovery information
> >    */
> >   static void _rtl_tx_desc_checksum(__le32 *txdesc)
> > 
> 
> Did you check this patch with checkpatch.pl?

Yes.

> I think you substituted one
> warning for another. The wireless-testing trees previously did not accept a
> bare "/*", which is why "/**" was present.

I don't see a problem.

$ git format-patch -n1 --stdout 8cd8b929e0458 | ./scripts/checkpatch.pl 
total: 0 errors, 0 warnings, 0 checks, 8 lines checked

"[PATCH 1/1] rtl8192cu: trx: Demote clear abuse of kernel-doc format"
  has no obvious style problems and is ready for submission.

> This particular instance should have
> /* For HW recovery information */
> as the comment.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
