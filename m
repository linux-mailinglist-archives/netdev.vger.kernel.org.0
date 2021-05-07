Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334DE376630
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 15:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhEGNbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 09:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbhEGNbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 09:31:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BD0C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 06:30:53 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so5351022pjb.4
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 06:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3e23bXJd+p7dh4GaxDoVf76gWEFK9FjW2UO4YRIKG5Q=;
        b=r0eIODdATvsFHKCXLIMBz40h5PXWSO+IngWLwq7Ww4kzfwL+y6PTsYpH4q4YfbKIUY
         ZIXGwuD+OmRZxMaiHZTR2xgxUM3OzOWDX+wlwDAAVIn/wzUnwlq3qF6rzpkrh8Nfo9Vl
         iBxda0dOPGS0THfHTndOphB0v29xsuDRupOMoGgpHkakKQ/Vw5jlRpUpCsaluxVVc6PC
         E4EtIGKFHl2G6wS0wA6Dtwt9Iake58bGRtFev7g2BvM1F88gLZxxSUOKL2mVq5nZYrve
         6REYk+Dsa4FlVGMaLXJf/0BE90Lr6As4K4bK75WvAkg+HsiB/mArC5him4YiHGICJDbC
         NdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3e23bXJd+p7dh4GaxDoVf76gWEFK9FjW2UO4YRIKG5Q=;
        b=kZ/eMC33Gn2HhIDU+wma70xC06NybsE5FV4y1eazeKKTm7jx9Woituhs5ijqq/HFDc
         usquhPL2mRX8fR+zRlrpKE4+prrSeDDt6JT1Actdvw9I6g6kqjAs+r9M3P6M8sjfyA4Z
         ZRTNNUXDVhvgvTucn8UkBPUs7ghRy1JKtAwm71HzohMWEYehvPoLpp0K9cRC3kDbIwIM
         M6FCzGtfFkTVbdjJ7ASyPAQfSy55KJss6Csf/fjQrPwAKntLWX0J3pOjtSNJ28gSfpL3
         AImTxoV8heJV3RAzoIJ2C/yXSTp3QztSYNLvlNvde9Hu+zJR/famHCfUYb7hbZuk+A0t
         2pSA==
X-Gm-Message-State: AOAM532uS8/qoQ4jGtRHFTgQ39DrP7omk9gTEViNPIXVvfJXkpRbiNAf
        3jC8dKAiJ6XwyYRqlIW+tVs=
X-Google-Smtp-Source: ABdhPJx+jwzcFuqcC4QSIwBitjrTQbRVvqTvwcP8V37yNhu11ry5cKofse/laga5a9tuLIo/+D4H8Q==
X-Received: by 2002:a17:90b:78f:: with SMTP id l15mr23039112pjz.44.1620394252970;
        Fri, 07 May 2021 06:30:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y66sm4870358pgb.14.2021.05.07.06.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 06:30:51 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 7 May 2021 21:25:57 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <20210507132557.mgqhmb3acke5w6te@Rk>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
 <20210507013239.4kmzsxtxnrpdqhuk@Rk>
 <YJUvlC6RVGuonNmu@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YJUvlC6RVGuonNmu@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 09:16:20PM +0900, Benjamin Poirier wrote:
>On 2021-05-07 09:32 +0800, Coiby Xu wrote:
>[...]
>> > > > * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
>> > > >   qlge_set_multicast_list()).
>> > >
>> > > This issue of weird line wrapping is supposed to be all over. But I can
>> > > only find the ql_set_routing_reg() calls in qlge_set_multicast_list have
>> > > this problem,
>> > >
>> > > 			if (qlge_set_routing_reg
>> > > 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
>> > >
>> > > I can't find other places where functions calls put square and arguments
>> > > in the new line. Could you give more hints?
>> >
>> > Here are other examples of what I would call weird line wrapping:
>> >
>> > 	status = qlge_validate_flash(qdev,
>> > 				     sizeof(struct flash_params_8000) /
>> > 				   sizeof(u16),
>> > 				   "8000");
>>
>> Oh, I also found this one but I think it more fits another TODO item,
>> i.e., "* fix weird indentation (all over, ex. the for loops in
>> qlge_get_stats())".
>>
>> >
>> > 	status = qlge_wait_reg_rdy(qdev,
>> > 				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
>> >
>> > [...]
>>
>> Do you mean we should change it as follows,
>>
>>
>> 	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
>> 				               XGMAC_ADDR_XME);
>
>	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
>				   XGMAC_ADDR_XME);

Thanks! This is what I meant, i.e. qdev is aligned with XGMAC_ADDR_XME. 
Somehow when replying in the editor, the format is different from view 
mode. So I made a mistake by manually adding spaces to XGMAC_ADDR_XME 
to make it appear aligned with qdev in the editor.
>
>>
>> "V=" in vim could detect some indentation problems but not the line
>> wrapping issue. So I just scanned the code manually to find this issue. Do
>> you know there is a tool that could check if the code fits the kernel
>> coding style?
>
>See Documentation/process/coding-style.rst section 9.

Great. clang-format is exactly what I need. It could detect the above 
qlge_wait_reg_rdy issue and even automatically fix the issue. I will run
clang-format after finishing other TODO items.

>
>You can search online for info about how to configure vim for the kernel
>coding style, ex:
>https://stackoverflow.com/questions/33676829/vim-configuration-for-linux-kernel-development

Thanks. I'll use https://github.com/vivien/vim-linux-coding-style:)

-- 
Best regards,
Coiby
