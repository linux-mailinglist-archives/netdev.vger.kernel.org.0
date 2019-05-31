Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60C23120D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfEaQP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:15:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:52352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726579AbfEaQPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 12:15:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E218AE8D;
        Fri, 31 May 2019 16:15:24 +0000 (UTC)
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
To:     laurentiu.tudor@nxp.com
Cc:     netdev@vger.kernel.org, madalin.bucur@nxp.com, roy.pledge@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, Joakim.Tjernlund@infinera.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        Mian Yousaf Kaukab <yousaf.kaukab@suse.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Linux GmbH
Message-ID: <d086216f-f3fc-c88a-3891-81e84e8bdb01@suse.de>
Date:   Fri, 31 May 2019 18:15:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Laurentiu,

Am 30.05.19 um 16:19 schrieb laurentiu.tudor@nxp.com:
> This patch series contains several fixes in preparation for SMMU
> support on NXP LS1043A and LS1046A chips. Once these get picked up,
> I'll submit the actual SMMU enablement patches consisting in the
> required device tree changes.

Have you thought through what will happen if this patch ordering is not
preserved? In particular, a user installing a future U-Boot update with
the DTB bits but booting a stable kernel without this patch series -
wouldn't that regress dpaa then for our customers?

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
