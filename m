Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69690956E1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 07:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfHTFvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 01:51:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38239 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTFvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 01:51:41 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so4724654qts.5
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 22:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=WJ8OLrWvLKUJtUzP1j1oMR6tVPc7Iey6EkK5izUnycg=;
        b=mmUAxpkoP942MtQS+NhJbnKEcAlNNpt6tvgyn7Nr+v/Ds0LBWSsfwBllLWLFbHz1fm
         XqoMQ8/ruLSEq8yDLWRhFS7YYeP6v/8FxGvuaGH9EkPhjc1siDbhDUtuz2INezxZj/6K
         XTy7/CdsYQ7iPzacFyzDxDxis7LWalIZ2ERuPgtw07KSI2+xC00mcJxgJS14Y87CEtMS
         Uqbsthh4WtdQrW+Vc8P4mJRG19kk/udjj5ALipqNPm6mXMTZd6hO8kHaL0scW1tjMb3g
         IbrzrXxjn8qvtK3yV1d2paXX/L51ezv1YBdM8Dg6SJifb/gNnNaCo+SzPHfozvKQUVsA
         o8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=WJ8OLrWvLKUJtUzP1j1oMR6tVPc7Iey6EkK5izUnycg=;
        b=UPv/qLoxjyasQiFX/I0Y22/d+Xk61kDcSWr68UOjm7Z4Y3iEIbuNcLw9KQLNArS3q6
         nVFAb5G3cNWHkNwyC/7aHI20TbgDM6BiiUu8zGatJ6yKQcMVXcTPDAERzqCnCE2R1VIr
         olu6Boc2FWo8IX/HGIOCXVYfxkukt0+12oI3gnBQtFCMWbEc784TF2XGJcdqKruZxdop
         1Ce/QVrExBdUl/EKF+BrFxMkOK6DIVux7dg7wUivezl0TR/tr1Q+tA7XMiuOjSSDvOiF
         9/neFbCkmmUgTOjPzfbC7wpxFITkkPQib61uCtMtxC3yLOW8GHYDtCO61IqkKrZNbzuB
         kBIg==
X-Gm-Message-State: APjAAAWylne3yvnlY8ldtlGKWMUYuAqFhMwiO77rF8w+u6vBn7B/XQ+y
        H79200Zm2ayQ7Pil5ZUp/Vo=
X-Google-Smtp-Source: APXvYqxO//5WUk5h8Z1GLyIXiIH6xdx1OoBVlDG/Giobe7yqzuImQsA80mLWIGzKInA/d1IIHjekCA==
X-Received: by 2002:a0c:c207:: with SMTP id l7mr13461226qvh.40.1566280300560;
        Mon, 19 Aug 2019 22:51:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x26sm7814890qkn.116.2019.08.19.22.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 22:51:39 -0700 (PDT)
Date:   Tue, 20 Aug 2019 01:51:38 -0400
Message-ID: <20190820015138.GB975@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
In-Reply-To: <20190820000002.9776-4-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir,

On Tue, 20 Aug 2019 02:59:59 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> is littering a lot. After deleting a VLAN added on a DSA port, it still
> remains installed in the hardware filter of the upstream port. Fix this.

Littering a lot, really?

FYI we are not removing the target VLAN from the hardware yet because it would
be too expensive to cache data in DSA core in order to know if the VID is not
used by any other slave port of the fabric anymore, and thus safe to remove.

Keeping the VID programmed for DSA and CPU ports is simpler for the moment,
as an hardware VLAN with only these ports as members is unlikely to harm.

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/switch.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 09d9286b27cc..84ab2336131e 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -295,11 +295,20 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
>  			       struct dsa_notifier_vlan_info *info)
>  {
>  	const struct switchdev_obj_port_vlan *vlan = info->vlan;
> +	int port;
>  
>  	if (!ds->ops->port_vlan_del)
>  		return -EOPNOTSUPP;
>  
> +	/* Build a mask of VLAN members */
> +	bitmap_zero(ds->bitmap, ds->num_ports);
>  	if (ds->index == info->sw_index)
> +		set_bit(info->port, ds->bitmap);
> +	for (port = 0; port < ds->num_ports; port++)
> +		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +			set_bit(port, ds->bitmap);
> +
> +	for_each_set_bit(port, ds->bitmap, ds->num_ports)
>  		return ds->ops->port_vlan_del(ds, info->port, vlan);

You return right away from the loop? You use info->port instead of port?
	
>  
>  	return 0;

Even if you patch wasn't badly broken, "bridge vlan del" targeting a single
switch port would also remove the VLAN from the CPU port and thus breaking
offloaded 802.1q. It would also remove it from the DSA ports interconnecting
multiple switches, thus breaking the 802.1q conduit for the whole fabric.

So you're not fixing anything here, but you're breaking single-chip and
cross-chip hardware VLAN. Seriously wtf is this patch?

NAK!


	Vivien
