Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A871E407034
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhIJRGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIJRGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 13:06:18 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE667C061574;
        Fri, 10 Sep 2021 10:05:06 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q21so4279434ljj.6;
        Fri, 10 Sep 2021 10:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=v2uHo0KL4tP8i7F5Ezn7qF1nuW399RUbWTYsco45lbE=;
        b=Gh0rtBaEd97D+5SpIuEt2bCTCCw4UDFXm8Ymf2Sh0tn/rWqMUvhO7CDl/W/kgHOv11
         rFotXtDOuMes+OhBWneyrv9LgUwGFNOQOFXqEN/9i/oBiyOGyM6j49ugH4Jxe6KmiUBi
         X7naAqA/WJkuhzzVNwVncYFqkgd3CntmVdkLko3SV+KhSeX0+wBkFgvx7eXNLybM4JPh
         3d3u23cA/wMPZWm4I50i3yvowNK4XgK30L+MDen5iHPECFyEanEbFrsX+HIoaJhzwuYE
         Aq7IN/rKw0gR4IX4bTLJ9vs4zdhCt7kz3Ug70o+dfQo97khbQb2GRGCu5hhNPhxGCsgF
         r/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=v2uHo0KL4tP8i7F5Ezn7qF1nuW399RUbWTYsco45lbE=;
        b=5ZCY+hUA075vILh6C90/wztdFZaPDivO73C3zZczxKoqZRvLET5LDJjhkcrDUGvU4e
         Vxg6edieYDBIaeW64N0wf73HgBPIgUXpRSDrX2/xEDPGV9EW6BPMI7i7OBdhlHPKnkfh
         YwFwpk08lgmH/ZR1yc0MXDusx+SvN20o4sLdkBDlKCv4TaP1qSeZomDLR3cg7VT/H0qn
         nWXw8BR8UA3mEetoWKemmLbeRbGlblzfneHxDhrgofUPaENz+FAHRgxpvF4y7zrk4O7/
         z9RvfU6OJyIr9R6Y0o+vR3yhQttN7GTcIp+5o31G5a3TX0Q9QzmP9nDunk25O1Z89e3i
         u5FA==
X-Gm-Message-State: AOAM532PF+1qJIMfEzjvnmmDXfWKudMYiSlDe1XTXP5Vlzcl1Cwcr4yT
        pDN9pGjaajL41LxdkiKM1uCTfL+dVWwBjw==
X-Google-Smtp-Source: ABdhPJzYw419oOrtRsYCDIM2D1Cfjgfaqc/Oq/JMFlKMR88lfrIfVzm2rVNNT/3gy32wAVZCdFMqGw==
X-Received: by 2002:a2e:bb85:: with SMTP id y5mr5045243lje.207.1631293505129;
        Fri, 10 Sep 2021 10:05:05 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id h21sm608079lfv.273.2021.09.10.10.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:05:04 -0700 (PDT)
Date:   Fri, 10 Sep 2021 20:05:03 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 29/31] staging: wfx: remove useless comments after #endif
Message-ID: <20210910170503.cnc2eri32v3bgo65@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-30-Jerome.Pouiller@silabs.com>
 <20210910162718.tjcwwxtxbr3ugdgf@kari-VirtualBox>
 <3556920.DX4m0svyV5@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3556920.DX4m0svyV5@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:49:30PM +0200, Jérôme Pouiller wrote:
> On Friday 10 September 2021 18:27:18 CEST Kari Argillander wrote:
> > On Fri, Sep 10, 2021 at 06:05:02PM +0200, Jerome Pouiller wrote:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Comments after the last #endif of header files don't bring any
> > > information and are redundant with the name of the file. Drop them.
> > 
> > How so? You see right away that this indeed is header guard and not some
> > other random thing. Also kernel coding standard says:
> > 
> >         At the end of any non-trivial #if or #ifdef block (more than a
> >         few line), place a comment after the #endif on the same line,
> >         noting the conditional expression used.
> > 
> > There is no point dropping them imo. If you think about space saving
> > this patch will take more space. Because it will be in version history.
> > So nack from me unless some one can trun my head around.
> 
> IMHO, the #endif on the last line of an header file terminates a trivial
> #ifdef block.
> Moreover, they are often out-of-sync with the #ifndef statement, like here:

That one is of course true. 

> 
> [...]
> > > diff --git a/drivers/staging/wfx/key.h b/drivers/staging/wfx/key.h
> > > index dd189788acf1..2d135eff7af2 100644
> > > --- a/drivers/staging/wfx/key.h
> > > +++ b/drivers/staging/wfx/key.h
> > > @@ -17,4 +17,4 @@ int wfx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> > >               struct ieee80211_vif *vif, struct ieee80211_sta *sta,
> > >               struct ieee80211_key_conf *key);
> > >
> > > -#endif /* WFX_STA_H */
> > > +#endif
> [...]
> 
> -- 
> Jérôme Pouiller
> 
> 
