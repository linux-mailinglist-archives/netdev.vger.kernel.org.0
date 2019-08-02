Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322707EE18
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390495AbfHBHzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:55:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36861 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731067AbfHBHzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:55:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so76234335wrs.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 00:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iQeecZfwLuP7CODOolIpmoLPGZENj4z5U1obZlPPBsE=;
        b=XGvfS2DYXGr85CCUdgFDJRCzg8t9CfTsRdK6XQGadkT/SeDeqYDR1JUIONRuWWMR7U
         BOixBsovb4StvMzKLEo7PvGDoI+YWmiXmEEKVrIv3ajIk8nC+thY8Rof86WQgzuUljlw
         S0y4gaWJaly5Y/hS97gd0SOuRDM8oE5wqs2Ex+hIrQzvf/lG9G7DaB4ngMGSJlJfZMNL
         rby/j64KrsKNgPOAVLkGNQb4Zbv6GHfxsrifsb/f+Oux81X7VLCsnq6o4xF9bpiqNdY2
         3q4SYPPLaw3qCaSNm9L0z2N+lnmRdO8Mke07a0Oc9a0eXXigEHapvAecUCfTolnbe+Z5
         Of8A==
X-Gm-Message-State: APjAAAUh/XQAfKLDkxiARjugRwDzlhzCiu6EV7HW5WkGQNCmj3pC3z4y
        mAJxvTVc5nGgOIanDmmuWcfuGQ==
X-Google-Smtp-Source: APXvYqxJYMba81q1+ZjYpm8CUmRIMpGHEf3SB8tgLMove58CtJewiAKhbgEp6Gf/LDnWAQBR7N5n+w==
X-Received: by 2002:a05:6000:42:: with SMTP id k2mr23783548wrx.80.1564732511147;
        Fri, 02 Aug 2019 00:55:11 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id j9sm83739926wrn.81.2019.08.02.00.55.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 00:55:10 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:55:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] VSOCK: add vsock_test test suite
Message-ID: <20190802075508.tumpam2vfmynuhd5@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <PU1P153MB0169B265ECA51CB0AE1212DEBFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169B265ECA51CB0AE1212DEBFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 04:16:37PM +0000, Dexuan Cui wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > Sent: Thursday, August 1, 2019 8:26 AM
> > 
> > The vsock_diag.ko module already has a test suite but the core AF_VSOCK
> > functionality has no tests.  This patch series adds several test cases that
> > exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv,
> > connect/accept,
> > half-closed connections, simultaneous connections).
> > 
> > Dexuan: Do you think can be useful to test HyperV?
> 
> Hi Stefano,
> Thanks! This should be useful, though I have to write the Windows host side
> code to use the test program(s). :-)
> 

Oh, yeah, I thought so :-)

Let me know when you'll try to find out if there's a problem.

Thanks,
Stefano
