Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866BD281517
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbgJBO3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:29:20 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:33252 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726017AbgJBO3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U+46LdM6PcDOkzQb5JDU0b6k7u6FWkT7DMAIIJ4jYqA=; b=Aw5vGkll/h+gwLv9n0jja96gT1
        UJ6NwKXEuQQ6w0Ti7GrZtrtXb0iz7YGLmNe5yGAE5k02mxXqk7/7yThcWdcr84YLZOEA9KrnSLNUK
        DJLZtGNWhcvs+hgMbWiznzrw3tztBR+nHzb8+0Qrt7yTmkwFPbVaSfa6Bz1BP7kUIbJ4=;
Received: from [94.26.108.4] (helo=carbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kOM3S-00015G-U7; Fri, 02 Oct 2020 17:29:03 +0300
Date:   Fri, 2 Oct 2020 17:29:01 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
Message-ID: <20201002142901.GA3901@carbon>
Mail-Followup-To: Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
 <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
 <20201002115453.GA3338729@kroah.com>
 <a19aa514-14a9-8c92-d41a-0b9e17daa8e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a19aa514-14a9-8c92-d41a-0b9e17daa8e3@gmail.com>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-10-02 17:35:25, Anant Thazhemadam wrote: > > Yes, this
    clears things up for me. I'll see to it that this gets done in a v3. If set_ethernet_addr()
    fail, don't return error, but use eth_hw_addr_random() instead to set random
    MAC address and continue with the probing. 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-02 17:35:25, Anant Thazhemadam wrote:
> 
> Yes, this clears things up for me. I'll see to it that this gets done in a v3.

If set_ethernet_addr() fail, don't return error, but use eth_hw_addr_random() 
instead to set random MAC address and continue with the probing.

You can take a look here:
https://lore.kernel.org/netdev/20201002075604.44335-1-petko.manolov@konsulko.com/


cheers,
Petko
