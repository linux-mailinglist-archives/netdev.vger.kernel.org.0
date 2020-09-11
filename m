Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F55E2675C2
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIKWQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgIKWQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:16:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F2021D7E;
        Fri, 11 Sep 2020 22:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599862563;
        bh=gwgvoL1ltfNlDqSVDatly48d4XGe9Ljq55CRe0Bpqng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=liEq1zumY4avXYacWnhCeKdg33nS4eS4+eyin5aDtr7cQkGyVm9FJjy1St88Wts5w
         imhCdRMr5hzIBptbVIGBtWPLe0wjVRpAQLSxAhOp9OUly1PNyXYFeTpMTdqo5l5shS
         cO3B73lbBsoaXjSkkfun3UMyrZcQC166luhIE+vs=
Date:   Fri, 11 Sep 2020 15:16:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1
 clean
Message-ID: <20200911151601.3207ed80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911143405.00004085@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200911120005.00000178@intel.com>
        <20200911131238.1069129c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200911143405.00004085@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 14:34:05 -0700 Jesse Brandeburg wrote:
> If I'm not mistaken *all* the warnings you had listed are from C=1
> (sparse) which would be best fixed with a second set of patches. This
> set of patches only aimed to get rid of the W=1 (gcc warnings and kdoc
> warnings from scripts/kernel-doc)

Oh damn, you're right. I got fooled by my own logs :/
