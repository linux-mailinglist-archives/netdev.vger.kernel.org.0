Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9813A219017
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGHS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:58:46 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:44052 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgGHS6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 14:58:45 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 5CAACBC118;
        Wed,  8 Jul 2020 18:58:40 +0000 (UTC)
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: XDP (eXpress Data
 Path)
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+samsung@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200708135737.14660-1-grandmaster@al2klimov.de>
 <20200708080239.2ce729f3@lwn.net>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <2aefc870-bf17-9528-958e-bc5b76de85dd@al2klimov.de>
Date:   Wed, 8 Jul 2020 20:58:39 +0200
MIME-Version: 1.0
In-Reply-To: <20200708080239.2ce729f3@lwn.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +
X-Spam-Level: *
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 08.07.20 um 16:02 schrieb Jonathan Corbet:
> On Wed,  8 Jul 2020 15:57:37 +0200
> "Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:
> 
>>   Documentation/arm/ixp4xx.rst | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> That's not XDP; something went awry in there somewhere.
RoFL. Now as you said it I... noticed it at all... (*sigh*, the curse of
automation) and I absolutely agree with you. But I've literally no idea...

➜  linux git:(master) perl scripts/get_maintainer.pl --nogit{,-fallback} 
--nol 0003-Replace-HTTP-links-with-HTTPS-ones-XDP-eXpress-Data-.patch
Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
Alexei Starovoitov <ast@kernel.org> (supporter:XDP (eXpress Data Path))
Daniel Borkmann <daniel@iogearbox.net> (supporter:XDP (eXpress Data Path))
"David S. Miller" <davem@davemloft.net> (supporter:XDP (eXpress Data Path))
Jakub Kicinski <kuba@kernel.org> (supporter:XDP (eXpress Data Path))
Jesper Dangaard Brouer <hawk@kernel.org> (supporter:XDP (eXpress Data Path))
John Fastabend <john.fastabend@gmail.com> (supporter:XDP (eXpress Data 
Path))
➜  linux git:(master) cat 
0003-Replace-HTTP-links-with-HTTPS-ones-XDP-eXpress-Data-.patch
 From 40aee4678ab84b925ab21581030a2cc0b988fbf9 Mon Sep 17 00:00:00 2001
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Date: Wed, 8 Jul 2020 08:00:39 +0200
Subject: [PATCH] Replace HTTP links with HTTPS ones: XDP (eXpress Data Path)

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
   If not .svg:
     For each line:
       If doesn't contain `\bxmlns\b`:
         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
             If both the HTTP and HTTPS versions
             return 200 OK and serve the same content:
               Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
  Documentation/arm/ixp4xx.rst | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm/ixp4xx.rst b/Documentation/arm/ixp4xx.rst
index a57235616294..d94188b8624f 100644
--- a/Documentation/arm/ixp4xx.rst
+++ b/Documentation/arm/ixp4xx.rst
@@ -119,14 +119,14 @@ http://www.gateworks.com/support/overview.php
     the expansion bus.

  Intel IXDP425 Development Platform
-http://www.intel.com/design/network/products/npfamily/ixdpg425.htm
+https://www.intel.com/design/network/products/npfamily/ixdpg425.htm

     This is Intel's standard reference platform for the IXDP425 and is
     also known as the Richfield board. It contains 4 PCI slots, 16MB
     of flash, two 10/100 ports and one ADSL port.

  Intel IXDP465 Development Platform
-http://www.intel.com/design/network/products/npfamily/ixdp465.htm
+https://www.intel.com/design/network/products/npfamily/ixdp465.htm

     This is basically an IXDP425 with an IXP465 and 32M of flash instead
     of just 16.
--
2.27.0

➜  linux git:(master)

> 
> jon
> 
