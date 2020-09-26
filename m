Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE4E279CB8
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIZVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIZVvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 17:51:52 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5300C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 14:51:51 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w1so6123394edr.3
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 14:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r2M/UUEZHRXgeUMXMLnTfLAAVUvSObgzCBVvrG60xlk=;
        b=M4wvbMtdXl3UNxV33uxETrFfOuAxB3z1HSBpUrfCLcFK/dVw23CjND14mwPetzVLdx
         NNMDFr29drMuL+UMLgqlW24ukfyMCLX+w9K6F0ubcXQjm41/icq+l4ixfO3DTwPNHzaL
         y+T3PyXn4edqqAb8NTGVThzaem0/Ruwrs1p92deBdX/cOIr/LqXaFS4cMUMNoNKe4luj
         yaiU2rVVW9/P6GHsxqlQ5Nzy0NHXpiYZJMNsSqUxDTAjuvGD1wl+rQxwE5rjhCesNDr/
         6NF34c+8eAn2nqIx1Hl3OGdnYtH8vFbgJ+nsaLMlV+Bp1A4oB7a5SzqR3BC5NLJjq7HE
         e5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2M/UUEZHRXgeUMXMLnTfLAAVUvSObgzCBVvrG60xlk=;
        b=S3jr2EupQ+rXr9HsKFwpJJpO0TSUb/BBi2vzhKtdSMaptNAz5+SM2W0Cs451BFlt1s
         +twOZAMneyJ4UiH2cM+QE7iKwRiZsNz1tYDIPxEmnPiQJBfxAnwkZwrK+eyk30KI1IcU
         W/1mHHuSrxJdxGJftDD//WWMXvqAOM8a+6YT+Hm2ku3DpsKgYv1aQE4i5rjsWSQfejMp
         Vy4S3j8Sn62+1mCZ+rCg1c7RTM2IpLMEcqBODKpoGTIiI/vXke70z4lc2or958xRDeUv
         XcJaA7o1lCy5k/nDUyQWofKq+zAW6q4v9h/f6N3rnzS5+tyLN7DTS90wNdOVeKA+yYCy
         rY3g==
X-Gm-Message-State: AOAM533tJJa4gV3j83Jbu8FSfB6tY/PADOxf/bqmKaS3uQLpLmHerB0f
        sNfs6VI6Tu7jFajpjKWpjbE=
X-Google-Smtp-Source: ABdhPJxfdTkOkA7bxe/FyWr13lP27orMNcMDnyYMCPQZHhyiQmbUxNt7Hvl6CoCR7McyfzB5CDyp2Q==
X-Received: by 2002:a50:f102:: with SMTP id w2mr8549722edl.63.1601157110232;
        Sat, 26 Sep 2020 14:51:50 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id cn21sm5369660edb.14.2020.09.26.14.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 14:51:49 -0700 (PDT)
Date:   Sun, 27 Sep 2020 00:51:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200926215147.w7xjlozqs6i5pffm@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-2-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:26PM +0200, Andrew Lunn wrote:
> Not all ports of a switch need to be used, particularly in embedded
> systems. Add a port flavour for ports which physically exist in the
> switch, but are not connected to the front panel etc, and so are
> unused.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/uapi/linux/devlink.h | 3 +++
>  net/core/devlink.c           | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index a2ecc8b00611..e1f209feac74 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -195,6 +195,9 @@ enum devlink_port_flavour {
>  				      * port that faces the PCI VF.
>  				      */
>  	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
> +	DEVLINK_PORT_FLAVOUR_UNUSED, /* Port which exists in the switch, but
> +				      *	is not used in any way.

Nitpicking: there is an extraneous tab character here between "*" and "is".

> +				      */
>  };
>  
>  enum devlink_param_cmode {
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ac32b672a04b..fc9589eb4115 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -7569,7 +7569,8 @@ static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
>  {
>  	/* Ignore CPU and DSA flavours. */
>  	return devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
> -	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA;
> +	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA &&
> +	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_UNUSED;
>  }
>  
>  #define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 3600)
> @@ -7854,6 +7855,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  		break;
>  	case DEVLINK_PORT_FLAVOUR_CPU:
>  	case DEVLINK_PORT_FLAVOUR_DSA:
> +	case DEVLINK_PORT_FLAVOUR_UNUSED:
>  		/* As CPU and DSA ports do not have a netdevice associated
>  		 * case should not ever happen.
>  		 */
> -- 
> 2.28.0
> 
