Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C04426D41C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIQHD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:03:28 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:56520 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726310AbgIQHCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 03:02:44 -0400
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 03:02:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s/zX2WJfzeffLweLiV/sKRa73szTthE7Wojt7KGvJvU=; b=Und5kiPlLrhyocqNNJRZRUkA9c
        mFeRIkY4CoqHI267/+CGIrvervkM6JlPf4SVnTSshfS3uujtudWl/JD/txPrXTWV+WqNxEJIm0hMd
        XK64SaGsdt65TUOWgY63D69vlpq+KU81V4o3nMVi2pa5B15fFSel11h4o8W8gNeZYJH0=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kIncs-0006zN-Q0; Thu, 17 Sep 2020 09:42:39 +0300
Date:   Thu, 17 Sep 2020 09:42:39 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     David Bilsby <d.bilsby@virgin.net>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
Subject: Re: Re: Altera TSE driver not working in 100mbps mode
Message-ID: <20200917064239.GA40050@p310>
Mail-Followup-To: David Bilsby <d.bilsby@virgin.net>,
        Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-16 22:32:03, David Bilsby wrote: > Hi > > Would you
    consider making the PhyLink modifications to the Altera TSE driver > public
    as this would be very useful for a board we have which uses an [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-16 22:32:03, David Bilsby wrote:
> Hi
> 
> Would you consider making the PhyLink modifications to the Altera TSE driver 
> public as this would be very useful for a board we have which uses an SFP PHY 
> connected to the TSE core via I2C. Currently we are using a fibre SFP and 
> fixing the speed to 1G but would really like to be able to use a copper SFP 
> which needs to do negotiation.

Well, definitely yes.

The driver isn't 100% finished, but it mostly works.  One significant downside 
is the kernel version i had to port it to: 4.19.  IIRC there is API change so my 
current patches can't be applied to 5.x kernels.  Also, i could not finish the 
upstreaming as the customer device i worked on had to be returned.

However, given access to Altera TSE capable device (which i don't have atm), 
running a recent kernel, i'll gladly finish the upstreaming.


cheers,
Petko
