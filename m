Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45925CE3E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgICXWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgICXWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 19:22:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B2A2078E;
        Thu,  3 Sep 2020 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599175342;
        bh=M6g66WpLTMQTNAb9mC0cMfugcxarhyhUGBx2mYsX5gY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nKO5YObpRBUGqmS06dQf7SX6B+MLDYn8/rX2w8hM2wQV/Nxjvwy+LQ2UTdO3SLuSH
         P2KLptug1WkJ6zbCtI876MrM6x8iI+Bbp7nVSXTuOXaj12zc334T7LvVmzZRHYJqgs
         03AoR7n3fjx1uGPbGpl+pq5t8HUaOl1k20+hDSt8=
Date:   Thu, 3 Sep 2020 16:22:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
Message-ID: <20200903162220.061570d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bfa03cf8613ada508774a2e6e89b9b01bfd968dd.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
        <1af4aea7869bdb9f3991536b6449521b214ed103.camel@intel.com>
        <bfa03cf8613ada508774a2e6e89b9b01bfd968dd.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 20:06:15 +0000 Nguyen, Anthony L wrote:
> On Wed, 2020-07-22 at 14:22 -0700, Tony Nguyen wrote:
> > On Tue, 2020-07-21 at 18:27 -0700, Jakub Kicinski wrote:  
> > > This set converts Intel drivers which have the ability to spawn
> > > multiple netdevs, but have only one UDP tunnel port table.
> > > 
> > > Appropriate support is added to the core infra in patch 1,
> > > followed by netdevsim support and a selftest.
> > > 
> > > The table sharing works by core attaching the same table
> > > structure to all devices sharing the table. This means the
> > > reference count has to accommodate potentially large values.
> > > 
> > > Once core is ready i40e and ice are converted. These are
> > > complex drivers, and I don't have HW to test so please
> > > review..  
> > 
> > I'm requesting our developers to take a look over and validation to
> > test the ice and i40e patches. I will report back when I get results.  
> 
> Would you mind if I pick these patches up into Jeff's tree? It will
> make it easier to test that way.

It's been a month. Any ETA on these?
