Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C60B27E11A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgI3Gbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:31:51 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44917 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgI3Gbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:31:51 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 02:31:51 EDT
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 9C5CDE95;
        Wed, 30 Sep 2020 02:23:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 30 Sep 2020 02:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EHftFM
        ttCpevAcDvlJQU/s7jFGAiMjupSu6QGUp2usc=; b=fXal1ix1NqTVsB1yPdjazN
        by+INGGTWhY+ritILNNE7YDYTRXMnAjBmhIx4KSRAJNMAJtEuAdjUOAldptvqh2B
        m2EDPe2GKUuUcWKUwdgeK6LSUEJcsKq3IOZ0Wmk/3dOtC3MxHRD2ZnxuV/TGNPdM
        l6crtZdWFQzY0D2iFvZ+8nJjzt090tVW6P9feYLG1MWIef9e/JNPhOUAW+gf5EA7
        92J4SqMV2S7kZd+CftM0YbdNyrGIYLspa2p7dzrpPacG5XtZZqsP+hqaEDigEjJ2
        yZE2N04qv4bqBx5DXvJbFZh/tujX/+6y2ABRefawUEq5qENkpoAimxANXaK5bzVQ
        ==
X-ME-Sender: <xms:UCR0X6dGs60u6VYtzvF6e3UvNTvrfANok6NJ0y15JqTHFdbqFXsibQ>
    <xme:UCR0X0M7uUIrbFJv88DyrUchpS-ECRDI0PGEaUAG-01JiU256Fs8Xl72G1tOdsUnH
    pb8l5CXPTZCcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedtgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgmffjsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtf
    frrghtthgvrhhnpeetvdelgeffgfdutdelvddvtdetffejtefgveevueeggfellefhveev
    feduueduvdenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:USR0X7jFQIe9WCr7rhi2uxpefeSMjbUOFxfCvMdNrdDqCHKECzxq_g>
    <xmx:USR0X3_ruuKWPpLjMSRVrh0wHYKgHkmr_J67xORHKP4D-l-6dLUOIw>
    <xmx:USR0X2sjgvD3Jo0Z23BeUxSv6cRMcGdURHqKmkeh3IMykr7XrXLRVw>
    <xmx:USR0X7VHDljqCNaYkqfbGEL1bXW3NwfW61IGnme1ey9ha8Y8Tj2VVuDldxI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 957BA3280060;
        Wed, 30 Sep 2020 02:23:12 -0400 (EDT)
Date:   Wed, 30 Sep 2020 08:23:15 +0200
From:   Greg KH <gregKH@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     petko.manolov@konsulko.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/2] Use the new usb control message API.
Message-ID: <20200930062315.GB1471881@kroah.com>
References: <20200927124909.16380-1-petko.manolov@konsulko.com>
 <20200928.160058.501175525907482710.davem@davemloft.net>
 <20200929045911.GA4393@carbon>
 <20200929.125849.710595543531143236.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929.125849.710595543531143236.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 12:58:49PM -0700, David Miller wrote:
> From: Petko Manolov <petko.manolov@konsulko.com>
> Date: Tue, 29 Sep 2020 07:59:11 +0300
> 
> > On 20-09-28 16:00:58, David Miller wrote:
> >> From: Petko Manolov <petko.manolov@konsulko.com> Date: Sun, 27 Sep 2020 
> >> 15:49:07 +0300
> >> 
> >> > Re-sending these, now CC-ing the folks at linux-netdev.
> >> 
> >> I can't apply these since the helpers do not exist in the networking tree.
> > 
> > Right, Greg was only asking for ack (or nack) from your side.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks!
