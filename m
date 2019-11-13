Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D55FB030
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKMMGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:06:39 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34582 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfKMMGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 07:06:39 -0500
Received: by mail-il1-f194.google.com with SMTP id p6so1569298ilp.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 04:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gn4nGl4/aU01Q6EzAa3fpLh2f+Que5/VESf/QKj0oZY=;
        b=B1QP5B6eYq5LIlbVCQ59Z/Wwfeh6EV1ejBq9r7gfsJ22xS8X98NsaKrc9b+P7hZpPv
         BCTLc5hPIapniArXqGXuTVlAffhf97jI9aglCS8yiQ/r1cWqKoZykVnr+7E5qArCpVsx
         1hdfsYwt4IAGsYLUn03gjDQh80fxN0PhdWxJ0Vv9aMT5FLNuWOB9dXTasCpFyE39xAcK
         5QwjaV7XZamUhbWTM9dTtu9s1eMUWHYi/MYiWZucblfYxILMiUgiu4WQvi4O+eCX+OLO
         hTvXfdxsu9iJFS8QjVmGpZLiUt8/FWdCskfms/z9yYYmmI+Z9dyMqZFwV+ye00/q85E7
         lWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gn4nGl4/aU01Q6EzAa3fpLh2f+Que5/VESf/QKj0oZY=;
        b=AtJebEH0rTSLhG/GvzdGbZxMgyQN+8IqxfPy1hbTuPYb1xcw6GUmHobMkUp+yc3Rmt
         epCgUIGLf+GQzyWlblPzvmcclFMfeSG3ucQ0ADOcAHOel2EMMJNwg9qrFraocoFI3SEg
         XMj9V4BH3mN8kev3afOeBwW3eb/NYnbZMIzbFvzNDl91xYkmTazBRdqMV07M1S0KHgzm
         fD5dgSXzxHeoDnOGYzoA4hiftcuZ9le4w2y7zUfg3ITxQhGMj6qbsIESrbwTFASEATKa
         GXY3ipOn0dsAS7rL+Ld+PmZpGoVNjOMU/5qTl0LZTABP4m+IjAdBLxIY2F1OEXIXYj3r
         Qj4A==
X-Gm-Message-State: APjAAAXlHKQE97r3WzYuQtbFIZdK+Ol2TEnah9Daoe3EkoVKcKorrGIA
        NrnV08W8fg2ZcixjBr4qBqqrpyymstZyvn5zMfwqNetz
X-Google-Smtp-Source: APXvYqzPCgGtqD2CF1uekMJM7Mq641wAEaCPHuI1isGZ1xM5pAaXJGFVfBWal2CA40hcAcKiwZAyn86B635ps7JiwHM=
X-Received: by 2002:a92:5d8d:: with SMTP id e13mr3579936ilg.32.1573646798728;
 Wed, 13 Nov 2019 04:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20191113101110.496306-1-aleksander@aleksander.es> <87woc4qdea.fsf@miraculix.mork.no>
In-Reply-To: <87woc4qdea.fsf@miraculix.mork.no>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed, 13 Nov 2019 13:06:27 +0100
Message-ID: <CAAP7ucK5Wqcprj9c5sGLaE88-77EA3fB=sb7_0EK+7eoFAJxMw@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just one question, which I should have asked about the DW5821e too: Is
> it possible to configure the firmware of these modems to USB2 only, and
> do they work with the qmi_wwan driver then?
>

I know these modules force a USB 2.0-only mode when they switch to
fastboot to allow firmware upgrade, but there is no way to configure
the firmware to boot into USB 2.0-only mode while in modem mode.

-- 
Aleksander
https://aleksander.es
