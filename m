Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B239A2123B2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgGBMw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:52:29 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47408 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729000AbgGBMwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 08:52:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 19E1F600AE;
        Thu,  2 Jul 2020 12:52:24 +0000 (UTC)
Received: from us4-mdac16-69.ut7.mdlocal (unknown [10.7.64.188])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 167F18009B;
        Thu,  2 Jul 2020 12:52:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99C7528005C;
        Thu,  2 Jul 2020 12:52:23 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2CA76A40075;
        Thu,  2 Jul 2020 12:52:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 13:52:18 +0100
Subject: Re: [PATCH net-next 01/15] sfc: support setting MTU even if not
 privileged to configure MAC fully
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>,
        Matthew Slattery <mslattery@solarflare.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
 <db235d46-96b0-ee6d-f09b-774e6fd9a072@solarflare.com>
 <20200701120311.4821118c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3b76efb6-4b02-a26d-5284-65ab37b79ef5@solarflare.com>
 <20200701161636.3399d902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <dcf4cd6d-852e-470c-97d7-9ecac2b01909@solarflare.com>
Date:   Thu, 2 Jul 2020 13:52:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200701161636.3399d902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-4.057700-8.000000-10
X-TMASE-MatchedRID: 6lay9u8oTUPmLzc6AOD8DfHkpkyUphL9+IfriO3cV8S60YSotNAEAaYi
        WP3aRz188Rp7Tule6dEuwVUIyAnb/6Gnquim0WHzN19PjPJahlJMkOX0UoduucFKi4VGOHQCqzs
        f3Jwr9ui9MU2jw9S6SLaSYwPCkJzm7a5dyb9gTluqNnzrkU+2mg6Q6jcoR+5pe/eKgB30qtJVds
        3zwgq4tIWEWUKkKeAkM+kmV2nXHxbxkb6LzfJ2UBSceev8ZtpP1wL0WtLXyRonA7VJKtQPnp62L
        mVTodVc3pdoV72Pca/TMj+5r/4Bdusc22+Ah2rbsFkCLeeufNsOZNXmvnJaeiNGK7UC7ElM43vG
        oPn/75lgSb4kd+7HJdjiRir+OioWnBrl0ok/9ei5xbPXEl8dZtPaSXiLjsu7X1Ahz57P/j5qQKt
        eErN22bedi2bvzW7j+9AI+LLwgRy/WXZS/HqJ2gtuKBGekqUpm+MB6kaZ2g6UZERFFIClNhn6o5
        k1jkuX/+MqKcWGl8q24ZMYLscAzhXzzNzH1zIZET89uGBnyLVZuv895W/y8i/+4JnpTNYN1tqAj
        jsYv/iHzGTHoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.057700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593694344-NEnaTZtEcmd5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 00:16, Jakub Kicinski wrote:
> I see. I'm actually asking because of efx_ef10_set_udp_tnl_ports().
> I'd like to rewrite the UDP tunnel code so that 
> NETIF_F_RX_UDP_TUNNEL_PORT only appears on the interface if it 
> _really_ can do the offload. ef10 is the only driver I've seen where 
> I can't be sure what FW will say.. (other than liquidio, but that's 
> more of a kernel<->FW proxy than a driver, sigh).
I suppose it's time for me to describe the gory details ofhow EF10
 tunnel offloads work, then.  When changing the list of UDP tunnel
 ports, the MC patches the header-recogniser firmware and reboots
 the datapath CPUs (packet parsing on EF10 is done on a pair of
 DPCPUs with specialised instruction set extensions, and it wasn't
 originally designed with tunnel offloads in mind).  Unfortunately,
 to synchronise everything afterwards, the MC then has to reboot
 itself too.
Needless to say, this is fairly disruptive, especially as it's
 global across _both_ ports of a two-port NIC (which is what that
 EIO check in efx_ef10_set_udp_tnl_ports() is about: when you bring
 up a tunnel device, both netdevs get the ndo callback, the first
 one offloads the port, causing a reboot, which interrupts the
 second port's MCDI.  Once the MC comes back up, the second netdev
 tries again to offload the UDP port, and this time the MC only has
 to increase a refcount, since the first netdev already added that
 port, so it can return success without another reboot).

> Is there anything I can condition on there?
I _believe_ this is determined by another drv_attach flag,
 MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, but again I'm not 100%
 sure; it might be the PRIMARY flag instead.  I've CCed Matthew
 Slattery from our firmware team who should be able to answer.
It also depends on the VXLAN_NVGRE firmware capability, which
 efx_ef10_set_udp_tnl_ports() already checks.  Note that firmware
 capabilities can also change on an MC reboot (see the code that
 handles nic_data->must_check_datapath_caps).

-ed
