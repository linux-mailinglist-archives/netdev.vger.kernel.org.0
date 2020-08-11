Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FD7241B90
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 15:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHKN32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 09:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgHKN31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 09:29:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6ACC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 06:29:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id w17so2007350edt.8
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 06:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EbI4Vpt3lomGTELzV9wMrIqMxU8Q/+jOgdjNGF/xZrI=;
        b=wePjbvZrJU8N55nT/6hn9onaTOM6hvwBY+6Rw3tFyOFXHC/F+mCXrKDCE4UY4fIlo/
         wAJjkQhz9eqpzVyy5AXT6g/22q5rxNBWEODJX+LVn6OzpRJXzKUxN2CcNhvvUzHFQvDG
         leFpU14jE/UvguF2uPmGDapBkkJZFoFfz7TqCUzBcLtBL8fFEUUOXV9SNCEI1HKVrlfT
         KdfK2oRykHU8bhVVfmGBX8vrWu5sd83wP+2eOP2yXcY2xbKKslDTgQVa0+4NoBA89mUL
         sJiQgQkwtITuBFpEhqBvdiEw5Riz71NYm74ZUPS9g2539ke6hQxUSAZmBdRVrnveVZlf
         m54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EbI4Vpt3lomGTELzV9wMrIqMxU8Q/+jOgdjNGF/xZrI=;
        b=Ch+5rambuA5z2ONBetGFPUdbNg3mqHeydjWlQ6/MPOFpjzieD6K1U7HQKuwR+Osdyp
         TeEaU1CXXVrylr8/izR7ijkCjoRB14iFiuQ9vIK6qrynTbzCiqrRiDhaZFK/b/TKLBj8
         EXcgxEB7qn8h42cJcwUCsN0Hqf6sifMhkd6bqJ3KdrWwYs9XWZa6lAMT6mqOyQ0XSnEI
         imc0xRVpixHfd89uCtm3Vt42zAjVnmyYEtdkIMBFUMB8Fv2+XLD1dLQYt0RlxL/m393g
         7383oPHe1Jl43BQHD0iUkXqmthhM08cgRDOI9ayTPxGuFVcUzPcVF5ptbgXu4IiK4z2u
         UJZA==
X-Gm-Message-State: AOAM5314mLkLxAgFDh8uT2EriQVeMnrAvCivaHDLIEW5cRk/dWdgew0y
        nBdGpwrcrqDuV4pqx1KgCvBGuC7kpOk=
X-Google-Smtp-Source: ABdhPJz18PmhEKF/fXmgKMW+SYqtw6+lX5n5Z2uHeknCogwPqg8h8HHfalGQbXnIOqz7mquh2DNAQA==
X-Received: by 2002:a05:6402:1e2:: with SMTP id i2mr25407814edy.70.1597152565766;
        Tue, 11 Aug 2020 06:29:25 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id i5sm15063217ejg.121.2020.08.11.06.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 06:29:25 -0700 (PDT)
Date:   Tue, 11 Aug 2020 15:29:24 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] nfp: update maintainer
Message-ID: <20200811132923.GA32574@netronome.com>
References: <20200810173204.26222-1-kuba@kernel.org>
 <20200810.121142.90211783405052180.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810.121142.90211783405052180.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 12:11:42PM -0700, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 10 Aug 2020 10:32:04 -0700
> 
> > I'm not doing much work on the NFP driver any more.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> Applied.

Thanks,

for the record I'm happy to take this over on behalf of Netronome.
