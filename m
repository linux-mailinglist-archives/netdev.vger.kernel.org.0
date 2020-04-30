Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69151BFC89
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgD3OGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:06:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33910 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgD3OG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 10:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PXlo/7ChL9xoOJRVWUb4W1I2+tBnPJHTTREfZnpbS24=; b=WKMChgcKT5w8acv4YHU2+rHSRl
        xt1qXl/WaDmSdEZpqKTinTFecI4GUCwZZl7GrLUWh/JXq8lt80ZhDmF6KuRXrBfQotYBayDRiW0+G
        HGGEuZRWQ8FOlt9y1E48Os0tSvtjeViQV9zEPCmzX0ZuJQseu+fKGpDZeZndpyqoa1Jk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jU9pZ-000Ppk-Qo; Thu, 30 Apr 2020 16:06:25 +0200
Date:   Thu, 30 Apr 2020 16:06:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Allen <allen.pais@oracle.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Net: [DSA]: dsa-loop kernel panic
Message-ID: <20200430140625.GB76972@lunn.ch>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:54:15AM +0530, Allen wrote:
> Hi,
> 
>   We ran into a kernel panic with dsa-loop.
> Here are the details:
> 
> VM: aarch64 kvm running 5.7.0-rc3+

Hi Allen

Can you reproduce it? If so, could you do:

make net/core/dev.lst

and then show us the listing for __dev_set_rx_mode. The instructions
around 0x48/0xa0 will tell us what structure is a NULL pointer.

For this to work, it is important the build to create the .lst file is
the same as the build which fails. Changing the kernel configuration,
compiler flags etc can change 0x48/0xa0.

Thanks
	Andrew
