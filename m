Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF438B797
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhETTaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:30:22 -0400
Received: from relay02.th.seeweb.it ([5.144.164.163]:38679 "EHLO
        relay02.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbhETTaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:30:21 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 15:30:21 EDT
Received: from [192.168.1.101] (83.6.168.18.neoplus.adsl.tpnet.pl [83.6.168.18])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id D60D01FF04;
        Thu, 20 May 2021 21:20:54 +0200 (CEST)
Subject: Re: [PATCH] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        phone-devel@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        marijn.suijten@somainline.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210307113550.7720-1-konrad.dybcio@somainline.org>
 <5e7b575a-7820-3d10-8617-36911d49f4a9@broadcom.com>
 <754923af-407e-05f8-148e-4c2a3faf42ab@somainline.org>
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
Message-ID: <bfe3d2d5-6ee6-678f-644f-e5448480d94e@somainline.org>
Date:   Thu, 20 May 2021 21:20:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <754923af-407e-05f8-148e-4c2a3faf42ab@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


sorry for the lack of answer from me (I've had a lot going on..), but the one Angelo has given you is right. We have to use the files that SONY ships with their stock Android firmware. Could you look into this patch once again?


Konrad

