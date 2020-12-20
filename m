Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B61B2DF478
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgLTIhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbgLTIhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 03:37:24 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFE5C0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 00:36:37 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id k8so6196047ilr.4
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 00:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VeTpENt6JQ8He7PxkHgDwT6tFX6J/wKrgI0Io1Fiukc=;
        b=S5ruBZqc8QVT+NDMsWF7fW9OqXQPEi/VjQY+AxQZE/SxLPM3YxEb2Xi0QxmN4GQ3/B
         s3C5589KmghTtUF2TYeTy83vThtoWQ5pSJduu6U4lV/dHaB1HejEtmcUaHK4RSA2auTW
         Oeyj7aldX2g9QEaZsfPNuxNOBsvh4+KI99jk97dQEiXQTSVya2+XJFdB0QQlbzVGigur
         DuwbufmmarRL+vn+Y5+aGT6sDLkbncFs8ldsV8djcHaRsShPoUlQzWnf1sK3Su1pBL2x
         rLMe6xG7oh5EnitoYk/WQneVtbwqTL9gcWGVGgzGM+CLVbZsbgD4A5C6NUmzjj3D7cVO
         PwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VeTpENt6JQ8He7PxkHgDwT6tFX6J/wKrgI0Io1Fiukc=;
        b=pDQ8rEeiEz8wm5KX56z+PpO/I+Sff3GgVh8HRHkG970/liD6tBb7nZL3QydUd8r/Hi
         6weZ1URNbdwqCMUZ1Y3bBhClx3jRCu3Ay/EKN1QGKbeVTDfD3y3+QzFH1lfvOiYn6tzU
         GUx+VfiSDH5DmrN+tiZb6JZf/+SqqQFN2AQJ9MBmuhWFsjfZeTkTmdDMui4qGnWlB5L4
         +364v7iYkRK6kVfG9gGplOzGLlUuNjb6XwadyotQwXul7ggdiRyoWk/WevEXakQxtT7a
         bi+8h8kR2e283GEoqJvX9dfi4KQCl3g28dZNICuQ+vyg2T82Y2Pa+4xIGincZ/V5RlM3
         z/lA==
X-Gm-Message-State: AOAM530BmL3Cu4xmk29ycljWdjqeLetMLPKXJ83gJd+PlLEz1XAtUzAS
        0Ivvk2bNgpvcqvbdZMehzJQA5zUckXr8o3xMN2o=
X-Google-Smtp-Source: ABdhPJyfWlLXMSMxTroy7d2Dji3JTVuRmQwEgIf1TG1OiqpAzO7+cbeNFrn/5RKhoatAoI42k4Noh6nsN1XEVUaN3uw=
X-Received: by 2002:a92:c04f:: with SMTP id o15mr12213601ilf.31.1608453397161;
 Sun, 20 Dec 2020 00:36:37 -0800 (PST)
MIME-Version: 1.0
References: <20201219162153.23126-1-dqfext@gmail.com> <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com> <20201219194831.5mjlmjfbcpggrh45@skbuf>
 <CALW65jYtW7EEnXuj2dGSDwYC=3sBLCP0Q9J=tMozkrP6W0gq0w@mail.gmail.com> <20201220074936.ic2mtta7ihg7n3or@skbuf>
In-Reply-To: <20201220074936.ic2mtta7ihg7n3or@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 20 Dec 2020 16:36:27 +0800
Message-ID: <CALW65jY29uPMGuMCXHsPgf2n5nNPivxmkLWuP_0zO82OL8rZrA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 3:49 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> But still, what is at memory address 0x1e110000, if the switch is
> accessed over MDIO?

It's "Ethernet GMAC", handled by mtk_eth_soc.
