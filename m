Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02591FE020
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfKOOc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfKOOc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 09:32:29 -0500
Received: from [192.168.1.20] (cpe-24-28-70-126.austin.res.rr.com [24.28.70.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6F4220733;
        Fri, 15 Nov 2019 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573828348;
        bh=TAYLQOhUh8h/nx6QbmxUbjow7UiI6LrAdXaD68+uFvE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QCc9FbnjyGGyKkCNbEVOPEZxP32m3xPd+mfiIWpYphzaBxg9RNGVPUg/1VfeNFDh9
         5f+B5udjGz7ePtloj37N5rCoqZPSoWg2T0NaFSV0Uc3NQkcJFXE2M080wtTJdHgLfj
         bwUP6Ul0Esu35Kov5IyJBDwk2KkA058sMZlbGsBw=
Subject: Re: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Li Yang <leoyang.li@nxp.com>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-47-linux@rasmusvillemoes.dk>
 <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
 <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
 <29b45e76-f384-fe16-0891-cc51cfecefd4@rasmusvillemoes.dk>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <e251d109-9f41-4d04-927d-70fb035622e8@kernel.org>
Date:   Fri, 15 Nov 2019 08:32:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <29b45e76-f384-fe16-0891-cc51cfecefd4@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 1:54 AM, Rasmus Villemoes wrote:
> "Also, the QE Ethernet has never been integrated on any non-PowerPC SoC
> and most likely will not be in the future."

That works for me, thanks.
