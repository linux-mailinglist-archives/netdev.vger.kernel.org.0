Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5590042D4D4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhJNI3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:29:20 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:56432 "EHLO
        zzt.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230010AbhJNI3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:29:19 -0400
X-Greylist: delayed 2620 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2021 04:29:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G8tLTOnFkmRAM+oUj3dNWt6f4vGVVLmMCR/9dAWETRs=; b=D0sh/Puk5uVfIR23VQ7pN7qhbK
        f5ktTCor+jo89CFslyZoicRLwbjQs001DFWdQ9HgljO8dhXe/5RG2eS3AGFBeAAwEkU5jGyy+iUv8
        tyDQ3DRLbmVNofmiZ2Grm33BCuzjusFCPhnQD4QBhOaArA+LsmnW2YPfxv3RAQr0OIKs=;
Received: from rtr.k.g ([192.168.234.1] helo=p310.k.g)
        by zzt.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1mavOX-001Xij-26; Thu, 14 Oct 2021 10:43:17 +0300
Date:   Thu, 14 Oct 2021 10:43:16 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        f.fainelli@gmail.com, christophe.jaillet@wanadoo.fr,
        zhangchangzhong@huawei.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] ethernet: manually convert
 memcpy(dev_addr,..., sizeof(addr))
Message-ID: <YWfflLK+PQg7upLU@p310.k.g>
References: <20211013204435.322561-1-kuba@kernel.org>
 <20211013204435.322561-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013204435.322561-5-kuba@kernel.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zzt.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-10-13 13:44:32, Jakub Kicinski wrote: > A handful of
    drivers use sizeof(addr) for the size of > the address, after manually confirming
    the size is > indeed 6 convert them to eth_hw_addr_set(). > [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-10-13 13:44:32, Jakub Kicinski wrote:
> A handful of drivers use sizeof(addr) for the size of
> the address, after manually confirming the size is
> indeed 6 convert them to eth_hw_addr_set().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: nicolas.ferre@microchip.com
> CC: claudiu.beznea@microchip.com
> CC: f.fainelli@gmail.com
> CC: petkan@nucleusys.com
> CC: christophe.jaillet@wanadoo.fr
> CC: zhangchangzhong@huawei.com
> CC: linux-usb@vger.kernel.org
> ---

>  drivers/net/usb/pegasus.c                | 2 +-

Acked-by: Petko Manolov <petkan@nucleusys.com>
