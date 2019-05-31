Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C940309FE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEaIQm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 May 2019 04:16:42 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:49899 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaIQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:16:42 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 04:16:42 EDT
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=Paul.Durrant@citrix.com; spf=Pass smtp.mailfrom=Paul.Durrant@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL01.citrite.net
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  Paul.Durrant@citrix.com) identity=pra;
  client-ip=23.29.105.83; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="Paul.Durrant@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa6.hc3370-68.iphmx.com: domain of
  Paul.Durrant@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="Paul.Durrant@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL01.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL01.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: MuFDzrJnaA4RhYJ96ED2uey0fkt9GUZ9QvgjXsm4lQ3MCgXuwE1tUgqnhxr8RX3blU5cMZ0qAq
 +L/7Omh/Mek4+wVc9cdH+iZHvg3O2+Vh/vk4sLoHwnS47H9HpH+jYkXQfb3wKWZ5lGZ3s2jJfx
 2I0ZVXZiC1BQ9bijpZA+prpr6J83fTGga2C0IXEeUFsBABgtWSPB8lZYcs3xbZz7QVo3bze2ns
 mJCzaWCo7xa0TYZx2PZycCqXhMmWMcPYi5G8zryECCfdFyplCo2DaBhrq9lJ8aepD+AAv3slrd
 IEw=
X-SBRS: 2.7
X-MesageID: 1118491
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,534,1549947600"; 
   d="scan'208";a="1118491"
From:   Paul Durrant <Paul.Durrant@citrix.com>
To:     Wei Liu <wei.liu2@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Xen-devel <xen-devel@lists.xenproject.org>,
        David Miller <davem@davemloft.net>,
        Wei Liu <wei.liu2@citrix.com>
Subject: RE: [PATCH net-next] Update my email address
Thread-Topic: [PATCH net-next] Update my email address
Thread-Index: AQHVF4LOwmQKDAbmA0WtXQmNdTyAy6aE4S7A
Date:   Fri, 31 May 2019 08:09:34 +0000
Message-ID: <619c8073a46446ce819addd44bd03756@AMSPEX02CL03.citrite.net>
References: <20190531073102.5334-1-wei.liu2@citrix.com>
In-Reply-To: <20190531073102.5334-1-wei.liu2@citrix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Wei Liu [mailto:wei.liu2@citrix.com]
> Sent: 31 May 2019 08:31
> To: netdev@vger.kernel.org
> Cc: Xen-devel <xen-devel@lists.xenproject.org>; Paul Durrant <Paul.Durrant@citrix.com>; David Miller
> <davem@davemloft.net>; Wei Liu <wei.liu2@citrix.com>
> Subject: [PATCH net-next] Update my email address
> 
> Signed-off-by: Wei Liu <wei.liu2@citrix.com>

Acked-by: Paul Durrant <paul.durrant@citrix.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0c55b0fedbe2..e212c6a42ddf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17295,7 +17295,7 @@ F:	Documentation/ABI/stable/sysfs-hypervisor-xen
>  F:	Documentation/ABI/testing/sysfs-hypervisor-xen
> 
>  XEN NETWORK BACKEND DRIVER
> -M:	Wei Liu <wei.liu2@citrix.com>
> +M:	Wei Liu <wei.liu@kernel.org>
>  M:	Paul Durrant <paul.durrant@citrix.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  L:	netdev@vger.kernel.org
> --
> 2.20.1

