Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329633EFB1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhCQLeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhCQLdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:33:50 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB36C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:33:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so1092748wmj.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Kwk6v/o/d4IQ7dKE46qFH2dUVwEGuil3pNDfhSDIfcs=;
        b=ERR3lH06T2HxtiV8dYoqNyKq3V+2Xw+W7gepGhYeie4Ue/XTez3ByeVf7p6ejDuZm3
         w8oOxXtbggHtz1/IYbHTN/p/dWHA0f5YOEbEH2F58V4GOggezm9RQDdvDEHAG6NPqQj6
         9ni7v8sXWALZ38WHyOSOm0l4+x15lbJ6dV4kIZpMAG5XlE18ZVx/ERoRPnY8RnndIOg+
         Sb9RhTtEfhIG78GYNqwGA+1QlgCywhb6jX//VYjZAfd7aP1DGJlu3SVcfhlnPjjsSx2G
         C4gLW0M5TWXF4GL+zfM1KcTm7q6aEbPS6l3bnjM1+aoquHBOpSpkQPmhD7z6Cxr9NzIX
         4DWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Kwk6v/o/d4IQ7dKE46qFH2dUVwEGuil3pNDfhSDIfcs=;
        b=F1ej1bTzbaSlf+mlrfFaBycx97wnYwvivjhuXkRhzAKYfIXO5BCv9aXJzTOr8YOf64
         Ozb9OHAj150pbXmzKUjhwinoFG9bPZxKkZdishpJ1cM/9kav2H3RkfWvPiZv+FEIAwrd
         HW1Iaba1LlWN3PajIYuD5SA3F7DAHAyS+MHqYEisu7lBCVX8z5V3hNlnjHhkoNW+IubO
         Dcpac/f0QhnlVsI5jqYbMGiMbUBhquFo2bOg606imXFXSlj7CgwPqZLKgYzLsgJLS8dc
         rElTkvqAzp/Ompzf8K38kfZTvE35TafnxwQJM8rlFnPI0ncoRObFS8hNM3IMuWQ4sj0w
         Oy8w==
X-Gm-Message-State: AOAM532grxaetTEyaCFZOGzCO5vg5iTra660rB8yMV8o7w90OMuIe+pE
        DVH9YrOS0XvUcYlTgomACu8=
X-Google-Smtp-Source: ABdhPJy+AxsLgrZYxbMRWY5u8wFRthZU3GZteTxJb6/aGeqZjgFIbze6BWlcubbJ59QqbqXMchToXg==
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr3171254wmh.32.1615980829048;
        Wed, 17 Mar 2021 04:33:49 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id c26sm26551756wrb.87.2021.03.17.04.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:33:48 -0700 (PDT)
Date:   Wed, 17 Mar 2021 12:33:46 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Belisko Marek <marek.belisko@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: set mtu size broken for dwmac-sun8i
Message-ID: <YFHpGmgOV/O+6lTZ@Red>
References: <CAAfyv37z0ny=JGsRrVwkzoOd3RNb_j-rQii65a0e2+KMt-YM3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAfyv37z0ny=JGsRrVwkzoOd3RNb_j-rQii65a0e2+KMt-YM3A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Mar 17, 2021 at 10:19:26AM +0100, Belisko Marek a écrit :
> Hi,
> 
> I'm hunting an issue when setting mtu failed for dwmac-sun8i driver.
> Basically adding more debug shows that in stmmac_change_mtu
> tx_fifo_size is 0 and in this case EINVAL is reported. Isaw there was
> fix for similar driver dwmac-sunxi driver by:
> 806fd188ce2a4f8b587e83e73c478e6484fbfa55
> 
> IIRC dwmac-sun8i should get tx and rx fifo size from dma but seems
> it's not the case. I'm using 5.4 kernel LTS release. Any ideas?
> 
> Thanks and BR,
> 
> marek
> 

Hello

Could you provide exact command line you tried to change mtu ?
Along with all MTU values you tried.

Thanks
Regards
