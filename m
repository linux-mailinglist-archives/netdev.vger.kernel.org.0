Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FCD1C4BDD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 04:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEECVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 22:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgEECVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 22:21:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91354C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 19:21:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d22so352145pgk.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 19:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tMquxkQYPL2BJYqyWfRM/YRioJZehCXk4xkC2ItsxuY=;
        b=tviNZunMmN3wlz+7wCG4GnHllHPw+wawew8dOGp26myhEN7mE0JC1fZawuaWlsepia
         +UhQBsjO/mf0dztlxcDcQlmfKYfzLzVc2XtYNfj4FaJUHVhulX34XzHWD7BKVW6Dgltn
         V4QpUENotp+px/XlpNvelQtUvHF4Zzi36EKVRcWP084EbkVeYKhyQn1RvJy4vxn8zPUz
         PYFIiRtNy1NTclHyesB7LtQ1CKGeNlxKSz9dfaSdywLk98bZojXtbeTiiaL3dw/qVqn2
         BbmueY2JJXOXF6/aJlNkmlVvuFlENO/kVxGuLPzBkW+bxDWze9cnSvGsc4Dn8e7ES+2K
         +g1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tMquxkQYPL2BJYqyWfRM/YRioJZehCXk4xkC2ItsxuY=;
        b=BFT7rV9BNcWtj47suGFP5i51LqrVCD3RjqJLos0dgW7+41ZNfi5+7Lp1+prSbb5EPM
         60j0bbjiBkKN/99J8gCj6zPAVYiBPBmd/40urraz3yEeG0YLnHQWSe3Q2xHUq/MLtZnw
         eExLx1jmqc5GGLSFapof0nMZ1nCfSHdLJQuxTan9pspqIJb+hgvKloHkjixNct9xBAJS
         wW+IZLQAwfDNz0zakhuR+Uo6i+m3PzYTJXXqR8aewZhwvjJVDvxSIt3re24ZX9saRMIs
         uQbI4sT7eIM9gSCqphLUoVSbcq3i25aKHyhWp+x2pHU2WuwWLX8Am1nmqNpTr9OGlubk
         Dslg==
X-Gm-Message-State: AGi0PuZvLWICbn2l+O8NrfCuLWskpg9U1B4ky53Oq+GAe/iZWd5Pts93
        /F/i3cwYkR+t9S9K2wKINm0=
X-Google-Smtp-Source: APiQypJ4lD1t+6J5wOdY8CJTbjYSgYH80dFo9jkFa2FsfBtlm0PTHt8lIxUKkreAoT8eTGUvEvAe0w==
X-Received: by 2002:a63:2166:: with SMTP id s38mr1024203pgm.369.1588645313033;
        Mon, 04 May 2020 19:21:53 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id j7sm321424pjy.9.2020.05.04.19.21.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 19:21:52 -0700 (PDT)
Date:   Tue, 5 May 2020 10:21:43 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc:     davem@davemloft.net, Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
Subject: Re: bgmac-enet driver broken in 5.7
Message-ID: <20200505022143.GA31724@nuc8i5>
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
 <20200505003035.GA8437@nuc8i5>
 <CAHrpVsU5LO8P74r=9hmfFcoX_zLc8fYAQxmV8J0THbM6OJWfyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHrpVsU5LO8P74r=9hmfFcoX_zLc8fYAQxmV8J0THbM6OJWfyQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 05:37:18PM -0700, Jonathan Richardson wrote:
> On Mon, May 4, 2020 at 5:30 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> >
> > On Mon, May 04, 2020 at 12:32:55PM -0700, Jonathan Richardson wrote:
> > > Hi,
> > >
> > > Commit d7a5502b0bb8b (net: broadcom: convert to
> > > devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
> > > probe fails with -22. idm_base and nicpm_base were optional. Now they
> > > are mandatory. Our upstream dtb doesn't have them defined. I'm not
> > > clear on why this change was made. Can it be reverted?
> > >
> > Jon, I am so sorry for that, I will submit a cl to reverted it to make
> > idm_base and nicpm_base as optional. sorry!
> 
> No problem. I'll let you submit the fix then. Thanks for taking care of it.

Thank you very much for giving me this opportunity to deal with my
mistakes. at the same time, I apologize for the trouble to bring you.
now, I have submitted a cl is here:
http://patchwork.ozlabs.org/project/netdev/patch/20200505020329.31638-1-zhengdejin5@gmail.com/

I hope it solves this problem. sorry! I will be more careful with each
new patch. Thanks!

BR,
Dejin

