Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8CB1975BE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgC3Hcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgC3Hcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:32:41 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DD52073B;
        Mon, 30 Mar 2020 07:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585553560;
        bh=W+agBPzyd2I49/xNbzN+c8dRPEWwbZfoX9Wg0IRRzqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GV6vzCViSlJZdnMCdUoqV+zNmVM6VvWiLBC9Tv8YfwA5FJuwn/ZHK/n0uBrf9sWvI
         vsWLjRzBY0VK4xkWJMMsTxkw9NkYSf/Xd5xMWLVEz/r5IcDzupLx99ec4YtKBXZnLN
         fj5q/48UBwtUtrwN+dd+wQh1j1ZJIWD55XVFaNBw=
Date:   Mon, 30 Mar 2020 10:32:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, jhasan@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 8/8] qedf: Update the driver version to 8.42.3.5.
Message-ID: <20200330073237.GI2454444@unreal>
References: <20200330063034.27309-1-skashyap@marvell.com>
 <20200330063034.27309-9-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330063034.27309-9-skashyap@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 11:30:34PM -0700, Saurav Kashyap wrote:
> - Update version to 8.42.3.5.
>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> ---
>  drivers/scsi/qedf/qedf_version.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

NAK, please delete this version and not update.

For rationale, take a look here.
https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/

Thanks
