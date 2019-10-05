Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE69CCCC69
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfJETAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 15:00:36 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39305 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbfJETAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 15:00:36 -0400
Received: by mail-io1-f67.google.com with SMTP id a1so20540426ioc.6;
        Sat, 05 Oct 2019 12:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pzgds363sVjt6tTHjuT41LayOC3pwj5qUHdeZopvI60=;
        b=ui+99W7V8mYFpZSjc7PrqXXPh/ZCrcNkygLinlWYrtBHXo+7eqZJC4gWIuDu60/Lfv
         1tcn/3cip9ePEQESnqt5s9iyPCRm9GGn2CqlQUgo3jQpTVXEc7YdjILr0fKbk5dDpiMx
         AlMP7k8vNV4s70WyuH6DEqD0bLoTGC6/P3WmPwXWOYOZnVr2w/T8/cbmpn4G3C92p/As
         MMfV+gjBhQiYXR4xRQfHlKVSlLRksrvOQdGpp5ag7YxdMBRNt7ypb2AYiso6BR6A9Bbe
         u5ddDtaVRigcswS+EzRuVfbMf5aPCV7uu1jxJt3GCYCbmY6nsAXR7DJj1qWC9HI+i31X
         xW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pzgds363sVjt6tTHjuT41LayOC3pwj5qUHdeZopvI60=;
        b=tf5aux5MDLE2r0L//6ZSPs6nxjPD8Ebo40J6xv45NMe5tGijNtr7w4ttC8gN+78sHz
         prA5TeqbALr847m/xlMRwyVbkUiC4cvpzJRwXQsDqIvqBXt/+hGyjrB64a0xjg8SpFux
         R6ozIp0bBo8EVxPPCFuWzghbE7QkD+j9Lftk6w7BgjGj46teOXMREIQkZPlCHJ9yE2j7
         3l7flQINrd8l4v3g4m60vjMpIi9SZZp3X1QdyB+qO5NvkX1CYUrT2BRQfIBq69vVCr+v
         bSjnPFwD0SHdX5cEa35pE8dwDHDsZR0A26d8mFMlK21rfX24GYTb2/hkW8zrwDJPYuKd
         YuXg==
X-Gm-Message-State: APjAAAW859R0Gr6ntOpld/SLPpenHUkh8TdtnzyxrrUuX3Zs5fztYCUj
        BCUAJfcRbKjliwg9V5Z5ScQsuVpYEhxaI8DM9gI=
X-Google-Smtp-Source: APXvYqwM96alpXRdELBUa41V98MXAHJuLW5QCNnGTNtIreMr90WPqYbBaStyDzTrxEQ/tpThispyvpWKRwYCJVLmvqs=
X-Received: by 2002:a92:ced0:: with SMTP id z16mr21939458ilq.172.1570302035209;
 Sat, 05 Oct 2019 12:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191004195315.21168-1-navid.emamdoost@gmail.com> <037d04e8-4651-a657-6be6-b1eca072bb81@web.de>
In-Reply-To: <037d04e8-4651-a657-6be6-b1eca072bb81@web.de>
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Sat, 5 Oct 2019 14:00:24 -0500
Message-ID: <CAEkB2ERipLQRV3CsZ6L3EV0jXtS0HMc8yM6g5sNqJG0NThBsmw@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: fix memory leak in rtl_usb_probe
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh! It's duplicate, thanks for catching that.

On Sat, Oct 5, 2019 at 11:08 AM Markus Elfring <Markus.Elfring@web.de> wrote:
>
> > In rtl_usb_probe, a new hw is allocated via ieee80211_alloc_hw(). This
> > allocation should be released in case of allocation failure for
> > rtlpriv->usb_data.
> >
> > Fixes: a7959c1394d4 ("rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine")
>
> Which event did trigger the sending of this patch variant
> after a similar change was integrated already?
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=3f93616951138a598d930dcaec40f2bfd9ce43bb
> https://lore.kernel.org/lkml/20191001092047.71E8460A30@smtp.codeaurora.org/
> https://lore.kernel.org/patchwork/comment/1331936/
>
> Regards,
> Markus



-- 
Navid.
