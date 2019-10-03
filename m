Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D80CB05C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389533AbfJCUnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:43:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:52565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJCUnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 16:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1570135423;
        bh=l2CbPv9jk4BcyrfIzeSPwwhOsl4Gd994nCXq0Vmbh28=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=itpAuLG84a5TUKCzS4QroJhxcXIOyGIK/3l0uC3RRKfoPQmpDO7JLQIvbookLTHts
         5qzFd/FfR01jdjjd6UgWr1vwXo6doCEnrZoe7VP2Ho6JUDGwTGU6SwYp+h00/0jAL9
         NZmXkkdtm8x73zM6BjEfa98fe1NlgLSkLQ8k/FPk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([89.0.25.131]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N8GQy-1i30vu3TRA-014Gha; Thu, 03
 Oct 2019 22:43:42 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: phy: Improve phrasing
Date:   Thu,  3 Oct 2019 22:43:22 +0200
Message-Id: <20191003204322.32349-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XJsOsYtApZH0rV1lXp8DalL+58oNvmqsYzOrgY1nQM537zaV0ba
 ZYqC9w+If/nsL+aYKTkGs5WUHTh8PUsl4tu+ktuXKF334p4voyzC8wB+i7abuL8W5XVomVN
 +IxsM5+75B3cfxmQQPhc1xMDPkY30Xgbh0BcXRIbXla+94DHHu0z6djVOt4Q4sQ3L4UuA/v
 eH//bM8/btqpZ0Y8uyckg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yH8n8hS1C+o=:PeQ8fC747eH8ki7EEwTzEO
 ncS3Zp4nIDKNYBs4EyIyjkeIGO1yhVPyvv/0EP/KSNcH4zF/Y8QZArL2HmTuYQJkrbOdbWkag
 CFQwrlvZyQPYmzfFPCSluR94hpIpzk+OjUT2AIXHBMsjolfKRFcGKuPD2BAUVkJmbUSk+i0H2
 g/2fmZbaVoE/8aYgOVUNgEtKPWsL6Jq1AQ2Me26ITtA2tDSqDKVc/wcOpbP818j1l6XVv+gWn
 l+qD+LSkFlP3vBb2s6avIYCzstS5it+IDYzdkLAo1ScuGcM0bzJYOhq1NlduVi9Ddir7nbEmi
 w3iYRJ4tO8v6hfZ0Ha1p2oRRF+e7LxEspnSehQs0zeVLUG34JM19+wvv+NFxk+mdPpahVDT9G
 fUAORsHlsNx0yqaBHB1NYBRc1Y6mXiZxtrVo5fgkklM4RKPkWbXDJCtCEZaCc+XAYBnVOakEx
 e08MlaE/pzgIXZBc0fi9pQTOz/lIk0f8ZCS3E/zQXkdKIqKoVRPOoH+12XzJ6ek9NMnVKPRRU
 JiagGotCF8tEEDf7lxC8l7Y84/koh/IPe7hkAs2FuTaqhVwJKZFoCcSIw3TMf3RFDCB/OLCx5
 C2+S9ZvlFEACFFyzR6bAOYsY5t/PmlCLOkz4oBS+KOc28Y5CqR3psFuurVF0emO2TcG+yQxbu
 QJaxxXojsyKLoi/mztSo1YoGxP0Cxi+51hPle3s0xiQy/Z46h/RGMiB01CCZi8ywBF0nL5BxQ
 P6KpcdZnTudijwWg3+DifpDUKq05OzUxXElnDC0EavWLF72hpVa3ICglD+yor5D/yxSf9LW4n
 f3E8UXba79OYiOLe0FZujqtsfuZKuCfN5QwRpoXb3eUZpvVeUgf5Zzp9zJ1vnt7iSdwOtjQuY
 /+ESeDcIDCylrMCJzPr/7InF+oEI5Ey7d0/XEI29rfBZ6PZ5CCyo31FwpbvtPS5nqgG4AMZ3l
 8x9o3jJQ/62YZ4SbsmKUVpSFTYzUWT0aeFiKbz/4J66+b0EdF/bO5s8sXUHoLqCwGDNfRsjx6
 suVeLmOYnYZm4knRgUVXv9SGLddPou9+3rUwTwamqmxkVbG4jtLpRjjTc9LniqqcORCpWs10O
 YO0zNoKYZXXzIP4UrJkDwxFqz7NoFTrdU73iwOeXfs9uVUosl7drKOlxE+CkkHDpTR3GQh9mM
 Umafhbn3yjr+6gEQOEakDOCbi2LvbB9SEBx4htN0Op0wUBTxLbOeyZjhpUo69r9W2t//RyX6N
 Sv/ZDuAx3yGIEa4rHZDAN6+6wzak/nrTblfPJmeLpYdwkchxzyuZoqq938+c=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not about times (multiple occurences of an event) but about the
duration of a time interval.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/phy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/p=
hy.rst
index a689966bc4be..3f5bd83034df 100644
=2D-- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -73,7 +73,7 @@ The Reduced Gigabit Medium Independent Interface (RGMII)=
 is a 12-pin
 electrical signal interface using a synchronous 125Mhz clock signal and s=
everal
 data lines. Due to this design decision, a 1.5ns to 2ns delay must be add=
ed
 between the clock line (RXC or TXC) and the data lines to let the PHY (cl=
ock
-sink) have enough setup and hold times to sample the data lines correctly=
. The
+sink) have a large enough setup and hold time to sample the data lines co=
rrectly. The
 PHY library offers different types of PHY_INTERFACE_MODE_RGMII* values to=
 let
 the PHY driver and optionally the MAC driver, implement the required dela=
y. The
 values of phy_interface_t must be understood from the perspective of the =
PHY
=2D-
2.20.1

