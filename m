Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C986962AB9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405242AbfGHVOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:14:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32977 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732264AbfGHVOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:14:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so3404780pfq.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ec3RLAcaGcUATAhuXbEUjkg1n8nFb8G78jY1lJIpSwk=;
        b=Tzef4UBU9kd8gua7HeT6CVdvtUILs3KDNaZJpQFoRQd8q1agJ7MUOxWGApeb2oHIke
         wTTXRa7enmLn226Rjmn5DUbUDYpHL6OCDzPYZ9P1aYwFeW4gF/9dwsrhIKZTX2HHCPcu
         2X4lo81+v0QR2k5gIyu52bEeqqt4i7r7uoeWHqDDBGdPFbBTZ83Q6CZCWJmg95SdGNAH
         4h8N8Tf5FIYjdaJ/I8yNKNb775dWkmjSMq77mpSo/gMP6ZveqS15KU4luHiGibEF/2f4
         SmdBp2l/fF7M1oU/TSnCyA3zbMCtSA35HiFjenJWNXsDz84W9uuQxsxiLTZKoKpEgrd6
         tkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ec3RLAcaGcUATAhuXbEUjkg1n8nFb8G78jY1lJIpSwk=;
        b=RqYMPa8eh3yQfsA+TYhrBAs4jWnyP5oLG7jorbxgkkzcoNABJfnY0yadZMKtHCMlVw
         x+rwzRi8a/u7rbWwFfczomk2yj0BbOMvrVh2Jns8ye6O7jbkP8I9NzjC7MhV2DPXKBGj
         KenWsNI0PYOihxD/oq4xWGmZGtwsq9wTkymDN2lkJnbSrhKK7IciJBkbFKKNP9Yc1sLk
         1RzMHkJSPzZwsR1CGJ3jcPwmFO/zSpLWdpqblJox/VLQsMT57q+1Wl5GSCzbMOTQ6hQq
         YjDc5RmTjN/9zy7lNlSuWjHaUczScYMQDYzQaul5vUfUarzKASvaShKokB9BASN38pF9
         pJqg==
X-Gm-Message-State: APjAAAXsaYRACIjvUlk3HV+fJAfojs0Hu3miZ17XzCKTFIh2+Kuau768
        xwOaTe8zS36uWqP5Q2jWrjvn5w==
X-Google-Smtp-Source: APXvYqzNQfdKBJxBXy6Rk0hiQ1yqAI5YN6O//bnSRhW43uc4hiv5YmfGBfI+CXuqve2BsRkvX0Y6/Q==
X-Received: by 2002:a63:4104:: with SMTP id o4mr27142522pga.345.1562620446912;
        Mon, 08 Jul 2019 14:14:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s193sm20128473pgc.32.2019.07.08.14.14.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:14:06 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:14:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v5 3/5] devlink: Introduce PCI PF port flavour
 and port attribute
Message-ID: <20190708141403.1c01c5de@cakuba.netronome.com>
In-Reply-To: <20190708041549.56601-4-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190708041549.56601-1-parav@mellanox.com>
        <20190708041549.56601-4-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Jul 2019 23:15:47 -0500, Parav Pandit wrote:
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 3e5f8204c36f..88b2cf207cb2 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -519,6 +519,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
>  	if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PHYSICAL &&
>  	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
>  	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA)
>  		return 0;
> +	if (devlink_port->attrs.flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {

Thanks for making the changes!  I'm not sure how this would work, tho.
We return early if flavour is not phys/cpu/dsa, so how can flavour be
pci here?..

> +		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
> +				attrs->pci_pf.pf))
> +			return -EMSGSIZE;
> +	}
>  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
>  			attrs->physical.port_number))
>  		return -EMSGSIZE;
