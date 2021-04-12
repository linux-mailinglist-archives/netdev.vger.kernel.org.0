Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3926235BB2F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhDLHss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:48:48 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:38254 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237029AbhDLHsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:48:47 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 69C53E5;
        Mon, 12 Apr 2021 00:48:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 69C53E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618213709;
        bh=iqIiEL+G5T2ttG3Yck3N7LMMb3tzSKgX1h9tbMIl1ig=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nxx9Il9U5HCUo9FiWXYyfBDVcx4VXA4f1ghwIBfhf4yFKZvg+QCtDtxlhbX9cZhvi
         ZEW8AAkl0Gft/TSbMujBg8eLB0EHp//WzIlgiFap3R5nWz7T+p4YId2I+mvd5BmX6N
         kFERZ062aZ+HI4JB9S+LXSUHuLtzV0occjMal/ic=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 6F7B21874BD;
        Mon, 12 Apr 2021 00:48:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
To:     Shawn Guo <shawn.guo@linaro.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20210408113022.18180-1-shawn.guo@linaro.org>
 <20210408113022.18180-2-shawn.guo@linaro.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da449bc1-0155-5019-dede-cd6c8405b059@broadcom.com>
Date:   Mon, 12 Apr 2021 09:48:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210408113022.18180-2-shawn.guo@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08-04-2021 13:30, Shawn Guo wrote:
> Add optional brcm,ccode-map property to support translation from ISO3166
> country code to brcmfmac firmware country code and revision.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>   .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 7 +++++++
>   1 file changed, 7 insertions(+)
