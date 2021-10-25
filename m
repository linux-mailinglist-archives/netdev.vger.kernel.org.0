Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35A438E77
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhJYEpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 00:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhJYEpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 00:45:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F43C061745;
        Sun, 24 Oct 2021 21:43:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e65so9695828pgc.5;
        Sun, 24 Oct 2021 21:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Vf5WJWhvYjr6085y/HECvMmSP6tozCwmQ+cEe9Bdhw=;
        b=G23ErahTIAEET6N0jKxr4uzKKJKogQSXte0e3OD3YT08qqqxGUlQYx+Nc1v51mdc7u
         TDh+uewa0zFXD0tI3vH3h9jMcLO0np2pZJC3p1anJ0n94aLSTraY40tHi/ePepGa2x+b
         io2GHE2r6XO8HMcw8wHzJtYVECu+yilHsVPqUt85XAzIqbTFPlyi/xJH/MRiI7u7kr65
         1dejgQiXjI8qJTmfa6z+YW7S9+ZSPDDd2S5Ur7cPjLbXBW5f2wBMZsVGnf6JH+DUuzW4
         Ow7IMU3c+gftL33VusiFN/yzL8aCbeQtnp305SMnH+WtChxzrMoUjxI78upSkOhg3smt
         Ob1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Vf5WJWhvYjr6085y/HECvMmSP6tozCwmQ+cEe9Bdhw=;
        b=fHxH7kPeXOXUcxknCvClPq7XcRZsyVVS3gcikmVjYGvWn8g+vqylQCn5//WBdn3cuJ
         9nse/HZsPRHMoYWGUCe7A62BPC2MDEYGJHpRNOZ96QmWE7S7Xo3HatBv+/vGTdCTnXQV
         suFxWILbKNhqi8OsoNq1DWQaVWBi0ZHXBisZItZ816s7iOhZsE4S3yqxkfKqev8Rc5my
         b2pbrdyprpJDYn5+VYSELKYXLl/VP6q2YT2xXp2TBe8wm0wf8WCyxrxUX5B7j0jYloJC
         xpHRycHjwUzpFTs323jRLSU+J1f3HQOpQ8G0q7Ow2QVWi6aPt7L1UzQDad6aHions/jc
         8nXA==
X-Gm-Message-State: AOAM531x6S/c8qeavjhXZ7eyGf/ffrdpcAprIVDCFBKglXakFzgGf0yN
        xbIxGgX5DiHIXDOmFBSj0p18aLe7Glc=
X-Google-Smtp-Source: ABdhPJzdMNio7yb/IDb48HVtiF9cXL+2pUbh5GLL1E3F84XWawV6iZydFPfZqGVmBv5UZoLVtWckgA==
X-Received: by 2002:a62:3287:0:b0:439:bfec:8374 with SMTP id y129-20020a623287000000b00439bfec8374mr16112797pfy.15.1635137003674;
        Sun, 24 Oct 2021 21:43:23 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id o25sm2890410pgn.47.2021.10.24.21.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 21:43:22 -0700 (PDT)
Date:   Mon, 25 Oct 2021 13:43:18 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: Unsubscription Incident
Message-ID: <YXY15jCBCAgB88uT@d3>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
> On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
> >
> > Hi,
> >
> > From Oct 11, I did not receive any emails from both linux-kernel and
> > netdev mailing list. Did anyone encounter the same issue? I subscribed
> > again and I can receive incoming emails now. However, I figured out
> > that anyone can unsubscribe your email without authentication. Maybe
> > it is just a one-time issue that someone accidentally unsubscribed my
> > email. But I would recommend that our admin can add one more
> > authentication step before unsubscription to make the process more
> > secure.
> >
> > Thanks,
> > Lijun
> 
> Yes, the exact same thing happened to me. I got unsubscribed from all
> vger mailing lists.

It happened to a bunch of people on gmail:
https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
