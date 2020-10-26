Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE544298E61
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780604AbgJZNq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1780592AbgJZNqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603719982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WggU8sJjnCU79ulx2Z4/7PxGM5JXxOuI+ThKBBhTjS8=;
        b=LI16Qy856mhQEWtcG83MzFIr7C8X4nPy6uQiaWSaYey4syJzphgkTMPADQ3/8Y826sOhR6
        trfEYVvJdIhz2rJBCTgfk1FMhidiNddriel5JukeBt/sXlBFjgTikUX7SQTNHPlYTYdDu8
        s89QeDxOg+Io5YmSKggafjdm4tMPyIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-FkmYrTPFMMmnKK7KhHhXMw-1; Mon, 26 Oct 2020 09:46:18 -0400
X-MC-Unique: FkmYrTPFMMmnKK7KhHhXMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72C58809DC2;
        Mon, 26 Oct 2020 13:46:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D568A5B4A4;
        Mon, 26 Oct 2020 13:46:13 +0000 (UTC)
Message-ID: <4e4dc63d0a0b5a820f7a70e30e29746fd6735a96.camel@redhat.com>
Subject: Re: [PATCH v9 3/4] docs: Add documentation for userspace client
 interface
From:   Dan Williams <dcbw@redhat.com>
To:     Jeffrey Hugo <jhugo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Date:   Mon, 26 Oct 2020 08:46:13 -0500
In-Reply-To: <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
         <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
         <20201025144627.65b2324e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-26 at 07:38 -0600, Jeffrey Hugo wrote:
> On 10/25/2020 3:46 PM, Jakub Kicinski wrote:
> > On Fri, 23 Oct 2020 16:17:54 -0700 Hemant Kumar wrote:
> > > +UCI driver enables userspace clients to communicate to external
> > > MHI devices
> > > +like modem and WLAN. UCI driver probe creates standard character
> > > device file
> > > +nodes for userspace clients to perform open, read, write, poll
> > > and release file
> > > +operations.
> > 
> > What's the user space that talks to this?
> > 
> 
> Multiple.
> 
> Each channel has a different purpose.  There it is expected that a 
> different userspace application would be using it.
> 
> Hemant implemented the loopback channel, which is a simple channel
> that 
> just sends you back anything you send it.  Typically this is consumed
> by 
> a test application.
> 
> Diag is a typical channel to be consumed by userspace.  This is
> consumed 
> by various applications that talk to the remote device for
> diagnostic 
> information (logs and such).

QMI too?
Dan

> Sahara is another common channel that is usually used for the
> multistage 
> firmware loading process.
> 

