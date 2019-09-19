Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18679B712B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfISBos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:44:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43788 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387395AbfISBos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 21:44:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id h126so1605621qke.10
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 18:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xkMdRwP7dRIQntiL1DI00+cj3iNG/NEsiFgJ+PEO0gw=;
        b=Zw96cAcTE35uIKpBFAL0KSlDTqm4ScDPL9alYcLDS9Yf31Du08TU0vNhHURemYdcNO
         WOR53PoEvW6D4qCckjtUXvNzBZjuBkzv1aX7U9cbUNy03Z5ikhlBo2lNC/aq+xEbI/59
         eaIPkRgctTX/RVDoYCg9+XXiwnjLwZWrUntRrXgDnqA84Qxs5H45d5ZdDpntIV3debwA
         Yi7rxtrMCRUi9yEAxsXAF76t6P1TelPu96uB+UUnyF10SY9/fjYlueLgI9vnl/0D2azL
         bBFgmy/zlcPuMeeNWvztNnnnSsxuBwqMDaXJ0yuqvTz6ZV8TZzMqqAhNFQvG3cqI3Kou
         b82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xkMdRwP7dRIQntiL1DI00+cj3iNG/NEsiFgJ+PEO0gw=;
        b=frWrBaUYZfmY88gSRSec70ZTw0ZYpFo91kWVpQmYDKkRqUNS9F6HCmMg1fpqbTEFlp
         J2nGURQdrP9zOWVKWVXh6fixpV0Ehl6IEcvADnOgZkgMw7YylytxqXS+ntsdq+L7KoZ3
         GmwGuVHDAStMWwLy15ICstO517ZBTrz37MnZy0M+Ij4kpoO6wPcPPUn/djY8+oC9N/8j
         kthyweXqpCEXwzSqsfi+ECsqeR8jaqJ561nI6BYEj2CwWtcJc/mLjyGyBU1BstluSNqj
         7Gde1V+Y65e+BfvLFVOIEYbna3lOK4ex0/Cgv5otp7y+WN3tAbXFUruO8LOr5r0gh3y+
         YrnQ==
X-Gm-Message-State: APjAAAV2w0uO7xWmekPzE73xUwKCCCDDRj/XlLBLtDIv7oFKUNMOqWSh
        xvaJ64Nn9akBfJU9BI28nXZMKWzi+4FeC3Yeye8AZg==
X-Google-Smtp-Source: APXvYqw3xhDJsC4KO6DBCGEOvw+KkzJfCRl9QjdJwDEkRsdKxsqZl3tYPpV1cMRJHB+rn+bVsMMar0AqTbD5Bnon6EM=
X-Received: by 2002:a37:b16:: with SMTP id 22mr498473qkl.220.1568857485567;
 Wed, 18 Sep 2019 18:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190911025045.20918-1-chiu@endlessm.com>
In-Reply-To: <20190911025045.20918-1-chiu@endlessm.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 19 Sep 2019 09:44:34 +0800
Message-ID: <CAB4CAwcs4zn4Sg0AkFnSUE-tbkdrHE=3yYeF8g+-ak5NyPBkuQ@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:50 AM Chris Chiu <chiu@endlessm.com> wrote:
>
>
> Notes:
>   v2:
>    - Add helper functions to replace bunch of tdma settings
>    - Reformat some lines to meet kernel coding style
>
>

Gentle ping. Any suggestions would be appreciated. Thanks.

Chris
