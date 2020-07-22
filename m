Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E121822A297
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733058AbgGVWsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVWsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 18:48:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892FC2086A;
        Wed, 22 Jul 2020 22:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595458097;
        bh=ILst9PBcjCr1ozRTlxOFiP4krUKu0hwIyJ2VCnVCYtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=COHRBVRoB30Nffxtnqzzw09S4M8NTb8svf5gOFEtQ597b0xjiDNXsEfVOJ1j+ogYH
         AAsziVyhzY0JspXhlPkaIdVS6DImtZN3y94yZBBzMgkrSKN9lGmvDkl1E3yq/GSo52
         nPe7zBLEYcw1iKNia9d6T0H+X/RjNNWCtD7KOYBw=
Date:   Wed, 22 Jul 2020 15:48:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 1/8] igc: Fix double definition
Message-ID: <20200722154814.184521de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722213150.383393-2-anthony.l.nguyen@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
        <20200722213150.383393-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 14:31:43 -0700 Tony Nguyen wrote:
> Accordance to the i225 specification address 0x4118 used for
> Host Good Packet Transmitted Count and defined as read on clear.
> IGC_ICTXQEC not in use and could be removed.

Not entirely sure what this commit message is trying to communicate.

Also it'd had been better if you removed the member of hw_stats
structure in the same commit.
