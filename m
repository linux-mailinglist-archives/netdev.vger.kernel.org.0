Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B345D186541
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgCPGwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgCPGwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:52:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D901520679;
        Mon, 16 Mar 2020 06:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584341535;
        bh=X5bQn4IVpKW+jaQ7//7EYRg3Xv3REkaw4rtY4LeA2ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZjyWAg4EvhbNZaoow1OWL5xdl29/Y+ut288fPzWB00DLaJzBsxIwo/DStcoTCxBt
         TBltYx/G3jifhZoJU1H+Vvxl4rlRe4x5Zk3bRMpDD+7oRPTLX8LKSKIhqf6ms6qXtG
         enfa4NITTIp7TAzapzuVVd2RbAgvnpegbV14cHsE=
Date:   Mon, 16 Mar 2020 08:52:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 3/5] ionic: remove adminq napi instance
Message-ID: <20200316065212.GC8510@unreal>
References: <20200316021428.48919-1-snelson@pensando.io>
 <20200316021428.48919-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316021428.48919-4-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 07:14:26PM -0700, Shannon Nelson wrote:
> Remove the adminq's napi struct when tearing down
> the adminq.
>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
>  1 file changed, 1 insertion(+)
>

It looks like a fix to me, and I would expect Fixes line here.

Thanks
