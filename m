Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F378A0A2
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfHLOVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:21:13 -0400
Received: from mout.gmx.net ([212.227.15.15]:58913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfHLOVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565619665;
        bh=zUhEadOAUQhcWm7AGcip/egPCwT9J+4/k4dDXd7AnpI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=aVtZY53yHXM6A/aYymGfzmI5MAaya69O9DZsW9mkloKh34+ayHdHeuEafJ9IxlgW/
         t+K0V8OJZlTgfI4TVsR6hfrRXWFCDNUqQF2chbQxMCrPipuACz3vd3KQqcCiVFfNEj
         aoVX8QsYUbLbWu044DWZft0BlM4iqFIX29eqqakg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.152.193] ([217.61.152.193]) by web-mail.gmx.net
 (3c-app-gmx-bs80.server.lan [172.19.170.228]) (via HTTP); Mon, 12 Aug 2019
 16:21:05 +0200
MIME-Version: 1.0
Message-ID: <trinity-b3a8466a-f95c-4f43-88b0-6f66c5850fee-1565619665734@3c-app-gmx-bs80>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     "Vivien Didelot" <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: [BUG] access to null-pointer in dsa_switch_event when
 bridge set up
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 12 Aug 2019 16:21:05 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20190812134243.GK14290@lunn.ch>
References: <trinity-99bcd71d-8f78-4bbe-a439-f6a915040b0a-1565606589515@3c-app-gmx-bs80>
 <20190812134243.GK14290@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:5qDa2BE/sSzjmKbbE1/R41wXv0iMXfdGeKoYVdxoO2G8CtortXU6rgZmOu2HfJnIapbLD
 yHWBngVLeo63yS9nkk5W/c0hbJVdAfdjFlXPXMEJSFGRv3l74tqZDdLpRziGX/n76IejZ2MOaqeS
 TCrnMOOq6B09lXPp79HPfQ7CfVSXqShK4GZZg+tK5Bv98AnFV7OCBOg9AZeSzUw9Xbod+SS27ZfC
 o5Fd3azB2ltmzNLWDJyzHCb/wchJe6HlU0OEfoiEVnT/uy2BYmmi3TLpGUQ4DAGJWzMbucBKqJt6
 yw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+dQG7yZZiFI=:yL7wtFUMDsAMaCujFfkZg5
 CWwV4LZnhVkBCvrsquaHA5icHbTH/fc1zHi3BaIo+NxWlh81HU9nWmmyXP9ZvLp9QdEt8EU6T
 MJA93f3/PhepC+5W8jDhwJ5ft0trwDxlfUeSUaNta+YFDF7tKvfucdawzpfej4bxtZyxuD5co
 BsJhcXiUGnHCtALhVJoiPWuWmWNIW39fF7Vj14bNklwhq4S54BwVj08MqesxECOgDaqgDCsp1
 oezp4sRlEnsMpL1FwbEaaEif05Pj6wWbrziP7LEaQ14TANWkNi93tMgFxe3Cvz7kOt1p2mtS5
 6ykuVItgsqP+GpCE9+KQlBBROQ5JQt3MkXBi6zijvWdv2fhTLCNGPRCmfSGlomkKkhuYvzEzD
 KnejvYJtgtNjv8K86Xye2P5OBuueKslx8Ga/PvIPr1wnFuhrM/zacyRCtg4f0iU63MG8cwAom
 A4784N7vOLNI4BQS/5xmmF+1jrGSpqZD2GSRoGF8n6FQaTM6KQ/8/Jsv+eeWyIxNRl7QwDbcR
 cwzs+RSoWXT+oZ9C2xSEJe5euq1KvVGPFvwei3KTLiMagUra1luMY6JxRNva3uirXNMff8nxs
 ZHoo+2aKcsg1fnpXu3tKBKAscAQ72HfTu4j1afwyT0uv5FWPJhGss1yQ2HkUzj19d9NM8h0BL
 2l+2/gSPwT09fjKzjJERom+MYShpRKe/Ye5TXvCrbred8eA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

[1] seems to fix it, thank you

regards Frank

[1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?=
id=3D58799865be84e2a895dab72de0e1b996ed943f22

> Gesendet: Montag, 12. August 2019 um 15:42 Uhr
> Von: "Andrew Lunn" <andrew@lunn.ch>
> Hi Frank
>
> A patch was merged last night with a fix for dsa_port_mdb_add. The
> call stack looks the same. So i think this is fixed.
>
>      Andrew

