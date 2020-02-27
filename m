Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0125D1721D6
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgB0PJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:09:27 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:16449 "EHLO
        smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729468AbgB0PJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:09:27 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 10:09:27 EST
Received: from [87.123.206.167] (helo=kiste)
        by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <ndev@hwipl.net>)
        id 1j7KhE-0001jh-SV; Thu, 27 Feb 2020 16:03:28 +0100
Date:   Thu, 27 Feb 2020 16:03:28 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     ubraun@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RFC net-next] net/smc: update peer ID on device changes
Message-Id: <20200227160328.30726cdf8b639fc3512c9b18@hwipl.net>
In-Reply-To: <4c3b6802-7b27-73ec-f53c-ec1326aecb2b@linux.ibm.com>
References: <20200227113902.318060-1-ndev@hwipl.net>
        <b56d4bbc-2a4e-634f-10d4-17bd0253c033@linux.ibm.com>
        <20200227150946.60f12541f7541a64150afe2a@hwipl.net>
        <4c3b6802-7b27-73ec-f53c-ec1326aecb2b@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: bmRldkBod2lwbC5uZXQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 15:44:52 +0100
Karsten Graul <kgraul@linux.ibm.com> wrote:

> On 27/02/2020 15:09, Hans Wippel wrote:
> > On Thu, 27 Feb 2020 14:13:48 +0100
> > Karsten Graul <kgraul@linux.ibm.com> wrote:
> > 
> >> On 27/02/2020 12:39, Hans Wippel wrote:
> >>> From: hwipl <ndev@hwipl.net>
> >>>
> >>> A SMC host's peer ID contains the MAC address of the first active RoCE
> >>> device. However, if this device becomes inactive or is removed, the peer
> >>> ID is not updated. This patch adds peer ID updates on device changes.
> >>
> >> The peer ID is used to uniquely identify an SMC host and to check if there
> >> are already established link groups to the peer which can be reused.
> >> In failover scenarios RoCE devices can go down and get active again later,
> >> but this must not change the current peer ID of the host.  
> >> The part of the MAC address that is included in the peer ID is not used for
> >> other purposes than the identification of an SMC host.
> > 
> > Is it OK to keep the peer ID if, for example, the device is removed and
> > used in a different VM?
> > 
> > Hans
> > 
> 
> Yes, exactly this case is described in the RFC (instance id):
> 
> https://tools.ietf.org/html/rfc7609#page-93

OK, thanks for clarifying. I guess, you can ignore the RFC/patch then ;)
  Hans
