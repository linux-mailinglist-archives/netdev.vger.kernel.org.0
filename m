Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C6326E605
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIQUBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIQUBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:01:53 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951D5C061355
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:01:53 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i17so3895744oig.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Z9IEifRyYIRxugAXy/Te8i38PzmUV69+z6nind98fc=;
        b=tp2OfrZlMhIZEGolSQx5yPdE9JnZx0vvTBIsrT+4VRZ/hulLyGiWQPcwIpaQxqUqzc
         yp3SbjaMnb+6Z+S3I0qpyR7QXK7oYeFWK47vYXi8Fgz9Jl+xXwcEPH+8NebHNQTNNea7
         4DF5joSKZmvWODnenNp/VJtYSh5p8Gtd/r8/9OtnU0++lXpVhBOufphKEssIzqVSFECn
         cK4S3bxz3/4cwmzmeewA5OlOXLFCAx9y5DUhQADt9EbH3rtwVeu9frsZIaMHckH729pa
         7x5OydSrYq1aqKYuNRzTnyUuJcH7Sbjjwmm0+ILJY+nIJdZRs8vbpLxx+2nBbuDDTOyl
         57iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Z9IEifRyYIRxugAXy/Te8i38PzmUV69+z6nind98fc=;
        b=aA9N0+98IwC64+0X6K7U/d0njEWnAKlpQGQdiUF3PGSNdugPJ1ALRZ6ZbncNlbIaP1
         MGfAcrT6bwyDaFwqzCxwMcbRopFeEEsFJq+xsX9KGmBWon4Eyo21pkuWZRKLkshP18AG
         WTh2MJMpuMCZ/ixbeUtOEIg97lbFmheHN/xp4hMvASJuZxBNRQJSGDfCAF5IX2qkK+qS
         2QlsCO664hzc+NhRCO4SsUMuM//iCvuycKinEpM81Rt3y3jppeYUa10DMpVqMaWSzNB7
         qr+1mcP4ulTFqqMCWbj2Wu9tlUeeNvYW14mucbruyxB99it0urfHeDsG/ggJCY9TPd2Y
         koNw==
X-Gm-Message-State: AOAM532TYMDBAoqT/WWcrec2+ugPdqkLSlIlgnTLPrpaJEsTOQY9OX8e
        W0V3YqgLHxjpn002ee9m4To=
X-Google-Smtp-Source: ABdhPJzR2azNDtLU4slHEiJ+qklmQxpNFS8ZAWlK6sJB2UgxLrcuvLVtAu/eRF9/gmNJAKh3zpAbUA==
X-Received: by 2002:aca:60d5:: with SMTP id u204mr6973834oib.8.1600372912980;
        Thu, 17 Sep 2020 13:01:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b5c4:4acf:b5cf:24fe])
        by smtp.googlemail.com with ESMTPSA id m15sm867039ooj.10.2020.09.17.13.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:01:52 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
To:     Parav Pandit <parav@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
Date:   Thu, 17 Sep 2020 14:01:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917172020.26484-2-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 11:20 AM, Parav Pandit wrote:
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 48b1c1ef1ebd..1edb558125b0 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -83,6 +83,20 @@ struct devlink_port_pci_vf_attrs {
>  	u8 external:1;
>  };
>  
> +/**
> + * struct devlink_port_pci_sf_attrs - devlink port's PCI SF attributes
> + * @controller: Associated controller number
> + * @pf: Associated PCI PF number for this port.
> + * @sf: Associated PCI SF for of the PCI PF for this port.
> + * @external: when set, indicates if a port is for an external controller
> + */
> +struct devlink_port_pci_sf_attrs {
> +	u32 controller;
> +	u16 pf;
> +	u32 sf;

Why a u32? Do you expect to support that many SFs? Seems like even a u16
is more than you can adequately name within an IFNAMESZ buffer.


> +	u8 external:1;
> +};
> +
>  /**
>   * struct devlink_port_attrs - devlink port object
>   * @flavour: flavour of the port


> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index e5b71f3c2d4d..fada660fd515 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -7855,6 +7889,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  		n = snprintf(name, len, "pf%uvf%u",
>  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>  		break;
> +	case DEVLINK_PORT_FLAVOUR_PCI_SF:
> +		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs->pci_sf.sf);
> +		break;
>  	}
>  
>  	if (n >= len)
> 

And as I noted before, this function continues to grow device names and
it is going to spill over the IFNAMESZ buffer and EINVAL is going to be
confusing. It really needs better error handling back to users (not
kernel buffers).

