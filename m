Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903820198B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392026AbgFSRfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:35:17 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:37315 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391129AbgFSRfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 13:35:15 -0400
Date:   Fri, 19 Jun 2020 17:35:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592588111; bh=pmcgB8cIWmktL8m7nzcLgHPgxr84gMsapvN9vA7VbRQ=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=QePdyPaod+pKMacktRWNzHWsjJrj3nxq+JWWbCnDXbS/XssWQheK7VvLrcMZFk2TB
         tE6C6kVxHHDZGWQSt4YUXJGXoF2xlHDw9Nj4aNVf1feMzuXoYFjlNqeqf/Bkogl1sN
         Gdd4U/c1Ul12Xg+pO2TRkX3u8u0U7IUkHORviBlTfSK1tjI1ZcOtCXZLZ/hLQ0B3Q7
         /Ruv9nJHKEmLkQ3Si7B4scvBY5q0MInhS+i6cseXRzT7cOS7QhGcpbpsYd+MahWE7D
         NUVIGh8kYWqdls84gtjAdA//pd+ORdZNtzWFX451SUecJOE3fuxEtOPSNq92vAIqq4
         LjyhnBMB6pXZQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net 0/3] net: ethtool: netdev_features_strings[] cleanup
Message-ID: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little series adds the last forgotten feature string for
NETIF_F_GSO_TUNNEL_REMCSUM and attempts to prevent such losses
in future.

Patches 2-3 seem more like net-next candidates rather than net-fixes,
but if we don't stop it now, no guarantees that it won't happen again
soon.

I was thinking about some kind of static assertion to have an early
prevention mechanism for this, but the existing of 2 intended holes
(former NO_CSUM and UFO) makes this problematic, at least at first
sight.

Alexander Lobakin (3):
  net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
  net: ethtool: fix indentation of netdev_features_strings
  net: ethtool: sync netdev_features_strings order with enum
    netdev_features

 net/ethtool/common.c | 133 ++++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 59 deletions(-)

--=20
2.27.0


