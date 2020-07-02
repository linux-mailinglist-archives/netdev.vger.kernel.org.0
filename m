Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DFD212B4E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgGBRci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:32:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbgGBRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593711157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KOx5qXk81Qd7N4vY5cKJ3mwX+W/O3uOUQmWWrUfoUNE=;
        b=TnIovyBmXEEHmPjAaEkdGZ6Xs+SkUNl2cItOCTtdgxysBETXiMIWcY2r0MsFgI3wwqBxeo
        UGAdaShBVgAiSNlaNch7JU3im9EuT5RGpF9PiWJEPjn1TqvD+e9KaNgpQlUcD2KALdgnNp
        80bAacmQCNT7u36UDc2pS3LA7LCO9ks=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-Y5KH4CvVP0m1SaPNrbnYKQ-1; Thu, 02 Jul 2020 13:32:35 -0400
X-MC-Unique: Y5KH4CvVP0m1SaPNrbnYKQ-1
Received: by mail-wm1-f69.google.com with SMTP id b13so28362190wme.9
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KOx5qXk81Qd7N4vY5cKJ3mwX+W/O3uOUQmWWrUfoUNE=;
        b=idtu87BRpAalnjpfduPi9Q5rt04mHNU7XAYS8Qf9x9gFgyU6zq+fKi2BQO7OFgpEiR
         IwDec9s0u7514s2jyeu09F7zq4wWCVN6+GrQoiJKS71++BoRcnWsCD98kcn0Mm4GTjLN
         neknoh5vkL2Gi0BcFeastIrGXKAxjrxfIGwbK0MHkP4+non9M8DBRMQog8MVAFKX0nAa
         i8lYLFJTp952eQ8brxrna2Rd2d8lELPdez5q0YfVEBQxIyipOdwm8pAedfzOALPniuYV
         i4WofE/jCA8eL6fyfXklgKu4AtPuKpcZpv4yHyTYRn8rC9Yx4YLk5QpVweDPxA2lDOpU
         KTTA==
X-Gm-Message-State: AOAM533lWx17BGix0x+JWHhE25I17DzJiy+AQ/kLofNDCCquoiLsmnTk
        bRjesI3pii6R19S0N0VzOg7Wp3EryHIojW9R8QMxmIGItUSpb170EocCoxevqEHzrDEHmM+iyzF
        NaLNgwfyJ95afvZKT
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr31870682wmk.67.1593711154296;
        Thu, 02 Jul 2020 10:32:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+CsDY+21g1QTjt7MVvB6jTDuhnUVdNaUomSpR/gTM0a7j0FHvc+fI6bhKxizIyRbA1DAo6Q==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr31870671wmk.67.1593711154087;
        Thu, 02 Jul 2020 10:32:34 -0700 (PDT)
Received: from pc-2.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id i67sm9291800wma.12.2020.07.02.10.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:32:33 -0700 (PDT)
Date:   Thu, 2 Jul 2020 19:32:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200702173231.GA8376@pc-2.home>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702160221.GA3720@martin-VirtualBox>
 <20200702170353.GA7852@pc-2.home>
 <20200702171103.GA3949@martin-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702171103.GA3949@martin-VirtualBox>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 10:41:03PM +0530, Martin Varghese wrote:
> On Thu, Jul 02, 2020 at 07:03:53PM +0200, Guillaume Nault wrote:
> > On Thu, Jul 02, 2020 at 09:32:21PM +0530, Martin Varghese wrote:
> > > On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> > > 
> > > I couldnt apply the patch to master.Could you please confirm if it was rebased to the master
> > 
> > Hi Martin,
> > 
> > Yes, it's based on the latest iproute2 master branch.
> > I can apply it with "git am" without any problem.
> > 
> > Which command did you use?
> >
> git apply --check was failing.I assume my git remote repo is not correct.Could you please paste yours.

Here it is:
$ git remote -v
origin  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git (fetch)
origin  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git (push)

> I can do one round of testing and give you feedback

Nice, thanks!

