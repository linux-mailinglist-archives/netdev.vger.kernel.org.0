Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A0A5835E5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiG1AEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiG1AEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:04:50 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927BE52FEF
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 17:04:47 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 537F7500583;
        Thu, 28 Jul 2022 03:02:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 537F7500583
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1658966557; bh=6iPV/Ftjnm/veUP17h/vUvNu4pqUdY2T+b66Q8ou3PM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ap85o0Mlppax4683TNCnnfIlA92iy2S/VnnsGtJpfCvac7XT3lTWaXU1p3zNLH4SC
         j2E+jgD+20jEAvBefS3nbOVKrSyFI2CKGCXrrPJU9Y3VdbDGrzkk+5wviJ0+bhNPjM
         T52XmA512LexEa/OAjBGwwbinSeA8FOVJwYDqDQc=
Message-ID: <0f7c161d-f709-072a-f3e2-628a00b09cf1@novek.ru>
Date:   Thu, 28 Jul 2022 01:04:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] ptp: ocp: Select CRC16 in the Kconfig.
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kernel-team@fb.com,
        kernel test robot <lkp@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>
References: <20220726220604.1339972-1-jonathan.lemon@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220726220604.1339972-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2022 23:06, Jonathan Lemon wrote:
> The crc16() function is used to check the firmware validity, but
> the library was not explicitly selected.
> 
> Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
> CC: Richard Cochran <richardcochran@gmail.com>
> CC: Vadim Fedorenko <vadfed@fb.com>
> ---
>   drivers/ptp/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
Acked-by: Vadim Fedorenko <vadfed@fb.com>
