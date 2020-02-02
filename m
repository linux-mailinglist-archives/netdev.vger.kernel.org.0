Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573CB14FB6B
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 05:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBBEh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 23:37:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgBBEh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 23:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4oWUZJaR7Jx+L3WxZYUTftOrPw0KXFITkchU6eONNQ8=; b=T7l4+/A3xrUaQ52FJYISmxjnG
        duMEZTL96r95Umj+7OgsE+FIk3i0RC11BPcq5vSR88P1L6PQ/+njvBj7lf2gdLCAHlsX+FOBg9DqO
        QxAM9/lQXJUr8oiveKu19VxkDskDkaQGwAOv29Has4EKNvva0RQx8JwaDFkv0wDXVV6BwUV5GIp/a
        BYtForHRfejzD3vR0REa6j2y/s99V41bG/bmlNC8ohl3Y3UgBBTfkUi/je8SQRpm7J4XnrvBH0Nnu
        vk7aX3Y0Z6UqKQoQ/msYTtf+sX0t9w5oej3LFg05ncHlnUgg/6DFicMgXsTD1snYT65GNUZZZsqH/
        T3pN4f51Q==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iy717-0006gy-4o; Sun, 02 Feb 2020 04:37:53 +0000
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate
 ioctl for device
To:     Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        "contact@a-eon.com" <contact@a-eon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200126115247.13402-1-mpe@ellerman.id.au>
 <CAPDyKFrbYmV6_nV6psVLq6VRKMXf0PXpemBbj48yjOr3P130BA@mail.gmail.com>
 <58a6d45c-0712-18df-1b14-2f04cf12a1cb@xenosoft.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c9c7de30-dea8-f162-f049-a16b2bcf7b7c@infradead.org>
Date:   Sat, 1 Feb 2020 20:37:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <58a6d45c-0712-18df-1b14-2f04cf12a1cb@xenosoft.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[might be network related, so adding netdev mailing list]

On 2/1/20 4:08 PM, Christian Zigotzky wrote:
> Hello,
> 
> We regularly compile and test Linux kernels every day during the merge window. Since Thuesday we have very high CPU loads because of the avahi daemon on our desktop Linux systems (Ubuntu, Debian etc).
> 
> Error message: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for device
> 
> Could you please test the latest Git kernel?
> 
> It is possible to deactivate the avahi daemon with the following lines in the file "/etc/avahi/avahi-daemon.conf":
> 
> use-ipv4=no
> use-ipv6=no
> 
> But this is only a temporary solution.
> 
> Thanks,
> Christian


-- 
~Randy

