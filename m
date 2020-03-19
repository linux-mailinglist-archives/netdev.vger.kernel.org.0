Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6830718C030
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSTRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:17:19 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:39231 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgCSTRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:17:19 -0400
Received: by mail-qv1-f66.google.com with SMTP id v38so1662320qvf.6
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 12:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=A4R5h/qfVxNNL/my8BuRwz3n6j4JnQrhLXM5QslJPIc=;
        b=oME51v/usZ001+pcYhShTCXtOcKEdpRWyV7cTzoSHH1hyTkxMjCty95HK1hWT7GgeY
         wKsdcaWOC/yldUo+6AIWzMHZz9rMHxOFzSsLmOaeDiBwh0rILE2NdW27NKWFstXEp2vr
         X90Z90J9ZMKAsTUbKTKG4uwlDukTqnIL2LiOisl3NUiyFpBbGxbvYZaym1jFMMqIFdiG
         Ny25t/0ZENqbz9GYlNKWYdzYGG77rsx7/CMUqMarQ4wAeobwBq2uMHF2fQ4+BPCn5nFH
         V9kdTVFE2RNmJXpEMpwgAPTLZvgpaHmLyuKuqPAhSmdGoOydeOcAAAxqc+cItvzTbVny
         lEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=A4R5h/qfVxNNL/my8BuRwz3n6j4JnQrhLXM5QslJPIc=;
        b=uSDjFEop4c35gTe0f/G+U07RvRVms2i2I3JGppo9SRSshUCR2aGZXXWgmUOG2/f/r5
         ZTh0T6WT06QlF5UTuvmhD+XDlrYAJ9qcTUaL19AFSI3VO+AMgYvJES+IZ7+BLpLYfe0+
         h5OXwAT/bjcr5UC3wZFnPNcyqCw7+CXBwz8eN7c2vwH292BiVtNhmUAq+dGomU5WMuMU
         egnZefb47bFESDCbmvy66+Scc8hcg8uswGdyFWqvj50zMXdGR6nIiEhbb98wuC3JXVJE
         Rgam5Frj3iBYgdEBZxxRFAxkrG/OFugDLSPobpyBjDb43mLj0NDydgtr7ejO7Vw1rSvB
         YQfw==
X-Gm-Message-State: ANhLgQ0KhrKhE6bEhGBiGwHfVCrvpJBUkLal/cCYPlbk75PXRK3tMJ1E
        BKsniKFC/iEoyLNF/yDmp2Y=
X-Google-Smtp-Source: ADFU+vvoZqjsdMwUD0WFoNDywXilq9m36+PFvdyYSWEaEFHrErlP8HmqzZEz/AySxRO8JOYENeAR4Q==
X-Received: by 2002:ad4:46d4:: with SMTP id g20mr4569906qvw.179.1584645436879;
        Thu, 19 Mar 2020 12:17:16 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n74sm2148721qke.125.2020.03.19.12.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:17:16 -0700 (PDT)
Date:   Thu, 19 Mar 2020 15:17:14 -0400
Message-ID: <20200319151714.GB3446043@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/2] net: dsa: add a dsa_port_is_enabled helper
 function
In-Reply-To: <20200319185620.1581-1-olteanv@gmail.com>
References: <20200319185620.1581-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, 19 Mar 2020 20:56:19 +0200, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Sometimes drivers need to do per-port operation outside the port DSA
> methods, and in that case they typically iterate through their port list
> themselves.
> 
> Give them an aid to skip ports that are disabled in the device tree
> (which the DSA core already skips).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h |  2 ++
>  net/dsa/dsa2.c    | 29 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index beeb81a532e3..813792e6f0be 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -376,6 +376,8 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
>  		return dp->vlan_filtering;
>  }
>  
> +bool dsa_port_is_enabled(struct dsa_switch *ds, int port);
> +
>  typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
>  			      bool is_static, void *data);
>  struct dsa_switch_ops {
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index e7c30b472034..752f21273bd6 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -727,6 +727,35 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
>  	return err;
>  }
>  
> +bool dsa_port_is_enabled(struct dsa_switch *ds, int port)
> +{
> +	struct device_node *dn = ds->dev->of_node;
> +	struct device_node *ports, *port_node;
> +	bool found = false;
> +	int reg, err;
> +
> +	ports = of_get_child_by_name(dn, "ports");
> +	if (!ports) {
> +		dev_err(ds->dev, "no ports child node found\n");
> +		return false;
> +	}
> +
> +	for_each_available_child_of_node(ports, port_node) {
> +		err = of_property_read_u32(port_node, "reg", &reg);
> +		if (err)
> +			goto out_put_node;
> +
> +		if (reg == port) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +out_put_node:
> +	of_node_put(ports);
> +	return found;
> +}

Why do you need to iterate on the device tree? Ideally we could make
abstraction of that (basic platform data is supported too) and use pure DSA
helpers, given that DSA core has already peeled all that for us.

Your helper above doesn't even look at the port's state, only if it is declared
or not. Looking at patch 2, Using !dsa_is_unused_port(ds, port) seems enough.


Thanks,

	Vivien
