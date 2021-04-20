Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636213660D0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhDTUYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:24:18 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.189]:32696 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbhDTUYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:24:18 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 14BF22E2DC54
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:23:46 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwuQlH3XeL7DmYwuQlP87a; Tue, 20 Apr 2021 15:23:46 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XmXbqCPJV/OrpMCpazFLpdiIX4d1RXv8x7B5GTngaNc=; b=vA+MJ707zhfMvB+p29s160IQy2
        dkTb3B/8W4WYXhrY8P34dJNYp6QGaWCDLDKLTG1T421EDX/r2kfrbT7JibX8E6btGtJDdk+fwUReA
        yhSS/+ru/Hm1/+LPLDhHp4KTqCBW1a3u8NVRnQHPVIpt8qVz42C7YTpUgWhlkfuukmHwDRsE88hlZ
        NFurL/88QUjB230fo+l/SE20MSEQZko5Upx36CUemBVpkKPCxYlw1P7+9UKBX7hMwAjqYxM/cg1mV
        H4eyZZfzyDtUTs6bDPQNgcPmyaesCj/smOWqXLRAS2N9MDzf4cH3VXZepoeR22tlVQN/t0uEfjrvr
        KUBzltPA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49028 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwuM-0030nY-HA; Tue, 20 Apr 2021 15:23:42 -0500
Subject: Re: [PATCH RESEND][next] netxen_nic: Fix fall-through warnings for
 Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094529.GA140903@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <7b648909-c16d-4f52-7524-896b7e2fdb52@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:23:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305094529.GA140903@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYwuM-0030nY-HA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49028
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 157
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:45, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a goto statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> index 08f9477d2ee8..35ec9aab3dc7 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
> @@ -1685,6 +1685,7 @@ netxen_process_rcv_ring(struct nx_host_sds_ring *sds_ring, int max)
>  			break;
>  		case NETXEN_NIC_RESPONSE_DESC:
>  			netxen_handle_fw_message(desc_cnt, consumer, sds_ring);
> +			goto skip;
>  		default:
>  			goto skip;
>  		}
> 
