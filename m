Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9CA13AB5B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgANNpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:45:55 -0500
Received: from mx3.wp.pl ([212.77.101.9]:20243 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgANNpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 08:45:55 -0500
Received: (wp-smtpd smtp.wp.pl 30180 invoked from network); 14 Jan 2020 14:45:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1579009550; bh=1OCCshn/NahZBP1gvKTaGqss5mpmUoD2DAPD0KfhKvo=;
          h=From:To:Cc:Subject;
          b=B/JnFwJP0YTQ5MWEM8Xjp9XJbCCGcxPqRvYh6grlUxxIwM/8vzqBbR2XVnHyR3gRg
           Y7GFZFp2v/91NdDqQ+NgP+hZkA+uiATwvzF3lnKuecSMTZpZ1BiNen91iCBN1Dv10A
           awohaKHajJnNbkae8aglEM90VbUWmAxTdmPY7Yak=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba.hsd1.ca.comcast.net) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ms@dev.tdt.de>; 14 Jan 2020 14:45:50 +0100
Date:   Tue, 14 Jan 2020 05:45:43 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     khc@pm.waw.pl, davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
Message-ID: <20200114054543.576dbf8b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <3b439730f93e29c9e823126b74c2fbd3@dev.tdt.de>
References: <20200113124551.2570-1-ms@dev.tdt.de>
        <20200113055316.4e811276@cakuba>
        <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
        <20200114045149.4e97f0ac@cakuba>
        <3b439730f93e29c9e823126b74c2fbd3@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 7066841284ff01c5adb105bd79b4273d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [AXPU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 14:33:51 +0100, Martin Schiller wrote:
> On 2020-01-14 13:51, Jakub Kicinski wrote:
> > On Tue, 14 Jan 2020 06:37:03 +0100, Martin Schiller wrote:  
> >> >> diff --git a/include/uapi/linux/hdlc/ioctl.h
> >> >> b/include/uapi/linux/hdlc/ioctl.h
> >> >> index 0fe4238e8246..3656ce8b8af0 100644
> >> >> --- a/include/uapi/linux/hdlc/ioctl.h
> >> >> +++ b/include/uapi/linux/hdlc/ioctl.h
> >> >> @@ -3,7 +3,7 @@
> >> >>  #define __HDLC_IOCTL_H__
> >> >>
> >> >>
> >> >> -#define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc
> >> >> utility */
> >> >> +#define GENERIC_HDLC_VERSION 5	/* For synchronization with sethdlc
> >> >> utility */  
> >> >
> >> > What's the backward compatibility story in this code?  
> >> 
> >> Well, I thought I have to increment the version to keep the kernel 
> >> code
> >> and the sethdlc utility in sync (like the comment says).  
> > 
> > Perhaps I chose the wrong place for asking this question, IOCTL code
> > was my real worry. I don't think this version number is validated so
> > I think bumping it shouldn't break anything?  
> 
> sethdlc validates the GENERIC_HDLC_VERSION at compile time.
>
> https://mirrors.edge.kernel.org/pub/linux/utils/net/hdlc/

Aw, okay, best not to bump it then.
 
> Another question:
> Where do I have to send my patch for sethdlc to?

No idea :)
