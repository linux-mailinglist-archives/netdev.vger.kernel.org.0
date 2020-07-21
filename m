Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DAE227386
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgGUAOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgGUAOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 20:14:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BAA522B4E;
        Tue, 21 Jul 2020 00:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595290453;
        bh=Zsaf1p34VPDUzklxBS9m0ZKNXuHj/aQsXJxpl5A1/Zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lwiER5QJwYsvyrvywi8lk3FhmzxvI1M4H2jMyEQWi6b2jBUEG1FcQPqPKPx9A+mv3
         aQPstQrJtn1wXRNMgEslw/Tg3bdHuLynvasfz6DDFhQo1Rlzsax83QntJUPEv9tBed
         dNKobaLobb5kOIXfvQT7MPrHoiRADmDJnts0O0Uc=
Date:   Mon, 20 Jul 2020 17:14:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/16] qed, qede: add support for new
 operating modes
Message-ID: <20200720171412.0f067780@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 21:07:59 +0300 Alexander Lobakin wrote:
> This series covers the support for the following:
>  - new port modes;
>  - loopback modes, previously missing;
>  - new speed/link modes;
>  - several FEC modes;
>  - multi-rate transceivers;
> 
> and also cleans up and optimizes several related parts of code.

Acked-by: Jakub Kicinski <kuba@kernel.org>
