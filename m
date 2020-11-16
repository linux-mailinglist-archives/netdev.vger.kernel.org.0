Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368ED2B543D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgKPWXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgKPWXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:23:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74EA72080A;
        Mon, 16 Nov 2020 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605565393;
        bh=wt0Mt8tXKjGqg3jDSuDHgTu4UVq6bc3rtB6Y2LtbkRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EVcMTXfoveVLa8OnOVUD5KNkoe12R/EvNrcI5nnkOsoqfsZhyYasH6C5s6hBSW8Mg
         9l0y1SAVnj1rfxrrlPgTEbVu8/x/D9oVIg8fLbLipWV9IG1jR8zmfkXyR0qenooAeZ
         gf5rCigBba3NeGJY5CAa/+EMI5F0M/QA1gYyIiI8=
Date:   Mon, 16 Nov 2020 14:23:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
Message-ID: <20201116142312.661786bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 08:39:58 +0200 Parav Pandit wrote:
> FAQs:
> -----
> 1. Where does userspace vdpa tool reside which users can use?
> Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user to
> create vdpa net devices.
> 
> 2. Why not create and delete vdpa device using sysfs/configfs?
> Ans:

> 3. Why not use ioctl() interface?

Obviously I'm gonna ask you - why can't you use devlink?

> Next steps:
> -----------
> (a) Post this patchset and iproute2/vdpa inclusion, remaining two drivers
> will be coverted to support vdpa tool instead of creating unmanaged default
> device on driver load.
> (b) More net specific parameters such as mac, mtu will be added.

How does MAC and MTU belong in this new VDPA thing?
