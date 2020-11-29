Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655552C7AC0
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgK2Sox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:44:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgK2Sow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 13:44:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjRfu-009NuK-W6; Sun, 29 Nov 2020 19:43:54 +0100
Date:   Sun, 29 Nov 2020 19:43:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Santiago Leon <santi_leon@yahoo.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/8] net: ethernet: ibm: ibmvnic: Fix some kernel-doc
 misdemeanours
Message-ID: <20201129184354.GL2234159@lunn.ch>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
 <20201126133853.3213268-6-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126133853.3213268-6-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee

>  /**
>   * build_hdr_data - creates L2/L3/L4 header data buffer
> - * @hdr_field - bitfield determining needed headers
> - * @skb - socket buffer
> - * @hdr_len - array of header lengths
> - * @tot_len - total length of data
> + * @hdr_field: bitfield determining needed headers
> + * @skb: socket buffer
> + * @hdr_len: array of header lengths
> + * @tot_len: total length of data
>   *
>   * Reads hdr_field to determine which headers are needed by firmware.
>   * Builds a buffer containing these headers.  Saves individual header

The code is:

static int build_hdr_data(u8 hdr_field, struct sk_buff *skb,
                          int *hdr_len, u8 *hdr_data)
{

What about hdr_data? 

>  /**
>   * create_hdr_descs - create header and header extension descriptors
> - * @hdr_field - bitfield determining needed headers
> - * @data - buffer containing header data
> - * @len - length of data buffer
> - * @hdr_len - array of individual header lengths
> - * @scrq_arr - descriptor array
> + * @hdr_field: bitfield determining needed headers
> + * @data: buffer containing header data
> + * @len: length of data buffer
> + * @hdr_len: array of individual header lengths
> + * @scrq_arr: descriptor array

static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
                            union sub_crq *scrq_arr)

There is no data parameter.

It looks like you just changes - to :, but did not validate the
parameters are actually correct.

	   Andrew
