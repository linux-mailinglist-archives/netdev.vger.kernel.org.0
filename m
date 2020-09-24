Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6832775A0
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgIXPk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:40:56 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:32904 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728139AbgIXPk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q/o5cuCHNMfZCC5DXURaTMfkvGumctmEhF5/EQbiobo=; b=bcW/P9rAhkU6dQ/Y+qika/Jg25
        ECxp3eVyEuMkpAf9XsRDNWEZKhx3qRYj3Z2ZZZfQdIafBMGmLaBgbGOM/uKEXifVGoiqk4whfC9ld
        9XywUqHm1tgliViap8mdaLSrl2EjqaqPD88EO4NwYqd5j6nfohlGOq8xmMkwbAGlybc0=;
Received: from [94.26.108.4] (helo=carbon.lan)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kLTMC-0000QU-Sy; Thu, 24 Sep 2020 18:40:29 +0300
Date:   Thu, 24 Sep 2020 18:40:26 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, yuehaibing@huawei.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
Message-ID: <20200924154026.GA9761@carbon.lan>
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com>
 <1600856557.26851.6.camel@suse.com>
 <20200923144832.GA11151@karbon>
 <2f997848ed05c1f060125f7567f6bc3fae7410bb.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f997848ed05c1f060125f7567f6bc3fae7410bb.camel@suse.com>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-24 13:09:05, Oliver Neukum wrote: > Am Mittwoch,
   den 23.09.2020, 17:48 +0300 schrieb Petko Manolov: > > > One possible fix
   is to add yet another argument to usb_control_msg_recv(), > > which [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-24 13:09:05, Oliver Neukum wrote:
> Am Mittwoch, den 23.09.2020, 17:48 +0300 schrieb Petko Manolov:
> 
> > One possible fix is to add yet another argument to usb_control_msg_recv(), 
> > which would be the GFP_XYZ flag to pass on to kmemdup().  Up to Greg, of 
> > course.
> 
> submitted. The problem is those usages that are very hard to trace. I'd 
> dislike to just slab GFP_NOIO on them for no obvious reason.

Do you mean you submitted a patch for usb_control_msg_recv() (because i don't 
see it on linux-netdev) or i'm reading this all wrong?


		Petko
