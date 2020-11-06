Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE02A8B8F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732729AbgKFAsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgKFAsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:48:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D288C20759;
        Fri,  6 Nov 2020 00:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604623700;
        bh=8ZKMemjQaZrVDXJ+GEc5yuImk/sUlH2LhpKxpC4gZ3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BoJvBXbqH5HMyku9D2mkRnFMhM0DgQolpeSuMjVU/zBxhriUkDtZX8QsftqpLb+BL
         KY5Fs74nyCEf7b3/jSEPBqEFIVD2zSR1DuSjvTcBLVlCqY+OheXQSbbkIQNLbxY/Is
         Jyeun3cJsgFvf2QuYoatKaDr16DVubfYhDC5nW+4=
Date:   Thu, 5 Nov 2020 16:48:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     steffen.klassert@secunet.com
Cc:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net,
        gerrit@erg.abdn.ac.uk, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, johannes@sipsolutions.net,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [net-next v4 8/8] net: xfrm: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201105164818.402a2cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103091823.586717-9-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
        <20201103091823.586717-9-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 14:48:23 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Steffen - ack for applying this to net-next?
