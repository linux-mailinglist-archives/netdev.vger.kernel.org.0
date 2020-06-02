Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0781EBFC0
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgFBQQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgFBQQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 12:16:16 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1C7206E2;
        Tue,  2 Jun 2020 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591114575;
        bh=wXgLOJxVGle1BDxCZNtuXoFbDdCWnNg1OH84w9X05l0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l9YSxmW+mSqCwSe+Qk3zGCtQZYJBcK9aDNk/389Q2PeGZ7CHpbNZTQ6Zmeren9V8A
         TZs+3tnI3hycomY/NjW0OO2iYC9McOh3nQ5c+0WDdEXKky/daU+wgdrBYwk/0tSPgt
         bBd9R8n53PUbO/gANSXNAYO+rY2FCZdZEW/2ZpPg=
Date:   Tue, 2 Jun 2020 09:16:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH v2 net-next 05/10] net: mscc: ocelot: VCAP IS1 support
Message-ID: <20200602091613.73d692a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602051828.5734-6-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
        <20200602051828.5734-6-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 13:18:23 +0800 Xiaoliang Yang wrote:
> VCAP IS1 is a VCAP module which can filter MAC, IP, VLAN, protocol, and
> TCP/UDP ports keys, and do Qos classified and VLAN retag actions.
>=20
> This patch added VCAP IS1 support in ocelot ace driver, which can supports
> vlan modify and skbedit priority action of tc filter.
> Usage:
> 	tc qdisc add dev swp0 ingress
> 	tc filter add dev swp0 protocol 802.1Q parent ffff: flower \
> 	skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2
>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

drivers/net/dsa/ocelot/felix_vsc9959.c:570:19: warning: symbol 'vsc9959_vca=
p_is1_keys' was not declared. Should it be static?
drivers/net/dsa/ocelot/felix_vsc9959.c:621:19: warning: symbol 'vsc9959_vca=
p_is1_actions' was not declared. Should it be static?
drivers/net/ethernet/mscc/ocelot_ace.c: In function =C3=A2=E2=82=AC=CB=9Cis=
1_entry_set=C3=A2=E2=82=AC=E2=84=A2:
drivers/net/ethernet/mscc/ocelot_ace.c:733:27: warning: variable =C3=A2=E2=
=82=AC=CB=9Cip_data=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 733 |   struct ocelot_vcap_u48 *ip_data;
     |                           ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:732:32: warning: variable =C3=A2=E2=
=82=AC=CB=9Cds=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-set-v=
ariable]
 732 |   struct ocelot_vcap_u8 proto, ds;
     |                                ^~
drivers/net/ethernet/mscc/ocelot_ace.c:727:51: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_psh=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 727 |   enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
     |                                                   ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:727:42: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_rst=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 727 |   enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
     |                                          ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:727:33: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_syn=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 727 |   enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
     |                                 ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:727:24: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_fin=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 727 |   enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
     |                        ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:726:33: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_urg=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 726 |   enum ocelot_vcap_bit tcp_ack, tcp_urg;
     |                                 ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:726:24: warning: variable =C3=A2=E2=
=82=AC=CB=9Ctcp_ack=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-=
set-variable]
 726 |   enum ocelot_vcap_bit tcp_ack, tcp_urg;
     |                        ^~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:725:24: warning: variable =C3=A2=E2=
=82=AC=CB=9Cttl=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but-set-=
variable]
 725 |   enum ocelot_vcap_bit ttl, fragment, options;
     |                        ^~~
drivers/net/ethernet/mscc/ocelot_ace.c:724:24: warning: variable =C3=A2=E2=
=82=AC=CB=9Cseq_zero=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-but=
-set-variable]
 724 |   enum ocelot_vcap_bit seq_zero, tcp;
     |                        ^~~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:723:36: warning: variable =C3=A2=E2=
=82=AC=CB=9Csport_eq_dport=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunus=
ed-but-set-variable]
 723 |   enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport;
     |                                    ^~~~~~~~~~~~~~
drivers/net/ethernet/mscc/ocelot_ace.c:723:24: warning: variable =C3=A2=E2=
=82=AC=CB=9Csip_eq_dip=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-b=
ut-set-variable]
 723 |   enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport;
     |                        ^~~~~~~~~~
