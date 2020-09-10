Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82E264FFD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIJT6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgIJT5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:57:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DBDC061573;
        Thu, 10 Sep 2020 12:57:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so4838949pgl.10;
        Thu, 10 Sep 2020 12:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2u4fro+aqAh4l9brwRKx55kBfkxq+tZUlSLqeionKv0=;
        b=CbQwCye/+KZcOHPWSQwJ+Lecwywg47PM3xSLbyRdyEhzBV7rEPrrZWHZBHRKgmwR9u
         aJJXQ1LKthUIPLyQ3JL+m4cPK3PJW3Zq8KMWIvdH1MrMi8YQix9gmyzyg6Bezw8aA8uA
         l9pvjDwXUqiOvXbX2J8jLpP5bo9kqSh7l8sbPjcJhbkCNuTf6nMTCTzXyBFP5Uvo3a3z
         NkvC9CMAU/JX4Ry/3rvz+gLlDdtX1Rg2DhS/K2jPOFpWZGTtmIRji6HghTddDz04GXYk
         VB7yr5fgpdOGcbatykDNciwrPNGtCogevbeHhDKXKyz9n3UpRMTLhvu9vPBwCNPDSjFW
         KHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2u4fro+aqAh4l9brwRKx55kBfkxq+tZUlSLqeionKv0=;
        b=e4bBbpNtl5PdSVNq1vHraTI4Qu1qTBzGiSy/1XdzsnyaG/44+j4Ej7SkdiW83z5OuK
         0B/jKHSi+eoJ8MFL3dupfpqD+RRkY/FDbR+VHnfj5OiReIKdEOUlfSdtusHlDLsdiilV
         mmOmaGbcicfMp1RjUibtC3ZSYrP+AzsidT/YmOi8i13SrBZySnNEXNeB7/YeKAQX/+7j
         MNhbyjvS4EiPYtLzHdPf+Tgsud5nLUVraROtvEFoo733C4dGvZka12tEu3ysPIxPeiW8
         qEyaWZl18eGh1spN1mBu0/yPY6cLmvvA8/Pf7z211k3oZGXECh80RkCYcms2lfPWgpFW
         /ZjA==
X-Gm-Message-State: AOAM533G3Mto+vz7WU3CBk3TRJTttEE8TN3SpFEM1VV4Ujdwjfiar3BX
        m5B9z3JnM6yOQ3b5Kp7ufbgaOjJ/V6bnlAo4Yh4=
X-Google-Smtp-Source: ABdhPJzmiu1067UwNsxwM9ANmjj6QeqG8puVRNUiewQzf3IXvPc0D1tA/kHnQETNCSdI+3r2ScExdYdlbGpFyFQKlP4=
X-Received: by 2002:a17:902:7b83:b029:d1:8a16:8613 with SMTP id
 w3-20020a1709027b83b02900d18a168613mr5586616pll.38.1599767872523; Thu, 10 Sep
 2020 12:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200910054333.447888-1-xie.he.0141@gmail.com> <CA+FuTSdcT70_zyJHiMPT_HK8zJbTg72y-AO2XYUXL28RX+tY9A@mail.gmail.com>
In-Reply-To: <CA+FuTSdcT70_zyJHiMPT_HK8zJbTg72y-AO2XYUXL28RX+tY9A@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 10 Sep 2020 12:57:41 -0700
Message-ID: <CAJht_EPvsSWDgdHojC1t5+6tT0meJWBfOLV5jzKdff=NRNBjxA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Clarify the difference between
 hard_header_len and needed_headroom
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK. I'll make the changes you suggested and resubmit the patch. Thanks!

I'll drop the change to netdevice.h and the check for
dev_hard_header's return value. If there's still a need for something
similar to these, we can do them in a separate patch.
