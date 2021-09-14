Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1386940B206
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhINOum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbhINOuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 10:50:08 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76EBC0613BA;
        Tue, 14 Sep 2021 07:47:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 5so8355967plo.5;
        Tue, 14 Sep 2021 07:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DFVYjmutsndVs1ZuTbUoHDKL/zDwuKKZLd3sEqGsf30=;
        b=aLXTsKBX4Rold9d9yvndZNLNlk7FEA3iFWu++Vw+wsB50Mb5fUz1D9gq0aKO6oheEq
         4a2lEHd4s0KFi69yL9AMhSrl17fmlsx5s542xSdiAtUCDETSqjxXJ6YCRrpW6itnzK4z
         lLSWjrdt64wHloJZvNsVwiP/Yu6zXpP/i9VA/ZqJXxVnv3Hcf7XEsuMr9vpB5X4lKHeW
         x+ylrA16PBZBRW6XiZhV9E4GmDM+lUCwN/B3FhvUDwxMt8lzkYq0lJJUAoKXTVUNC/NO
         TasCdeOJ9vfTCn58W3CNIDxQMldPlCoUVY+5uN8WjDKEQ/E/kXO08tOi47wjle69Ym/N
         tuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DFVYjmutsndVs1ZuTbUoHDKL/zDwuKKZLd3sEqGsf30=;
        b=z2VNU7OpElagLhziT3oQL3CpNnxnTOmthn+dJPdCSRLorKWjbCgTPIp8rFWllmDry1
         lwamhUQ9JKwNOSirbrO7AvDgQWysm6HRkHYLpGX2OdAC/OwR/NlsZM01HcyTXIFXfgQL
         MovH5U5VgSq3JIVHoH0b73Zh4iVqYEyLxo0oWwNtUovsNIfJljRvICsY0zAqYCNNeS71
         OQEV/apNIZF4Nza8Lxh2Fb7UofElvnJyTi5SSIuLv1bueabl0Beth6yDTbUoGkFVrDE2
         VIvaff7l2lBHUxGbARNU4W7DbkjDHpc4DRX3jK7kWjVJ/Woe7edoESWyC/e4wIDi/jMz
         RgpA==
X-Gm-Message-State: AOAM531lJ9BHrA7iO8fNsKWYjjMO6x4vitClfEG50oqf8XPJSwz3qVlD
        h0MCZT5IP85pk0bB9319qvX3ZW1RMeI=
X-Google-Smtp-Source: ABdhPJzO1eGYQioaLUQKJjYs439ok7X8lVlfFqEAw5m0vfIlGjvskR9EZaPEwap7NCSYxHi3U38BUg==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr2535674pjb.36.1631630858406;
        Tue, 14 Sep 2021 07:47:38 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c23sm11643249pgb.74.2021.09.14.07.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 07:47:37 -0700 (PDT)
Date:   Tue, 14 Sep 2021 07:47:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 29/29] ABI: sysfs-ptp: use wildcards on What
 definitions
Message-ID: <20210914144735.GD23296@hoboy.vegasvil.org>
References: <cover.1631629496.git.mchehab+huawei@kernel.org>
 <ead7c9b34e7a00146e518d5f7c255b9fc72a9903.1631629496.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead7c9b34e7a00146e518d5f7c255b9fc72a9903.1631629496.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 04:32:44PM +0200, Mauro Carvalho Chehab wrote:
> An "N" upper letter is not a wildcard, nor can easily be identified
> by script, specially since the USB sysfs define things like.
> bNumInterfaces. Use, instead, <N>, in order to let script/get_abi.pl
> to convert it into a Regex.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Richard Cochran <richardcochran@gmail.com>
