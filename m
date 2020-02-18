Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082FF1627A4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBROFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:05:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32904 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgBROFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:05:13 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so23107486lji.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 06:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gepirWzsXM8fMOGmpzh1TBArlnDGwmVTkXthgGICiqE=;
        b=ddMyzjMB3HZYRC4oGoarNS9uYm/KPRZoCbQ0aPEjyYCqdGE50erFfzSHPoDBhLvyt7
         iqWB/JjdVumEDwi407Nw1VLXKEou3v8qBiktQgY1K+ustPYp71j+3q9FingQSwp2jwrc
         fHuwxptJyb4/T9ZHAukNdHnojBE+8P06YlDH9NQDRAjCtnylESHZVwiWZ3YPB7EaJivl
         /gswMj6mo7YTiYixnHpgwlbrKWL4WLhTJ0iA5vDBsXd7SB4RLw9S4ep1yMi+mLcYtwqK
         0NYQ3qb8iHBFoyKTgllwM9Q/bAn3OfcMvPX2YzZIpAcHmH2ypzxtSHrJfMApa8ZgHr//
         VMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gepirWzsXM8fMOGmpzh1TBArlnDGwmVTkXthgGICiqE=;
        b=arN9M+dlhKnYqoG2LN0AwhLlW20TXq359yPjdop8sXeEEad/nhHyAuMwHS6Cc+ACIa
         GEbH0mTW8yLFMxMSS0Q6V1DLTTNGjNgshC5HvfG91XAKrn4efZ0ds36BeJhvnEPu1lrb
         wVMZIMaKhQB/jPv/es0GrpD8plAOI67IoncWsmrcYJR8sBWf7fCkBIVFeXFlxN/ubWas
         ql8L1v0P1W6SgrVEuRSniq4snTIhB8pVmGZiZI6KOydh7sKbKTIuAcvCryktYQIbfh9h
         VsmN45TzLH5g9U33psLko5+ZxekyoahOpj6yPppf4jkF0EZuKT9pRy7BQi4LK/i1wuTh
         jsFg==
X-Gm-Message-State: APjAAAWPYdI5t+00NmWzH7bMT1d3/eDttwOIbHO9lbIqw3gZnbArJR11
        JiyA5JT82N6kqRctj/n2uzZ6L82Q26SrblFsPlgkFpTP
X-Google-Smtp-Source: APXvYqxBZFQ8IYKs1larRN+se+woUVQvettdIJnprafxEZS6z/oSgR+hYra3gpNAPfoz53YbgrOIHkB35lGPZmOh4gM=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr12690476ljc.195.1582034710972;
 Tue, 18 Feb 2020 06:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20200217223651.22688-1-festevam@gmail.com> <20200217.214840.486235315714211732.davem@davemloft.net>
 <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com> <VI1PR0402MB3600B90E7775C368E81B533DFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3600B90E7775C368E81B533DFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 18 Feb 2020 11:04:59 -0300
Message-ID: <CAOMZO5A_LvVOEQKqbrm5xKUR5vBLcgpB6e50_Vmf5BDFsRnaTw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation scheme
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Tue, Feb 18, 2020 at 10:54 AM Andy Duan <fugang.duan@nxp.com> wrote:

> For imx6sl/imx8mp/imx8mm/imx8mn, soc only has one instance, bind operation
> is supported and has no problem.

This is not true.

As per the commit log, here is the result of unbind/bind on a i.mx6qp,
which only has a single FEC instance:

# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/unbind
# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/bind
[   10.756519] pps pps0: new PPS source ptp0
[   10.792626] libphy: fec_enet_mii_bus: probed
[   10.799330] fec 2188000.ethernet eth0: registered PHC device 1
# udhcpc -i eth0
udhcpc: started, v1.31.1
[   14.985211] fec 2188000.ethernet eth0: no PHY, assuming direct
connection to switch
[   14.993140] libphy: PHY fixed-0:00 not found
[   14.997643] fec 2188000.ethernet eth0: could not attach to PHY

After performing unbind/bind operation the network is not functional at all.

Don't you agree that unbind/bind is currently broken here even for
SoCs with a single FEC?

Should we prevent unbind? Or any other suggestion?
