Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F631024D2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKSMrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:47:08 -0500
Received: from nbd.name ([46.4.11.11]:39468 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfKSMrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 07:47:08 -0500
Received: from p5dcfb9cf.dip0.t-ipconnect.de ([93.207.185.207] helo=[10.255.191.27])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1iX2uJ-0003Px-6R; Tue, 19 Nov 2019 13:46:59 +0100
Subject: Re: Felix Fietkau email address become stale?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
References: <20191119124506.GC25745@shell.armlinux.org.uk>
From:   John Crispin <john@phrozen.org>
Message-ID: <cad7ea93-8aad-6bfa-c1c3-9932c5a87699@phrozen.org>
Date:   Tue, 19 Nov 2019 13:46:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191119124506.GC25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/11/2019 13:45, Russell King - ARM Linux admin wrote:
> Hi,
> 
>    nbd@openwrt.org
>      host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
>      SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
>      550 Unrouteable address
> 
> which was triggered due to MAINTAINERS saying:
> 
> MEDIATEK ETHERNET DRIVER
> M:      Felix Fietkau <nbd@openwrt.org>
> M:      John Crispin <john@phrozen.org>
> M:      Sean Wang <sean.wang@mediatek.com>
> M:      Mark Lee <Mark-MC.Lee@mediatek.com>
> 
> Does Felix's address need updating or removing?
> 

all @openwrt.org emails became stale during the owrt/lede remerge. 
please use nbd@nbd.name
	John
