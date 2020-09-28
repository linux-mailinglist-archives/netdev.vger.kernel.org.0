Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B4C27AB18
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgI1JrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgI1JrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:47:11 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F00C0613CE
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:47:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so363931pgf.12
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sByFvzANNavXstWIngm0BaCccoxXcpgpgCM5Oz7ddDc=;
        b=QSvKozpy4dwqhQ3rm2KwqwK/O8nSux1S09jdTfHI1J273nxM5rEIfPP1WJXCY/fPu4
         dbrSOz51lPZZSOe4akRbLX74WJlrqNHqGi0lSz6gR5R+512/PBm+n9/QFRDYRBwKeYBZ
         Nvmm9Rv9GwdsvYRvfKiQvhRdSDnzhPi7OccY7poPFhiTND0z+0H4s2UtyuFwQTeRggLi
         pJZUSEWKf9j+x4CqBZZ5+Sfi8Rc1QMN4/31RS3j5+mb1V4bh9wCEuXkJfCWE07vpixqZ
         HsmulRCsj5e5M2pIUO4y0aelzRVfCQor/CBXf6f/P6qQ/Zd/KLlkJhc483NeLJsOiDl1
         UVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sByFvzANNavXstWIngm0BaCccoxXcpgpgCM5Oz7ddDc=;
        b=dcjk84nSXzL9GLSBz12AGnFqrE+L5B/rvC5tdsXy4aU03flpasWzUN22W5VcXlWycD
         awuLtaEGh5b29JBOh70WoF9QB7gxAYk+Q0Q9qAl7dFWHWZduuiOelO42bFl8izIIb0/b
         HG2KSJKYjLsV7xWByAJYKWbRaSU0Q6TCPhoX+yYhNIxW/bxaScxxshv+NwccAeeQHcVC
         wIeAoc9psJDzx0wRknHy9dKaTtJARQ9qIzBsg4J2LQDCCJUzoc1BPOB6oXQH/WjZQW68
         CnWD1i2Spt4org1ih5erUUJ4V4+w20Iy+K0Kf46mdApSf3BTawO0uLEXlIcq9+zPSQjg
         L6eA==
X-Gm-Message-State: AOAM531EcSHGA8sNft/J4JIf5AUhzVgXEiC20f7hizNyZXADNkcEELSj
        EAqcAxuE5kgG8/t68vtMDoDw
X-Google-Smtp-Source: ABdhPJyEqUCMQ5YQbSuGTIK/wFn0PQfjKFE1yYJVltrnkh9bccuAL1DaU3x6A/Y/8EkftfiR7/YNEQ==
X-Received: by 2002:a62:6dc3:0:b029:13c:1611:658d with SMTP id i186-20020a626dc30000b029013c1611658dmr9450782pfc.10.1601286431063;
        Mon, 28 Sep 2020 02:47:11 -0700 (PDT)
Received: from linux ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id z7sm761284pgc.35.2020.09.28.02.47.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Sep 2020 02:47:10 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:17:04 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath11k@lists.infradead.org
Subject: Re: linux-next: build failure after merge of the mhi tree
Message-ID: <20200928094704.GB11515@linux>
References: <20200928184230.2d973291@canb.auug.org.au>
 <20200928091035.GA11515@linux>
 <87eemmfdn3.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eemmfdn3.fsf@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 12:34:40PM +0300, Kalle Valo wrote:
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> 
> > On Mon, Sep 28, 2020 at 06:42:30PM +1000, Stephen Rothwell wrote:
> >> Hi all,
> >> 
> >> After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
> >> failed like this:
> >> 
> >> drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct
> >> mhi_channel_config' has no member named 'auto_start'
> >>    27 |   .auto_start = false,
> >>       |    ^~~~~~~~~~
> >> drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct
> >> mhi_channel_config' has no member named 'auto_start'
> >>    42 |   .auto_start = false,
> >>       |    ^~~~~~~~~~
> >> drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct
> >> mhi_channel_config' has no member named 'auto_start'
> >>    57 |   .auto_start = true,
> >>       |    ^~~~~~~~~~
> >> drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct
> >> mhi_channel_config' has no member named 'auto_start'
> >>    72 |   .auto_start = true,
> >>       |    ^~~~~~~~~~
> >> 
> >> Caused by commit
> >> 
> >>   ed39d7816885 ("bus: mhi: Remove auto-start option")
> >> 
> >> interacting with commit
> >> 
> >>   1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
> >> 
> >> from the net-next tree.
> >> 
> >> I applied the following merge fix patch, but maybe more is required.
> >> Even if so, this could be fixed now in the net-next tree.
> >> 
> >> From: Stephen Rothwell <sfr@canb.auug.org.au>
> >> Date: Mon, 28 Sep 2020 18:39:41 +1000
> >> Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA6390"
> >> 
> >> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >
> > Sorry, I forgot to submit a patch against net-next for fixing this while merging
> > the MHI change.
> 
> Try to notify the ath11k list (CCed) whenever changing MHI API so that
> we (ath11k folks) can be prepared for any major changes.
> 

Okay sure, will do!

> > But your change looks good and I can just modify the subject/description and
> > resubmit. Or if Dave prefers to fix the original commit itself in net-next,
> > I'm fine!
> 
> Actually I prefer to apply the fix to my ath.git tree, less conflicts
> that way (I have still quite a lot of ath11k patches pending for -next).
> I'll then send a pull request to Dave end of this week.
> 
> So please submit the patch like a normal ath11k patch documented here:
> 

Okay.

Thanks,
Mani

> https://wireless.wiki.kernel.org/en/users/drivers/ath11k/submittingpatches
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
