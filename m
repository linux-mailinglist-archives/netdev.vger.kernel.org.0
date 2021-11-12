Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1144DFFB
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhKLBxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhKLBxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 20:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DC0B6103A;
        Fri, 12 Nov 2021 01:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636681833;
        bh=BIHcLTzaRtNAXz+qvfUTOyZZ233jGsfuSnUE9AYSWXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ryZejMKQZ4RMaHBNoEI9lAgdkoyB7mc8sKRKg/QgMFTfZRve5BMHp0HJIHQQxgQi8
         4eFPso1U/lr/CK9iE7Y9bR5/gpvpepbxctET8kJyA97aZ6PtnkKsiaKTBXXLo9/+F4
         w7xzDM0Ufjo9AOzi7lkdKY9ZdqFgRbGxe/NryghQbsOI2vJpZyonPzG6x6tzUPbmCK
         E+ecC9Cw6yr5xeVADSj8Pl/UGPpOIVv5D/R/SbnG8YHq4mdYkFnh66sTVlG/YAN1MH
         uaW8ekuRC/2E441lJacIxQRPBGaAexVt98VXT89RZIVb+2KEEGEB/bOgV0KMEn+gn6
         hDR67fvrmwX/A==
Date:   Thu, 11 Nov 2021 17:50:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
Message-ID: <20211111175032.14999302@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
        <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 09:40:47 +0800 Menglong Dong wrote:
> > I feel like I have seen this idea before. Is this your first posting?
> >
> > Would you mind including links to previous discussion if you're aware
> > of any?  
> 
> This is the first time that I post this patch. Do you mean that someone
> else has done this before? Sorry, I didn't find it~

I see. Yes, I believe very similar changes were proposed in the past.

I believe that concerns about the performance impact had prevented them
from being merged.
