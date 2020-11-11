Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0632AF71F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgKKRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgKKRD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:03:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D7EE2072C;
        Wed, 11 Nov 2020 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605114237;
        bh=o12g28KmO/HU+FIZtj5lmzMlK87daTVBlxDLOIJODsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qBVf1mqqhwbukA0xxVS2fRfo6ZuStYbGjCLyEPDlxTpfLkOyZEG8oNCvw6EYjFfm5
         h7Fc4n9cPXzxiqpzWSOH68RwMRpF7Q5jYanbitXggDyZcXSSfC8Mx7ztfg7XLOEErJ
         ov5Z3+EyXqGWexoYdGDb39aWtgau3djnThIhKW4g=
Date:   Wed, 11 Nov 2020 09:03:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] IB/hfi1: switch to core handling of rx/tx
 byte/packet counters
Message-ID: <20201111090355.63fe3898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5093239e-2d3b-a716-3039-790abdb7a5ba@gmail.com>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
        <5093239e-2d3b-a716-3039-790abdb7a5ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 20:47:34 +0100 Heiner Kallweit wrote:
> Use netdev->tstats instead of a member of hfi1_ipoib_dev_priv for storing
> a pointer to the per-cpu counters. This allows us to use core
> functionality for statistics handling.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

RDMA folks, ack for merging via net-next?
