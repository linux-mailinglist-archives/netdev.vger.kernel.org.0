Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ED82B8147
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgKRPzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgKRPzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 10:55:36 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1A9247B3;
        Wed, 18 Nov 2020 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605714936;
        bh=r0CDRoFkB8BgLEPaa2ssyralnP0p6N+L5jBhaOttndg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S9JnTs5f0QJFKzgr4+uG12DR9Qr/gWbsLxpvqU4dEzKQl32h8l4FGCWOQCE4rgoiY
         M8MH8Yy0aAw5aULGjQx4lSGrYy9xH1+s+58XL2ZZN+MtkBVsFpsHa1hSk7CO0Jhfnb
         O/q7DH9DjQa741gdG0QQFw9Wf1hDnUMCWBHyuyFg=
Date:   Wed, 18 Nov 2020 07:55:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
Message-ID: <20201118075534.2a5e63c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87d00b5uj7.fsf@intel.com>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
        <874klo7pwp.fsf@intel.com>
        <20201117014926.GA26272@hoboy.vegasvil.org>
        <87d00b5uj7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 17:21:48 -0800 Vinicius Costa Gomes wrote:
> > Also, what is the point of providing time measurements every 1
> > millisecond?  
> 
> I sincerely have no idea. I had no power on how the hardware was
> designed, and how PTM was implemented in HW.

Is the PTMed latency not dependent on how busy the bus is?
That'd make 1ms more reasonable.
