Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D861B82DB
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDYAou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgDYAot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 20:44:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009292076C;
        Sat, 25 Apr 2020 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587775489;
        bh=3N6Zdno5nkN51ME1AkXFV+t2FfvZgvmVqCtqtt8Kx1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZWt+WuebGOTVnDsWXr1XqYax00kRYdd4zv3Xifhly/uDOoERcMnTLm6+MEBmAQ73k
         LzdyKHTUGO28hZzuAQSXbh1piPoBk+fh6AP0sfAsYOgl8dLT81JSAvNMJ5Nw+SQCIl
         fGi1nhzhvEXbcCOIoLaevDOcCKeoKPAVH2JAp2EM=
Date:   Fri, 24 Apr 2020 17:44:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH net-next 08/17] net: atlantic: A2 driver-firmware
 interface
Message-ID: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200424072729.953-9-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
        <20200424072729.953-9-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:
> +/* Start of HW byte packed interface declaration */
> +#pragma pack(push, 1)

Does any structure here actually require packing?
