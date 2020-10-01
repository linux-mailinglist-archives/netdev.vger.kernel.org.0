Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAAF27F99E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgJAGmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:42:43 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:60866 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725894AbgJAGmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V6RHpntufxYXFGkogn/CnuCRtYCiC7ukQLfufF/rYuw=; b=aJPBcOm8TRpsJ7eFMn4tuP5PPK
        OoM1hHoUvN9R93Yb7VjQCjZBsQTUZ/Pp3T+oQIqL/fl+qjDtDYUsZlYEnFf55yvL9UpaJx36n22e3
        viiAsoVGvwAfRDvWFOLGDhVKd2s1i0+DCv0JyXH6boJHj/RAP+rSRBFOCZO7zrD/FJig=;
Received: from [94.26.108.4] (helo=carbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kNsIX-00055v-M5; Thu, 01 Oct 2020 09:42:37 +0300
Date:   Thu, 1 Oct 2020 09:42:36 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Bilsby <d.bilsby@virgin.net>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Altera TSE driver not working in 100mbps mode
Message-ID: <20201001064236.GB8609@carbon>
Mail-Followup-To: Andrew Lunn <andrew@lunn.ch>,
        David Bilsby <d.bilsby@virgin.net>,
        Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
 <20200918171440.GA1538@p310>
 <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
 <20200930235925.GB3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930235925.GB3996795@lunn.ch>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-10-01 01:59:25, Andrew Lunn wrote: > > The subject of
    this email thread is: > > Altera TSE driver not working in 100mbps mode >
    > Are you doing your testing at 1G or 100Mbps? I would suggest sta [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-01 01:59:25, Andrew Lunn wrote:
> 
> The subject of this email thread is:
> 
> Altera TSE driver not working in 100mbps mode
> 
> Are you doing your testing at 1G or 100Mbps? I would suggest starting out at 
> 1G if you can.

Well, this is the subject i used some time ago.  It is related to a particular 
issue and, as it turned out, now with the driver but the implementation on the 
FPGA.


		Petko
