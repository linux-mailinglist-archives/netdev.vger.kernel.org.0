Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8862650D8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIJUbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgIJUbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:31:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6EA206E9;
        Thu, 10 Sep 2020 20:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599769860;
        bh=7lYML09NJIhF4amEUFSTp7nrcxK75B3+CJqmxANN14U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQI2toSw+bXD2I63/ENGJ4v+j2dIiqm1jYDEiZJZg5iyxNKI1JlPwA3k8yL7821NY
         dnt3Ug+M8kKNN3m0LiaGUna3EM3SxH5A53R/ON189nmr+l4DWyhHFpCqSEefwwTbVK
         lzmzHJFFdglaEXO0XBJhT6Z+kPPCtU6xmGaQgdBc=
Date:   Thu, 10 Sep 2020 13:30:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Message-ID: <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-13-oded.gabbay@gmail.com>
        <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
        <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 23:17:59 +0300 Oded Gabbay wrote:
> > Doesn't seem like this one shows any more information than can be
> > queried with ethtool, right?  
> correct, it just displays it in a format that is much more readable

You can cat /sys/class/net/$ifc/carrier if you want 0/1.

> > > nic_mac_loopback
> > > is to set a port to loopback mode and out of it. It's not really
> > > configuration but rather a mode change.  
> >
> > What is this loopback for? Testing?  
> 
> Correct.

Loopback test is commonly implemented via ethtool -t
