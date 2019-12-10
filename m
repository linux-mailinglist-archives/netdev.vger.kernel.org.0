Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8DD118EE0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfLJRWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:22:36 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35200 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfLJRWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:22:36 -0500
Received: by mail-oi1-f194.google.com with SMTP id k196so10553742oib.2
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+yXS1qMqBQgYNWoie6aez+kq4hBmW6bci2Vzcn52mDU=;
        b=n3myC2TiVG4k/XZaOe+3WrOokgsqMo+ejKQ1Gof/FryawAQcojQ9xlSLSfOVPrTGyT
         JeEoP3M/NOzo/nt9DOs0Es/bi82NDOH+rjNZW7tOjwF+Ecdgnf0ylNC3L2fecxsvaMLS
         jVzASl3DLL86yIURm1S+OruWqXJ7Scu/dx0cZG1YshxkGzEy4c5YbAoT0UH7RbPuaR+r
         nRY4b8HIW9ABLAbw8VXl0ebEeZ6ZEXZSDM8t4gVJdKin4vuKg1gW09Q/rDMEgurrZFfr
         UYsCHv+BQsmHKdZCubIglZ6Dx3fqjBGwsRK8VtDPVAzEFW44c2wYbbCKr0zKRXEvVJqt
         fQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+yXS1qMqBQgYNWoie6aez+kq4hBmW6bci2Vzcn52mDU=;
        b=fsc0zg1wLX/j1GjmKZJndCyNJU3W0elnhXtVJOoV7BM3WPCtWHYYOzj5kNhweRjzLD
         VW/TK13Gqam3ECmXVEMR1pPnGIUO7pQPAotNVY/XSYSlt/PaCLssXjtCRH7yNK12xywO
         QCP5cuaF24Ax/92P9bfX9eSw/4DcQMBPesHnfC4GPmELffqJFuxDaHNvHtMlkUOcwzbc
         iEt2PCulC9iCOeCsFqf5fOEGxOv0Uxeh596rRQJrQkaFxstdfm0QvtRTI35j+LSA49Xf
         ds0D70u/oyW/x8gn2ujyu4d+TmouUAm5SihrMIL0jKPvx/DGIQGRnrrmHyOL6ap/Dvq7
         iyxQ==
X-Gm-Message-State: APjAAAVcASNoFFzvNlyJCWvPN137gK+MsnS5vDT7R1pTg6lbRl4MCFKX
        pUqHobonZrzbRYqv6RFXHCKX8A==
X-Google-Smtp-Source: APXvYqzhYtCBUztj+R5JygBJ57q/e4L0cYCUZRTereZX4deELFDYjhTZ0Jf5pObGnLqqXLToJ06w1g==
X-Received: by 2002:aca:50cd:: with SMTP id e196mr4954490oib.178.1575998555399;
        Tue, 10 Dec 2019 09:22:35 -0800 (PST)
Received: from ziepe.ca ([217.140.111.136])
        by smtp.gmail.com with ESMTPSA id g203sm1588884oib.17.2019.12.10.09.22.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 09:22:34 -0800 (PST)
Received: from jgg by LT-JGG-7470.mtl.com with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iejDW-000013-0n; Tue, 10 Dec 2019 13:22:34 -0400
Date:   Tue, 10 Dec 2019 13:22:33 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver Updates
 2019-12-09
Message-ID: <20191210172233.GA46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:15PM -0800, Jeff Kirsher wrote:
> This series contains the initial implementation of the Virtual Bus,
> virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus and the new RDMA driver 'irdma' for use with 'ice' and 'i40e'.
> 
> The primary purpose of the Virtual bus is to provide a matching service
> and to pass the data pointer contained in the virtbus_device to the
> virtbus_driver during its probe call.  This will allow two separate
> kernel objects to match up and start communication.
> 
> The last 16 patches of the series adds a unified Intel Ethernet Protocol
> driver for RDMA that supports a new network device E810 (iWARP and
> RoCEv2 capable) and the existing X722 iWARP device.  The driver
> architecture provides the extensibility for future generations of Intel
> hardware supporting RDMA.
> 
> The 'irdma' driver replaces the legacy X722 driver i40iw and extends the
> ABI already defined for i40iw.  It is backward compatible with legacy
> X722 rdma-core provider (libi40iw).

Please don't send new RDMA drivers in pull requests to net. This
driver is completely unreviewed at this point.

Jason
