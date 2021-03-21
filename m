Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA393435C0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhCUXaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhCUXaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:30:15 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10FBC061574;
        Sun, 21 Mar 2021 16:30:14 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4F3Yl84H6LzQjmY;
        Mon, 22 Mar 2021 00:30:12 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1616369410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Url4+j2lTtjNkAMyVlf2mrU/U9hSayIO3GkRSkTGMag=;
        b=I5R6htZdGAa72TnGf65hihU9837w7jk8k9zxWwgeFzp6tcdGRvfY+olDsXpARcqw/+Z5YM
        gZH0pveP/ijrkTGtNlCy3NOzkNBDJLt2Tt4bIwUbEmy4cN4CMkqBbROOZ/YUggliO1GjXk
        cMPESXZWTNXvDkMD1CHdkueTRi474ZiZ8uCHmZDXl34BLMqnZhrzgddVG+q9Jx+PwkPdeE
        La+pEyvHqGBfQePf9y6UgRIVgTpPo18H1o8+Zg4ROj9H0k7I65jn0X41WGgMYndQ5UB3Cq
        YUU6kI+verQAmoaaW31sohrFuMLIobcgzvMHs59/QOLQMiaHxYT0O2jr96USGw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 0RlFdNd21UOy; Mon, 22 Mar 2021 00:30:09 +0100 (CET)
Subject: Re: [PATCH v3 2/3] net: dsa: lantiq: verify compatible strings
 against hardware
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210321173922.2837-1-olek2@wp.pl>
 <20210321173922.2837-3-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <6f27b709-3e86-9025-a05d-639c4ee4fd77@hauke-m.de>
Date:   Mon, 22 Mar 2021 00:30:07 +0100
MIME-Version: 1.0
In-Reply-To: <20210321173922.2837-3-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4B7F916F2
X-Rspamd-UID: 6b490a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 6:39 PM, Aleksander Jan Bajkowski wrote:
> Verify compatible string against hardware.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
