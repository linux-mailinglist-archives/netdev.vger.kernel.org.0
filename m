Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2117264D71
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgIJSmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgIJSmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:42:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38D2C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:42:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id n14so5166101pff.6
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 11:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yziHi39TLoN0RIsPqwTV/QW8wRqZKMXZKkhEfwJIvIY=;
        b=HSriV5Fj+oZhBXd75ZRrVaLiLF3uRRoBmcXoUsvTffb4Zzajet0dDvHX9qyv/wqrQy
         yaxJ1swANN3M4YBgtEg7zDRF4VOF3xXbQykurCbPjpP14rlKOAXepGOU3P5mAJu7QRUK
         zRk0nn9943UnWKNTuNCXCMh2GIF7hEoAA9oFa354gPLaro70WnPgjmDjqVZRfmDy2Iwq
         7oCbTaJBomidlp4W1kKUQDfDuSK9ucUgXFKCzWBV2X5U9f5EKC8JbnzBJ79frsOGk5UV
         G2FtjRYAH7WGAXbhkwBDtehzw+q3hBBmpoCYP+YpCjpVLuXjO5qnafMI6me00Y/Kv4Ie
         Thzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yziHi39TLoN0RIsPqwTV/QW8wRqZKMXZKkhEfwJIvIY=;
        b=WJF0FPcdIynrQ2dgQa/82GTOmR/EtX3s6HnaEEksOWzSEPP1CC3emlCboNGibpyw9f
         Rfy1FsPyQsLiqmzJr3HQB3zxiQZuY/C1sG25cfK9roSUn197gMgJ1La4S9YHcvB3tCh4
         bfTFfS8ILwXfWgB7YfciPAfIB1DiKANKsInohbhThuBaOc/XJlQi2nT3mQV5pZRJ8WYf
         KiLLENqajtUueJKu2l9kvFWloWMiOYf7HxyCac+okP6n0f/VgfP7pVHDClFhJlNblKP6
         23w8kyb0cN91f0lldSTbJYrX8UzDvS9oWusnxSKY38T/0PHwDbZc3OpgszmzYo8Qeul2
         pEtQ==
X-Gm-Message-State: AOAM531NDCuiP5Uw8xS1RbBQwMp4kxFuG4cJmQYojCLV+Cc8CVNIwbW2
        m9bcRWjsDFohNPidAhhzytHuf1P9r4Y=
X-Google-Smtp-Source: ABdhPJxAO/9cLbI00cC/EOe+lMxXzIiRx48CRsQWNOYPgMBncSlFe8KWsevVEP/KzHWCmhm/n9J2Qw==
X-Received: by 2002:a63:5656:: with SMTP id g22mr5425605pgm.44.1599763327138;
        Thu, 10 Sep 2020 11:42:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m5sm2612098pjn.19.2020.09.10.11.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 11:42:06 -0700 (PDT)
Subject: Re: VLAN filtering with DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
Date:   Thu, 10 Sep 2020 11:42:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910150738.mwhh2i6j2qgacqev@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> Hi,
> 
> Problem background:
> 
> Most DSA switch tags shift the EtherType to the right, causing the
> master to not parse the VLAN as VLAN.
> However, not all switches do that (example: tail tags), and if the DSA
> master has "rx-vlan-filter: on" in ethtool -k, then we have a problem.
> Therefore, I was thinking we could populate the VLAN table of the
> master, just in case, so that it can work with a VLAN filtering master.
> It would look something like this:

Yes, doing what you suggest would make perfect sense for a DSA master 
that is capable of VLAN filtering, I did encounter that problem with 
e1000 and the dsa-loop.c mockup driver while working on a mock-up 802.1Q 
data path.

> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 19b98a7231ec..b8aca2301c59 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -307,9 +307,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>   			      const struct switchdev_obj *obj,
>   			      struct switchdev_trans *trans)
>   {
> +	struct net_device *master = dsa_slave_to_master(dev);
>   	struct dsa_port *dp = dsa_slave_to_port(dev);
>   	struct switchdev_obj_port_vlan vlan;
> -	int err;
> +	int vid, err;
>   
>   	if (obj->orig_dev != dev)
>   		return -EOPNOTSUPP;
> @@ -336,6 +337,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>   	if (err)
>   		return err;
>   
> +	for (vid = vlan.vid_begin; vid <= vlan.vid_end; vid++) {
> +		err = vlan_vid_add(master, htons(ETH_P_8021Q), vid);
> +		if (err)
> +			return err;
> +	}
> +
>   	return 0;
>   }
>   
> @@ -379,8 +386,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
>   static int dsa_slave_vlan_del(struct net_device *dev,
>   			      const struct switchdev_obj *obj)
>   {
> +	struct net_device *master = dsa_slave_to_master(dev);
>   	struct dsa_port *dp = dsa_slave_to_port(dev);
>   	struct switchdev_obj_port_vlan *vlan;
> +	int vid, err;
>   
>   	if (obj->orig_dev != dev)
>   		return -EOPNOTSUPP;
> @@ -396,7 +405,14 @@ static int dsa_slave_vlan_del(struct net_device *dev,
>   	/* Do not deprogram the CPU port as it may be shared with other user
>   	 * ports which can be members of this VLAN as well.
>   	 */
> -	return dsa_port_vlan_del(dp, vlan);
> +	err = dsa_port_vlan_del(dp, vlan);
> +	if (err)
> +		return err;
> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
> +		vlan_vid_del(master, htons(ETH_P_8021Q), vid);
> +
> +	return 0;
>   }
>   
>   static int dsa_slave_port_obj_del(struct net_device *dev,
> @@ -1241,6 +1257,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
>   static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>   				     u16 vid)
>   {
> +	struct net_device *master = dsa_slave_to_master(dev);
>   	struct dsa_port *dp = dsa_slave_to_port(dev);
>   	struct switchdev_obj_port_vlan vlan = {
>   		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
> @@ -1294,12 +1311,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>   	if (ret)
>   		return ret;
>   
> -	return 0;
> +	return vlan_vid_add(master, proto, vid);
>   }
>   
>   static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>   				      u16 vid)
>   {
> +	struct net_device *master = dsa_slave_to_master(dev);
>   	struct dsa_port *dp = dsa_slave_to_port(dev);
>   	struct switchdev_obj_port_vlan vlan = {
>   		.vid_begin = vid,
> @@ -1332,7 +1350,13 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>   	/* Do not deprogram the CPU port as it may be shared with other user
>   	 * ports which can be members of this VLAN as well.
>   	 */
> -	return dsa_port_vlan_del(dp, &vlan);
> +	ret = dsa_port_vlan_del(dp, &vlan);
> +	if (ret)
> +		return ret;
> +
> +	vlan_vid_del(master, proto, vid);
> +
> +	return 0;
>   }
>   
>   struct dsa_hw_port {
> 

-- 
Florian
