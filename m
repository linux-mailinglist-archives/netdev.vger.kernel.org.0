Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71A522A2AD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733008AbgGVWte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgGVWte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 18:49:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7040E2086A;
        Wed, 22 Jul 2020 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595458174;
        bh=pzfr3yy+vIcXc5smA+NQkeZhKw/1k4X+3fLO4qatMGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lR3NypUt9zVUhzMYaDg/lEBTy238C8Z3RCcKE9DRP4PzUbSw4CaEGBM/52jcV3FsK
         mWcXQ8nHUJ4ndcXyvbVcsO24vPNOJA6gukpMk7KjCpOApA6PA+bi/tUJpmx/zTOdra
         gY8j7Js/NbxbPl3U+6/28rN+mGWGfCMeGJflfV1w=
Date:   Wed, 22 Jul 2020 15:49:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 2/8] igc: Add Receive Descriptor Minimum Threshold
 Count
Message-ID: <20200722154930.61130b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722213150.383393-3-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
        <20200722213150.383393-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 14:31:44 -0700 Tony Nguyen wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> This register counts the number of events where the number of
> descriptors in one of the Rx queues was lower than the threshold
> defined for this queue.

Cool, why do you need to read / clear it, though?
