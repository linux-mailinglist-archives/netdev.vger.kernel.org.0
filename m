Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158FF22A2AF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgGVWun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVWun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 18:50:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D988E20674;
        Wed, 22 Jul 2020 22:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595458243;
        bh=ntzj5iP0vza+49y5xTgVc2SahS+nf0SLaipQXIH057M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ontJs+VdWh1IIoBWk3WPiUpUprv/0yVzZIjpvxV5CAoly0pYsWfsSy/B6gyIoL9DA
         UII9P+6/DDHLiUqvbdvR1UbJR/RZ6yrb5wfIXRkkZ4WJiDjBnHLqPYmMiPM4BUhDrS
         a1D+2WAr5+P2Em4rINHRTTwr9Gm4a/6NCYRiS48E=
Date:   Wed, 22 Jul 2020 15:50:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 4/8] igc: Fix registers definition
Message-ID: <20200722155041.19d56520@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722213150.383393-5-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
        <20200722213150.383393-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 14:31:46 -0700 Tony Nguyen wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> Fix double definition and remove unneeded registers.

I don't see any double definition here.
