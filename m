Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554DE2945CE
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439369AbgJUAN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410711AbgJUAN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 20:13:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB6422242;
        Wed, 21 Oct 2020 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603239207;
        bh=S/pufml6Ni9xNVdl/QbGINdPsR9HTjj7F8KGcnTCoYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Go6rlJzLrgrGbq6S9GFUoFHqPlO0wzAoNIF8LoWswV+l6oCixwE1RFuviAniIO0NG
         SiEg44St3Ty0rPx/x2VzCzTt0sN4p5hZcxCyswE2lGUYS9uE1sfpssma/THahB0i8M
         RmDZaV1Xcnus3bXsliSV8VOLkxGlXmAOUv8loJe4=
Date:   Tue, 20 Oct 2020 17:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Defang Bo <bodefang@126.com>
Cc:     davem@davemloft.net, johan@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME
 attribute in nfc_genl_fw_download()
Message-ID: <20201020171325.1a576d52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1603107538-4744-1-git-send-email-bodefang@126.com>
References: <1603107538-4744-1-git-send-email-bodefang@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 19:38:58 +0800 Defang Bo wrote:
> check that the NFC_ATTR_FIRMWARE_NAME attributes are provided by the netlink client prior to accessing them.This prevents potential unhandled NULL pointer
> dereference exceptions which can be triggered by malicious user-mode programs, if they omit one or both of these attributes. Just similar to commit <a0323b979f81>("nfc: Ensure presence of required attributes in the activate_target handler").
> 
> Signed-off-by: Defang Bo <bodefang@126.com>

Applied, thanks.
