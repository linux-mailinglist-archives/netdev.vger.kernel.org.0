Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B203546B7
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhDESRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbhDESRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:17:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09076C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 11:17:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g35so3879869pgg.9
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9tvuoZ5xLTvBzZ59CNoUu/Ar1GTeBVA0XpGiJYIAMKE=;
        b=iCj+DX8+TrKCtt3de04bQVM9nMq3whKtlXlPZdQj36IJ176vXXXRzXVpi/ix2175Cc
         Hm8+97GNa8A2luh451WDzt+9IKnVoFWh6RHTV+kxoQQn3wRBfebQhKYF73d3iHjZJ1D8
         uaNBMRZP0i2WYb0GkwM8O4Knz0hdOFDvwvFsvL+hwRESx5gQfIcoQ6691siBwfJsTweF
         /dVeIV3tRgPchy4hZ5ACqNzmotyM3T4RMkQm/zXJTtla5XgUyVyXKwWFJxn3Yw4Erg05
         r1eQUKYCYMXNirQkhr735V/o/jr5FjZYZkyXFJKU9yuE7MYyry9XY071gDOTDMpcVoX7
         zgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9tvuoZ5xLTvBzZ59CNoUu/Ar1GTeBVA0XpGiJYIAMKE=;
        b=qX9W399S/OG/GYA1O/UT5Pdf2oDd9zezyIR1x/rlzGS8zUT6x39fOt4u4ei4Zfjag2
         +WJwkyrX9k7Uces1ZY4wBo2X1yKlTsyWS0hhBIWXyBVgjDBWAe4e/cSkeC2FEM+ZpnyL
         iace3B2wQhCJJK0drAIr0qp3hhQJe42VQQT3xkrDGywTygdDOk0jD3/Ke14dC8JmNzCt
         VnPGXQEACXKdnnIfFLhgU8JroLa6oxTE9WKWDeMr0JUW2iKulOnIoUl5gp9vEUh8F2le
         FVUflGO4ItVKTkiX2qXthwoIgTL2pqFxh9dPyLkaCvsT87Xs3F8x94u7idpTTkPTXMYW
         nDKA==
X-Gm-Message-State: AOAM530wAVKRoH4YIswphv91aAkePWEkTAYHA0lCJEmPEh0oX8POkFKM
        Nl0UsN8TSMK5hzL7gUu3pMacd9m6AtIJ7A==
X-Google-Smtp-Source: ABdhPJzU7RlyXjJtFC8OShhQp4P3im4wLYR9WDBQnfBNT5l97VPlSB+a/g9gZi1f4FZqk1McK1wMFA==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr23733875pgj.361.1617646643647;
        Mon, 05 Apr 2021 11:17:23 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y7sm137050pja.25.2021.04.05.11.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 11:17:22 -0700 (PDT)
Date:   Mon, 5 Apr 2021 11:17:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
Message-ID: <20210405181719.GA29333@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
 <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 09:16:39AM -0700, Shannon Nelson wrote:
> On 4/4/21 4:05 PM, Richard Cochran wrote:
> > This check is unneeded, because the ioctl layer never passes NULL here.
> 
> Yes, the ioctl layer never calls this with NULL, but we call it from within
> the driver when we spin operations back up after a FW reset.

So why not avoid the special case and pass a proper request?

Thanks,
Richard
