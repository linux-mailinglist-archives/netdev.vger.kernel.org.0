Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A460122EEBD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgG0OKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbgG0OKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:10:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72438C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:10:18 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a9so9407147pjd.3
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vu/laqFvilXB+IxNCMlVCsRNjpU0F8/tvnf8tY06aPc=;
        b=lETdw6+OksmO/YxKQegBO41BIyR2Dej7+OtMDUImASjWlLwNl5pFRp+edk//gKeUlY
         eJV53xGh06X5cYX6iYuQn0jpppVlfFRcVNYoSeyWUMbp4LEYKc4xxZb7LzpYz0Zs2RtN
         E80x6EZsLXKmfGz0FnwpRBrzIL1K0yGKB1T7HIyLaE9fEnKYetfSiajHPk4gfxTbT/Nh
         H02hvZ/JDDhJc8A6s9TDrEn5hu1seupdKIK2WhedIL3B/zC11FcBhsNErEWeyW+hvH5U
         eEn5FSyiZnsse3/L5xQz9LuN7ZM+VTm9bkiBA3HHBAfldSDTAPyK0bRQc40tUDmxYa/Y
         dYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vu/laqFvilXB+IxNCMlVCsRNjpU0F8/tvnf8tY06aPc=;
        b=q7mA3uZQka/2PvgKAexv0JUFhVQ7Femv4pLfBl0arVctJsF8TeWPixhB9+ZZabu6VV
         N+qCk2NDHMoB2G6JjVhh+HFDx6Pj0tbH+O5h0WilysNBXEr2bc9am/NeGn5n2il78im4
         Cpc+CF8BAUFb244ReCY/s4FuQccRuF3Jxwyf88f3d7OnysUXFwo/olx0uTCb1bK8/8ud
         sMQdwB7tqWrPoJqMGZG2jVfG3j2TsNDBqi9GA4o0DwT5O9GTRpVrA9rTeIs5wLw1Ps1o
         x6GLAWvSXE9S7j1Kp3LfbBx1Teo1sWY5Yp7Xqddgv/1ArMo2IIkdBts+F6aHLopnYrcf
         pYAw==
X-Gm-Message-State: AOAM530TD7x1MaOLEsFWAli5K1i/WxJbD3+mn1hyYA+8wEkL8szDNmbg
        4p/p41Rub76lX/jSu8z/r7vG6MBt
X-Google-Smtp-Source: ABdhPJxWNEbM8/vbw39gI39VOmzB6azf0kb5mUlct4eZzdFdn1wAHoVht/99Tv5MVQU2+uh8lx/tTA==
X-Received: by 2002:a17:902:368:: with SMTP id 95mr19625531pld.279.1595859017995;
        Mon, 27 Jul 2020 07:10:17 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a13sm15965669pfn.171.2020.07.27.07.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 07:10:17 -0700 (PDT)
Date:   Mon, 27 Jul 2020 07:10:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200727141015.GA16836@hoboy>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
 <20200725132916.7ibhnre2be3hfsrt@skbuf>
 <20200726110104.GV1605@shell.armlinux.org.uk>
 <20200726180551.GA31684@hoboy>
 <20200726212952.GF1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726212952.GF1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 10:29:53PM +0100, Russell King - ARM Linux admin wrote:
> I have noticed that phc2sys can sometimes get confused and it needs
> phc_ctl to reset the frequency back to zero for it to have another go.
> The hardware is capable of a max_adj of S32_MAX, and I think that
> allows phc2sys to get confused sometimes, so I probably need to clamp
> my calculated max_adj to a sane limit.  Is there an upper limit that
> phc2sys expects?

The program uses the minumum of the PHC's max_adj and the
max_frequency configuration value (whose default is 900000000).

In general, huge frequency corrections are a sign that something is
wrong.  If your setup has sudden phase jumps (like ntpd resetting the
clock), then you should consider allowing phc2sys to jump as well.
For example, I use

     phc2sys -S 0.128

which allows phc2sys to jump when the offset is greater that 128
milliseconds.  That value is chosen to match ntpd's threshold for
jumping the time.

HTH,
Richard
