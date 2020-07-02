Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F309212AEE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgGBRLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgGBRLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:11:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3AFC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:11:06 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so2542660pfh.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=imkgFxBPJhmyk6ZGJrHdTmRqk4E2+SZXnK6Tld+KUHw=;
        b=kxKJXgDgyh/tvx4Q1Z7nkvgsgrPex8PzhlxqzJk+vummP26bguGzG3RwGfDUiPj++Q
         CnQML1QlgeUnsdbwAvZn1VBAfFrNeuzgFh+cYJJ9wzqqRbvM2777E697M3vo0cX/AUWk
         IMGUgew/k6KfsLVrDczFV+jOfu5+ld7ix8OyeJcJ5EpLEp91WufPsR41GxDWymEfySVs
         7gb/RO+hEzBKuEWbfk9c4hi4oEpoKRexTXH551xUkmPMIMHbAZEaTu16PAu56vU9yCZG
         LA1hH+TwHPne5SlXmmzJfXf6aZwD0OVa8NJ5mdFlCrXcupGz5H6K3LL4J5qaQADUptSr
         82fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=imkgFxBPJhmyk6ZGJrHdTmRqk4E2+SZXnK6Tld+KUHw=;
        b=Nq8apQasA1hFVgZtyKdHY+wi+LKAc1lL7xWAVug11asHZsgv1ujhUCJVKkT8bybODi
         kIBWMUaZGqFvWc3LNSjZFYORiVX39/yKULDlsSBK18dPDV+LeWcD0RTsF/90Owjt+ngs
         fvtzhIjLC8DJeSD98PONTVf8QwmdWx/5YJVflP8KsWCHAHLjJJ3N/hAOALwa07OPIlTo
         leqDAkt6CvlqTJPkDcNIp2l1AuLlPikb887ekHuIiANAMN+wQpvVSm9qTQGsnwqaZJjD
         lwAziGKpB38SCNwnEJXck+AXC3btZbEjE624bKVQyoqf69aVgIkTfXWXuk8yPFlTH4j3
         hnWg==
X-Gm-Message-State: AOAM531zONL21CFAeNzmT3a0DLYaz0lGI7Hskn7z8OoRNuvLLz5e/mwT
        rq7jqesZb+u0bQCxmaY/mPqoSqzo
X-Google-Smtp-Source: ABdhPJwKGNs11tSvn4A+p0E79o9sowuYMbdqz3ebojl7VFFKKQo9VSIKxfeQgkoh+kBkvR2dovI+0g==
X-Received: by 2002:a63:2c96:: with SMTP id s144mr24759748pgs.359.1593709866166;
        Thu, 02 Jul 2020 10:11:06 -0700 (PDT)
Received: from martin-VirtualBox ([117.202.89.119])
        by smtp.gmail.com with ESMTPSA id d65sm1462354pfc.97.2020.07.02.10.11.05
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 02 Jul 2020 10:11:05 -0700 (PDT)
Date:   Thu, 2 Jul 2020 22:41:03 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200702171103.GA3949@martin-VirtualBox>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702160221.GA3720@martin-VirtualBox>
 <20200702170353.GA7852@pc-2.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702170353.GA7852@pc-2.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 07:03:53PM +0200, Guillaume Nault wrote:
> On Thu, Jul 02, 2020 at 09:32:21PM +0530, Martin Varghese wrote:
> > On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> > 
> > I couldnt apply the patch to master.Could you please confirm if it was rebased to the master
> 
> Hi Martin,
> 
> Yes, it's based on the latest iproute2 master branch.
> I can apply it with "git am" without any problem.
> 
> Which command did you use?
>
git apply --check was failing.I assume my git remote repo is not correct.Could you please paste yours.
I can do one round of testing and give you feedback

Thanks
Martin
