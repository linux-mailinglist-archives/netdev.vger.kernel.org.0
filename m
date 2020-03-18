Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3618A399
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCRUPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgCRUPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:15:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BAE520752;
        Wed, 18 Mar 2020 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584562523;
        bh=+rIapVGC/kKpY69+060nK0REWuvz58lkwTQP/NBoQ/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S06kWRXux66DHUfQkB8JlBCDogSMSnG7Zg83qDU7xtn1xi50dB8oJpM1+NfNi5xzZ
         PLvypmOkaDe58dc+X9iAX/hBQIKN7zqBGCeNHFmLWyMm3rt4cdAlvkoj/CrcTO7E/8
         pGW2Jbn13GUCTYmFnRofrA6N5mP7L79uGX92ZrJM=
Date:   Wed, 18 Mar 2020 13:15:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 09/11] devlink: Add new enable_ecn generic
 device param
Message-ID: <20200318131521.7f3634a6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CALs4sv0Y5bw85bh9=6T2EmwGKqJvjNr-ptw8Kovyp7Bb6mHDDA@mail.gmail.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458246-29370-3-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200317105220.3ae07cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALs4sv0Y5bw85bh9=6T2EmwGKqJvjNr-ptw8Kovyp7Bb6mHDDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 10:56:52 +0530 Pavan Chebbi wrote:
> On Tue, Mar 17, 2020 at 11:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 17 Mar 2020 20:47:24 +0530 Vasundhara Volam wrote:  
> > > From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > >
> > > Add new device parameter to enable/disable handling of Explicit
> > > Congestion Notification(ECN) in the device.
> > >
> > > This patch also addresses comments from Jiri Pirko, to update the
> > > devlink-info.rst documentation.
> > >
> > > Cc: Jiri Pirko <jiri@mellanox.com>
> > > Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>  
> >
> > Nacked-by: Jakub Kicinski <kuba@kernel.org>
> >
> > We've been over this multiple times. Devlink is not for configuring
> > forwarding features. Use qdisc offload.  
> 
> This is just a config option like enable_sriov and enable_roce.
> This will only enable the capability in the device and not configure any rules.

Not what the documentation added by the patch says. But I'm sure the
reality^W documentation can be bent as needed.

If you really "just enable the capability like SR-IOV", please come
back with this patch once you implement an API to make use of such
capability.
