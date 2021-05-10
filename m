Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AED377DAC
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEJIHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:07:32 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:59788 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhEJIHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 04:07:30 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id ADD5024326;
        Mon, 10 May 2021 01:06:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com ADD5024326
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1620633983;
        bh=TF8n6BqDaEGvTkD02fTD3yctVLeIHUCOxY3e1q/S54g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RN4DiJxzeBTubLxiEEaCoSGEiCg1n8OKwALaHBGcapP+PwEhInRqrVlO7j11C/gGV
         qBa86DX+p1UKHeFvBNtPQWT3C9Cot4EMORHa6VoDzcgJ5IJdB00caBwjDQ9HQLIX0B
         hGxffIg3Wm9cCnwR0ft+a0gcBd5HJNYmYdJ0SF18=
Received: from [10.230.41.67] (unknown [10.230.41.67])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 9D2DA1874BE;
        Mon, 10 May 2021 01:06:19 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
To:     Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
Date:   Mon, 10 May 2021 10:06:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509233010.2477973-1-mike.rudenko@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
> A separate firmware is needed for Broadcom 43430 revision 2.  This
> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
> IC. Original firmware file from IC vendor is named
> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip

That is bad naming. There already is a 43436 USB device.

> id 43430, so requested firmware file name is
> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.

As always there is the question about who will be publishing this 
particular firmware file to linux-firmware.

Regards,
Arend
