Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3553F42DBF6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhJNOpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhJNOpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:45:45 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8003C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:43:40 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id v17so5956281qtp.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITdFVgd0CcYj6iQsuAiP2p3dvvTOyzqMQ2c0R/TALeQ=;
        b=bjF2RFuBLSkg41n4klDc4YJ83ECjlHKka7Go2am9IddIJmaQgg0lMd4k4V+KRj7YBr
         Y2bHptEtHURA0de9RynBHxiH572aR3+VzjAAxS7aJXXC/GuNdRktbeZdrm9iaIvFJoFA
         ZPwEqxDI7bhtOwiOZCK6WnrNDZ3noln9ieqJk0Q4rRCWpYiL7hF08/FoRzYhDS5s42K1
         B+CLd6LdVAw4tsA8yVUV2x7uOSMaOroH/Oy2fs5Qg+oLovy2VH/uyYSQAnrxfedm1lzr
         REUngbcFPokswv1XrnHHk3l0sF0N6oKwIPe2Rs+PjVvuLWy/vJQE5+kGTeeNpy1lNzZN
         8FpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ITdFVgd0CcYj6iQsuAiP2p3dvvTOyzqMQ2c0R/TALeQ=;
        b=2+xKobWfyZVmkdla4nXm+fD7Cd5U0jAQswQasP58RzmPwbAoe373POC4AIPPHkwjFU
         Xa77ndNrYDyhbecpdcn2wxZ0JFdD1nRGnikzbxJCNjhvP4liq5AcrEe1bB00GxgaykPv
         0rhShtGOC8gZtrC5j+XeY+F3iVitJlakeL5ui4gnNL6PnGGklN6Z6TZ9uZYnOS62NUsu
         vZNr76+mf3RfDq92UhT2YYrVP6+udnpDNNe1hBJ526X/y1jRP9QnX229n8HrdyU9wN+D
         QKT7oUhEePeElKwwRywn6SUR5cqCIr6/jR4myD59K940qhnk6bXOI5tm1es5xwMulrkn
         ssBA==
X-Gm-Message-State: AOAM530PZ/FeZafAIoKKhP9qf5qTkQqJqo9cWoS6czvZKp34BXnX1tA7
        CXKCnKTwuwKfKQfiHxfjEwXz8kWEsA==
X-Google-Smtp-Source: ABdhPJymcxXmNoLZf+HVGTNyxwV3D0I9j+VJbBUY3rJ3VmIDgdWgaSB/UOGxulWIVJozM6Nn/YvCDA==
X-Received: by 2002:ac8:5c16:: with SMTP id i22mr7170876qti.26.1634222620075;
        Thu, 14 Oct 2021 07:43:40 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id n79sm1361991qke.97.2021.10.14.07.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:43:39 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:43:37 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Anybody else getting unsubscribed from the list?
Message-ID: <20211014144337.GB11651@ICIPI.localdomain>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+1. Had to re-subscribe.

On Thu, Oct 14, 2021 at 10:18:12AM -0400, Jamal Hadi Salim wrote:
> I was trying to catchup with the list and i noticed I
> have stopped receiving emails since the 11th. I am leaning
> towards my account being unsubscribed given i had to
> resubscribe last time.
> 
> Anyone else experiencing the same problem?
> And, yes - ive checked all of spam...
> 
> Who owns the management of the list these days so i can
> reach out to them?
> 
> cheers,
> jamal
