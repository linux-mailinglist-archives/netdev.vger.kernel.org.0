Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17934B5EEF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiBOASU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:18:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiBOASU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:18:20 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F9312152F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:18:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f17so29589105edd.2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wU6XcxsBb6FwBdvGaigyrofCKOdAP8+vrdeJ8Yygt2s=;
        b=NnnDqHxxsqZsqCd0dj6WRlVlbIYO2E3wQU71Y5DsYoRvR5td1g79T+09njQJC0FKMH
         QmeNxHCoCbgvg/9TATvV39PK4i7meHTyrHFnYk8MEIHOBl0U2VZkf1C1UWOFAgn/2GND
         87hy2uIsVx3r6R+ZIC1Z2gkaRwBFw11ON6cgEI54eJWJq35uyPkZFy5Rflx4BPYwZvot
         PyP08g+q+9o5ExO2eojgcKRiSnL9c44I+miX+a++zZOPeM7ptHkc/oBHRfOpllPZv52j
         5Sj3H+jloKrbdt4ankaaEPV3lqbDQR9rj78y8TvBCrSuTBfRnvlHZAuLN8avJ9h5DPtx
         YL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wU6XcxsBb6FwBdvGaigyrofCKOdAP8+vrdeJ8Yygt2s=;
        b=Q6CMfEm8G9t9YOKcOxI27OqPfCCm42a3rqerPzA9SbXpywbdohUcB07SvNf9YQ5ON+
         tUK6gOghiW7vklhj5lBjjQ6CAfvO8O+lxnrbyppJOmLkLno/01gLLPHrttuTmv1/GPOC
         wGT0o35JZJIKIJZ8jRGM98xzecQxFj+/3Z+yXMuJPsMyCDXo4FtLVdQua0uFslZO1Pm1
         7yPI8WjTchF4z0PSQsFPSV5anzUxaiVwB2ZoWOLeOGvMpMOykHJboUSWSDIT+ToUUip4
         d6o+nE7qnVunbEzSTq2jHlNw79oyV0RXz4O5AHad2xwxu+JP/5zniZ3Nt+Ya4QXAT1L4
         3GvQ==
X-Gm-Message-State: AOAM531b2KJHmTFkaDtN22fp8RxT+4Evtu1jI5jB/X9WUmnrdiauxfMg
        MylAWhxedLzi8bLxJI51yv4=
X-Google-Smtp-Source: ABdhPJxja9kIcRuNKQaQa9h6aseyRqIW7IOBMdpFre9Zm/tnWKwLYNt9t2Sn7QBUwOAOr0tbta1XvQ==
X-Received: by 2002:a50:9d0d:: with SMTP id v13mr1454253ede.242.1644884289929;
        Mon, 14 Feb 2022 16:18:09 -0800 (PST)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id 9sm3376938ejd.184.2022.02.14.16.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:18:09 -0800 (PST)
Date:   Mon, 14 Feb 2022 16:18:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org,
        Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Message-ID: <20220215001807.GA16337@hoboy.vegasvil.org>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 03:15:36PM -0800, Tony Nguyen wrote:

> diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> index fd8ee5b7f596..a23a9ea10751 100644
> --- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> @@ -1401,6 +1401,24 @@ struct ice_aqc_get_link_topo {
>  	u8 rsvd[9];
>  };
>  
> +/* Read I2C (direct, 0x06E2) */
> +struct ice_aqc_i2c {
> +	struct ice_aqc_link_topo_addr topo_addr;
> +	__le16 i2c_addr;
> +	u8 i2c_params;
> +#define ICE_AQC_I2C_DATA_SIZE_S		0
> +#define ICE_AQC_I2C_DATA_SIZE_M		(0xF << ICE_AQC_I2C_DATA_SIZE_S)
> +#define ICE_AQC_I2C_USE_REPEATED_START	BIT(7)

Nit:  #define belongs at top of file, or at least outside of structure definition.

> +	u8 rsvd;
> +	__le16 i2c_bus_addr;
> +	u8 rsvd2[4];
> +};

Thanks,
Richard
