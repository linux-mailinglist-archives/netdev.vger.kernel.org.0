Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8754497578
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiAWURi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239855AbiAWURi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:17:38 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8A7C06173B
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 12:17:37 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id c3-20020a9d6c83000000b00590b9c8819aso19441056otr.6
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 12:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ve/6CfQXAN51eaHCHon7HCmkvvwRj2/WB6mv0tDWaH4=;
        b=colF8fmZK5RibniqaInFzjG/OOA9pkD124ip2fkNSwEekQWhhUcs4xWvu//moIwhOJ
         BqoEBTM7FcngOEYEc3wDdTywhEfJl6WwiRxxlB4lyZ5ZettCfsUiJbt1pcfk+/6fRyOk
         LSwvMnceLZP+fwJoVr//TncnAq7LDkdkHjsbzIptF6WOnG9zSFEHXRvb3NHvIoN6lCTD
         ixaBLMfz/LYQ7s51fJ9W7djVP8UZJg3oNcvIJHbByPoQAelYSytXlIz2wNLa/2gjBL0x
         Q0dnoL8/y2Z4/TBgcDCi9LJdXzFeWtR9tb28dMEbbIEFIA373fTNhGP4Q5xEkeqDudjH
         APpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ve/6CfQXAN51eaHCHon7HCmkvvwRj2/WB6mv0tDWaH4=;
        b=JCXP/Ym/Ib0MkZz75u5yVIzw1xvVcouRlW7bWRwbCVyk2/3VeBhW8ZqZdQ1WyvN3Y0
         YF7keZp3r8I8Np3zCWHDUJpe7+K3kgnrcwEixk4xZHqy4si3TPelnFuYbCafAcOoBiiT
         CRBOrWvYjUhvl9rV3dE2yZdKt1f+0z+Hh2jjp1yhF0mL1KlsLU6ENswp9dE6GOWoAI3v
         uH8e57pEY57je3K8OdbZYW2Gt4mu+KWt6hd2xAYH0z9CS/adsvEXp2NqFTOBqvL+SxLv
         dkupAcLsrPNzXgrwMCek4cgNDQU7kQog9PWE5qBc4vpT0OwywaJnaU6zEJEfkhMi7L88
         zDJg==
X-Gm-Message-State: AOAM532h1MjG8a36WZgCjk02lcJJ8RTigMO4C3XanRgA94sE8ZzAtHEj
        t6rjSeu7YRtCF72WwYICq/ibuMtkNhg=
X-Google-Smtp-Source: ABdhPJyYMsZt7YhTe2blI8nHAweS91AyDlxKY59mcKthMmip+yPALcesst/XQkq5TbiLXOIUfcZ7bg==
X-Received: by 2002:a9d:6d85:: with SMTP id x5mr9640417otp.253.1642969057327;
        Sun, 23 Jan 2022 12:17:37 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:4388:ab9b:beec:5dea])
        by smtp.gmail.com with ESMTPSA id f2sm4578453oiw.50.2022.01.23.12.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 12:17:37 -0800 (PST)
Date:   Sun, 23 Jan 2022 12:17:36 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] sock: add sndbuff full perf trace event
Message-ID: <Ye234Pb0f1SusMbA@pop-os.localdomain>
References: <1642716150-100589-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1642716150-100589-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 02:02:30PM -0800, Joe Damato wrote:
> Calls to sock_alloc_send_pskb can fail or trigger a wait if there is no
> sndbuf space available.
> 
> Add a perf trace event to help users monitor when and how this occurs so
> appropriate application level changes can be made, if necessary.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  include/trace/events/sock.h | 21 +++++++++++++++++++++
>  net/core/sock.c             |  1 +
>  2 files changed, 22 insertions(+)

There are more places where we set the SOCKWQ_ASYNC_NOSPACE bit, so
it looks like your patch is incomplete.

Thanks.
