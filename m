Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928CF21320D
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgGCDMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCDMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:12:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0FDC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 20:12:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so2870869pjh.5
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 20:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/wiZ6/Hw22KaSKTq37+45lgf3d4yA/ijjTmGUmKJ5bQ=;
        b=t6WSUMfE6STtjTkEy0+oDrAOzmlaPmC2etBDb64IwxNF/TxRN3AXQW4mKIlPuKyr9/
         +1pKlKFT5YuiS8gWF4u+PHWObYVSkj4H/d6I+KDKhF8jraXRLZSCopi3JGvVfK9TvEV1
         8kaH76UQwd2lnhXUQiRGjLoOK10mfYjT40GvGMlD0Rrm0I6LjgH+1nOqOowCHMj4JnjU
         qXdlCNHS4OqeiROzXsF5qtvNqbvhef147S5sdrh+bLFc5cOnP4/IESdOHFpZ8DRfi+lM
         SzjKEurwVAYYaXSO0hHSTf6Md3cE6o1xUejFgQzfwOMN/a1d7OLV5O2G//oMyxbUVUbi
         Dj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/wiZ6/Hw22KaSKTq37+45lgf3d4yA/ijjTmGUmKJ5bQ=;
        b=A3mFXiXZDXS7etQLQ2bG3CDHuT+vPRdsc/Gm/nJ3dC71VXwBam+nh/fGOU2WF4d660
         ffZWzAh42y/x4ICd6+LCd8P4+1tZa5moZD7w/+PTLL1GcUUiStq8jd8oY1MxKdMKkl2n
         bJJj+D18O+rviuoR+0Hxj00g+kA6AO49twDJkq964xzUFvtf08lQE5Ue1iMwy0gGuo2k
         ogVxJV4lpRFDd1vIDD7zAA22c+ljcGUyb4/YTXcW5eEyFRH40ZVAj0vML3UaN7bja0Rq
         VgzfNInvpWJl2xMOggOPvJwB//EKfgQlHyEmFON2yP8KceymSiBbkE/T2h/y72yD/TpW
         1DWQ==
X-Gm-Message-State: AOAM530RQGui6eCIsP5mKF+ByVMYhcy5oG8dA8leNhHtSU2svHue20lA
        tb3+6G+6ITDkJviK5rALo4J7ZEpM
X-Google-Smtp-Source: ABdhPJz8+fgOsH0ZgV0Y+Jv7PjWM5jX/zrx+1VJROjFb55zouuYO6iQ9RG+q+1P0Jt1f99xLf6iBmg==
X-Received: by 2002:a17:902:b78a:: with SMTP id e10mr29348266pls.34.1593745960161;
        Thu, 02 Jul 2020 20:12:40 -0700 (PDT)
Received: from martin-VirtualBox ([117.202.89.119])
        by smtp.gmail.com with ESMTPSA id q29sm9696716pfl.77.2020.07.02.20.12.38
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 02 Jul 2020 20:12:39 -0700 (PDT)
Date:   Fri, 3 Jul 2020 08:42:36 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200703031236.GB3079@martin-VirtualBox>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702160221.GA3720@martin-VirtualBox>
 <20200702170353.GA7852@pc-2.home>
 <20200702171103.GA3949@martin-VirtualBox>
 <20200702173231.GA8376@pc-2.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702173231.GA8376@pc-2.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 07:32:31PM +0200, Guillaume Nault wrote:
> On Thu, Jul 02, 2020 at 10:41:03PM +0530, Martin Varghese wrote:
> > On Thu, Jul 02, 2020 at 07:03:53PM +0200, Guillaume Nault wrote:
> > > On Thu, Jul 02, 2020 at 09:32:21PM +0530, Martin Varghese wrote:
> > > > On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> > > > 
> > > > I couldnt apply the patch to master.Could you please confirm if it was rebased to the master
> > > 
> > > Hi Martin,
> > > 
> > > Yes, it's based on the latest iproute2 master branch.
> > > I can apply it with "git am" without any problem.
> > > 
> > > Which command did you use?
> > >
> > git apply --check was failing.I assume my git remote repo is not correct.Could you please paste yours.
> 
> Here it is:
> $ git remote -v
> origin  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git (fetch)
> origin  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git (push)
> 
> > I can do one round of testing and give you feedback
> 
> Nice, thanks!
> 
I did one round of testing.It looks good to me. Thanks 


