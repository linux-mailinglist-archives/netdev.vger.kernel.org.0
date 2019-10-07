Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20E0CE1E8
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfJGMju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:39:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38141 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 08:39:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id l21so12265948edr.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 05:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ScqygqHqhblykeOiHVIIb6f1jzou9MchPMQ6lHct5k=;
        b=UKBl3EooJLX+0hC6g+2i7zWWW5wLXQebjyG4Y8xGIWztI/37/a2W45+MWiMecWQCFM
         DlHUYLotZQu3psGTQt+Hvp7y37N7QAaWSpSw6xvMffB/jsHhGlQ8Vr06jgRGmLHVPd72
         VhsbmitoMGY1Xn9nwSl4ba/x5pEozuaFeEfb8fiPhHLgbQnBZ+dgnv0b1frzfxwt7vru
         uwdzqP04nsQnyZeeMBkMLmCGOyA+5tt2mq1NnuYSK0BUh9P05edrRVOaaUBGVviwOYGj
         IwrGGD81Mu1LHiKcga+C3EbhpYCy6XkWHvTSzY9P4S5WlPOpftJHaq+7oNDi4/imhgN3
         CKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ScqygqHqhblykeOiHVIIb6f1jzou9MchPMQ6lHct5k=;
        b=UZltL4PUtRSfhuTnHGaK8D+JOoeOI36YI0SCtj0jXsCG2Gw/aqP1xirg2Zl3auWIoB
         YPCtSa4lnjvw24NmTWuaGGOGkKAC8L2Z2Xsed9wvDI56tRB02e/wDwpEg/8EARmkhJje
         eLNOS2ONORS0dstm7+CDUbckhqLQzAZmPNEYjL1+1zso4NBDZdO+NkG8yzHiPZsIIJXb
         KpnNQ5gbQa/c1AFF9VRKdE+/Lzf+AAyq6WfSxOpcqcKA7xnwV1IF4eIIi8XewUNzJLZH
         buzs+80PGBzoCFGA58j46VEU16DLKM1WyTrfddv3l9eue3v5wTauzGZ9j7hWU2vITpHN
         gkcA==
X-Gm-Message-State: APjAAAW6/WsIfO3/+iGPtH4PaB4WSA3y8dAaf/cGDqwpEnwa9rNa+M61
        +hygbttAj+0J/kdvNf3Cc3nurg==
X-Google-Smtp-Source: APXvYqyMo/7iBBsJLa2jNjUskZiKdAh7yZoehRTO1t4NHNz/Hip2v5MGc+u3zaWLenAD5vS4juUWdQ==
X-Received: by 2002:a17:906:fc11:: with SMTP id ov17mr23327346ejb.288.1570451985947;
        Mon, 07 Oct 2019 05:39:45 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id a20sm3323827edt.95.2019.10.07.05.39.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Oct 2019 05:39:45 -0700 (PDT)
Date:   Mon, 7 Oct 2019 14:39:45 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 6/7] ip6tlvs: Add netlink interface
Message-ID: <20191007123943.blsqqr3my4jmklqy@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-7-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-7-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:58:03PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Add a netlink interface to manage the TX TLV parameters. Managed
> parameters include those for validating and sending TLVs being sent
> such as alignment, TLV ordering, length limits, etc.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>

Hi Tom,

I am wondering if you considered including extack support in this code.

...

> diff --git a/include/uapi/linux/ipeh.h b/include/uapi/linux/ipeh.h
> index dbf0728..bac36a7 100644
> --- a/include/uapi/linux/ipeh.h
> +++ b/include/uapi/linux/ipeh.h
> @@ -21,4 +21,33 @@ enum {
>  	IPEH_TLV_PERM_MAX = IPEH_TLV_PERM_NO_CHECK
>  };
>  
> +/* NETLINK_GENERIC related info for IP TLVs */
> +
> +enum {
> +	IPEH_TLV_ATTR_UNSPEC,
> +	IPEH_TLV_ATTR_TYPE,			/* u8, > 1 */
> +	IPEH_TLV_ATTR_ORDER,			/* u16 */
> +	IPEH_TLV_ATTR_ADMIN_PERM,		/* u8, perm value */
> +	IPEH_TLV_ATTR_USER_PERM,		/* u8, perm value */

My reading of struct tlv_tx_params is that admin_perm and user_perm are
2-bit entities whose valid values are currently 0, 1 and 2. Perhaps that
would be worth noting here in keeping with restrictions noted for other
attributes.

> +	IPEH_TLV_ATTR_CLASS,			/* u8, 3 bit flags */
> +	IPEH_TLV_ATTR_ALIGN_MULT,		/* u8, 1 to 16 */
> +	IPEH_TLV_ATTR_ALIGN_OFF,		/* u8, 0 to 15 */
> +	IPEH_TLV_ATTR_MIN_DATA_LEN,		/* u8 (option data length) */
> +	IPEH_TLV_ATTR_MAX_DATA_LEN,		/* u8 (option data length) */
> +	IPEH_TLV_ATTR_DATA_LEN_MULT,		/* u8, 1 to 16 */
> +	IPEH_TLV_ATTR_DATA_LEN_OFF,		/* u8, 0 to 15 */
> +
> +	__IPEH_TLV_ATTR_MAX,
> +};
> +
> +#define IPEH_TLV_ATTR_MAX              (__IPEH_TLV_ATTR_MAX - 1)

...

> diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
> index feaa4a6..e3c1f33 100644
> --- a/net/ipv6/exthdrs_common.c
> +++ b/net/ipv6/exthdrs_common.c
> @@ -454,6 +454,244 @@ int __ipeh_tlv_unset(struct tlv_param_table *tlv_param_table,

...

> +int ipeh_tlv_nl_cmd_set(struct tlv_param_table *tlv_param_table,
> +			struct genl_family *tlv_nl_family,
> +			struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct tlv_params new_params;
> +	struct tlv_proc *tproc;
> +	unsigned char type;
> +	unsigned int v;
> +	int retv = -EINVAL;
> +
> +	if (!info->attrs[IPEH_TLV_ATTR_TYPE])
> +		return -EINVAL;
> +
> +	type = nla_get_u8(info->attrs[IPEH_TLV_ATTR_TYPE]);
> +	if (type < 2)
> +		return -EINVAL;
> +
> +	rcu_read_lock();
> +
> +	/* Base new parameters on existing ones */
> +	tproc = ipeh_tlv_get_proc_by_type(tlv_param_table, type);
> +	new_params = tproc->params;
> +
> +	if (info->attrs[IPEH_TLV_ATTR_ORDER]) {
> +		v = nla_get_u16(info->attrs[IPEH_TLV_ATTR_ORDER]);
> +		new_params.t.preferred_order = v;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_ADMIN_PERM]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ADMIN_PERM]);
> +		if (v > IPEH_TLV_PERM_MAX)
> +			goto out;
> +		new_params.t.admin_perm = v;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_USER_PERM]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_USER_PERM]);
> +		if (v > IPEH_TLV_PERM_MAX)
> +			goto out;
> +		new_params.t.user_perm = v;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_CLASS]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_CLASS]);
> +		if (!v || (v & ~IPEH_TLV_CLASS_FLAG_MASK))
> +			goto out;
> +		new_params.t.class = v;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_ALIGN_MULT]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ALIGN_MULT]);
> +		if (v > 16 || v < 1)
> +			goto out;
> +		new_params.t.align_mult = v - 1;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_ALIGN_OFF]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ALIGN_OFF]);
> +		if (v > 15)
> +			goto out;
> +		new_params.t.align_off = v;
> +	}
> +
> +	if (info->attrs[IPEH_TLV_ATTR_MAX_DATA_LEN])
> +		new_params.t.max_data_len =
> +		    nla_get_u8(info->attrs[IPEH_TLV_ATTR_MAX_DATA_LEN]);
> +
> +	if (info->attrs[IPEH_TLV_ATTR_MIN_DATA_LEN])
> +		new_params.t.min_data_len =
> +		    nla_get_u8(info->attrs[IPEH_TLV_ATTR_MIN_DATA_LEN]);
> +
> +	if (info->attrs[IPEH_TLV_ATTR_DATA_LEN_MULT]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_DATA_LEN_MULT]);
> +		if (v > 16 || v < 1)
> +			goto out;
> +		new_params.t.data_len_mult = v - 1;
> +	}

Is some sanity checking warranted for the min/max data len values.
f.e. that min <= max ?

> +
> +	if (info->attrs[IPEH_TLV_ATTR_DATA_LEN_OFF]) {
> +		v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_DATA_LEN_OFF]);
> +		if (v > 15)
> +			goto out;
> +		new_params.t.data_len_off = v;
> +	}
> +
> +	retv = ipeh_tlv_set_params(tlv_param_table, type, &new_params);
> +
> +out:
> +	rcu_read_unlock();
> +	return retv;
> +}
> +EXPORT_SYMBOL(ipeh_tlv_nl_cmd_set);

...
