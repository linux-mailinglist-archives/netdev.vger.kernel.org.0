Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661FA2A6558
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbgKDNie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:38:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbgKDNid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:38:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIzP-005DCl-S7; Wed, 04 Nov 2020 14:38:15 +0100
Date:   Wed, 4 Nov 2020 14:38:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Santiago Leon <santi_leon@yahoo.com>,
        John Allen <jallen@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        Lijun Pan <ljp@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dany Madden <drt@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/12] net: ethernet: ibm: ibmvnic: Fix some kernel-doc
 misdemeanours
Message-ID: <20201104133815.GC933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-10-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104090610.1446616-10-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:07AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  from drivers/net/ethernet/ibm/ibmvnic.c:35:
>  inlined from ‘handle_vpd_rsp’ at drivers/net/ethernet/ibm/ibmvnic.c:4124:3:
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_field' not described in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'skb' not described in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_len' not described in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter or member 'hdr_data' not described in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_field' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_data' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'len' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'hdr_len' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter or member 'scrq_arr' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'txbuff' not described in 'build_hdr_descs_arr'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'num_entries' not described in 'build_hdr_descs_arr'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter or member 'hdr_field' not described in 'build_hdr_descs_arr'
>  drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'adapter' not described in 'do_change_param_reset'
>  drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'rwi' not described in 'do_change_param_reset'
>  drivers/net/ethernet/ibm/ibmvnic.c:1832: warning: Function parameter or member 'reset_state' not described in 'do_change_param_reset'
>  drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'adapter' not described in 'do_reset'
>  drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'rwi' not described in 'do_reset'
>  drivers/net/ethernet/ibm/ibmvnic.c:1911: warning: Function parameter or member 'reset_state' not described in 'do_reset'
> 
> Cc: Dany Madden <drt@linux.ibm.com>
> Cc: Lijun Pan <ljp@linux.ibm.com>
> Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Santiago Leon <santi_leon@yahoo.com>
> Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
> Cc: John Allen <jallen@linux.vnet.ibm.com>
> Cc: netdev@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
