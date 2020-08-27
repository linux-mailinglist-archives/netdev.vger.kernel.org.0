Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22869253DEC
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgH0GgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgH0GgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:36:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A501C061264
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 23:36:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o4so4204144wrn.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 23:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=akR5LsWB+L7ENwYAw9D4wcSK8jvQH6F09dbiIXvyFCk=;
        b=H8vbnYW/S+H7tZZYYO5Fs3PPBaCtYQdePiDEDqJOjsMv5DF6G2r7fYacs24CCUEaAt
         M3e1iWPRZPukneXLcYdSJGgvQQ826VwRp17Sv20+QJTNJvXWHfkZABR3zVA0DWOcTzdg
         WEgIW3cZElL+bglDngYnh1LuIaHi/EV/2I1iKVO3m3j4xIQwohTnASGkYv8BwxHFT6Tg
         htWl0SMTHiOOLoP79DFGPB7xALFkOssU25a1B7AThZesH2WFhTlnyAwyQG09UCxIlfQt
         dDsHe95PD32mdOGZohe5PKfcsO5FWScCiMzdkncTi71joxY8dybGZxXjcXIt1WNujlh7
         /dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=akR5LsWB+L7ENwYAw9D4wcSK8jvQH6F09dbiIXvyFCk=;
        b=QSAZ66PoWoQx+luZJYwI8JoH55UqSJvZ2HUBpWSTTPihBvGYG+htSZNbrrhQh9wpiw
         kIA4X0zpeFuGBSxTa5dkU28wRZMBxOsM4ZPdU0pqvy3JcTjSWG7wx3/pfZ+f/UGAH+zv
         r8U21kW5BGBu5H4PD7EwwQJE38hU2O1ciQwjtDlVTv6sOWuLMWy4y9hGVa6jYxBoOTWI
         wkbOdMTTSgkGIntil/q/tknoXXEVEV6shK1oWBRDzgUxCbO7QZzTfREufvzQbFiyDccX
         TLDncYpFL+t5JZhKub7VS3alUk4DHSWEpNK7g2KW/37JJMKKeVpCjXyuxPXFLGjTEH+f
         Qtdw==
X-Gm-Message-State: AOAM532U0plxHFR52c2pFpo9MK0AOpxgMDB2HGal1SFY1xMe04iQ0Fh8
        8ia429CBBMSG7c8gNdkGS0Cggw==
X-Google-Smtp-Source: ABdhPJyUoPKR71NVAZJhTV3U26Io2C1TwglVVoLwoSOZIX2rFDKJaRv5rbS/qFs4nDKGnwNHN81ydA==
X-Received: by 2002:a05:6000:1c7:: with SMTP id t7mr879463wrx.145.1598510162237;
        Wed, 26 Aug 2020 23:36:02 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id q11sm3530317wrw.61.2020.08.26.23.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:36:01 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:35:59 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 12/30] wireless: ath: wil6210: wmi: Correct misnamed
 function parameter 'ptr_'
Message-ID: <20200827063559.GP3248864@dell>
References: <20200826093401.1458456-13-lee.jones@linaro.org>
 <20200826155625.A5A88C433A1@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826155625.A5A88C433A1@smtp.codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Function parameter or member 'ptr_' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Excess function parameter 'ptr' description in 'wmi_buffer_block'
> > 
> > Cc: Maya Erez <merez@codeaurora.org>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: wil6210@qti.qualcomm.com
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Failed to apply:
> 
> error: patch failed: drivers/net/wireless/ath/wil6210/wmi.c:266
> error: drivers/net/wireless/ath/wil6210/wmi.c: patch does not apply
> stg import: Diff does not apply cleanly
> 
> Patch set to Changes Requested.

Are you applying them in order?

It may be affected by:

 wireless: ath: wil6210: wmi: Fix formatting and demote non-conforming function headers

I'll also rebase onto the latest -next and resubmit.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
