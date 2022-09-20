Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668E05BE626
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiITMqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiITMq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:46:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2E0647E6;
        Tue, 20 Sep 2022 05:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=80B3pb2kVdHvDMeYZKND8LnZ7TZO0Pbin7ToBfsG8BQ=; b=Pv/OxwSjpE4X6yIZcI/Wk85dW5
        9Q6tbeAXeAngej1FSOnJopDE+XCvSMAp9VZZ5nsq3OX3N91xAJjOOhS+8t9IlFnOLrnVYX7FuDth5
        QHIgNrdJuVFnF/mzEDYr0xX4s9pl8NF03haoiUXruNfO6RdWXasCyWL8rduMf6z1BXX4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oacdv-00HGk8-1X; Tue, 20 Sep 2022 14:46:27 +0200
Date:   Tue, 20 Sep 2022 14:46:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Juergen Borleis <jbe@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: fec: limit register access on i.MX6UL
Message-ID: <Yym2I8SYMW7HRWLD@lunn.ch>
References: <20220920095106.66924-1-jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920095106.66924-1-jbe@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_75_100 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* for i.MX6ul */
> +static u32 fec_enet_register_offset_6ul[] = {
> +	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
> +	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
> +	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
> +	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
> +	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
> +	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
> +	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
> +	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
> +	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
> +	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
> +	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
> +	RMON_T_P_GTE2048, RMON_T_OCTETS,
> +	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
> +	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
> +	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
> +	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
> +	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
> +	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
> +	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
> +	RMON_R_P_GTE2048, RMON_R_OCTETS,
> +	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
> +	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
> +};
>  #else
>  static __u32 fec_enet_register_version = 1;

Seeing this, i wonder if the i.MX6ul needs its own register version,
so that ethtool(1) knows what registers are valid?

   Andrew
