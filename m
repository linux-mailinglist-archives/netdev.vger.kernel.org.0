Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB603DF1BE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhHCPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbhHCPpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:45:25 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DF3C061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:45:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b7so29582281edu.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ldBAsPssxEtdKMDCLE4FgWRxzH7xhVOKsHvx5WSae0=;
        b=YWEW23VcoqrIp81hojqhAameW09vd+923R7lfcoxgmGiX92PiRe+tQsUUFDNRbxGN5
         5yw3//QguztUotS5Cvy5sDZRMW7Snej410HO7noji47maaETN1zbpKKw/GyT9gPQAxQ8
         PQCRk2STmyVe1RIM3e/4+b+IwyHHMJ7kPAY4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6ldBAsPssxEtdKMDCLE4FgWRxzH7xhVOKsHvx5WSae0=;
        b=JUjpMrvO3Uk0f7c8eQGblF2dWJVTxE5ohzk/24vadYB2t47RR6bUhulMPuVzFY9+O/
         pzomqZSMIBe1lHMIQtuRuj/URBu/UGa3RsMsEbjzwhGjbCgVMLhyP46z3zSTxBhmcDg/
         jXc99ce2wY6NTeZPKH3fJNpUPZ1gteBH3Caz8P4d09IWKdH8um0nWn00NtbLQQ+4IAD6
         wCZe9mgfT5DVrXXH8sXA8yUlBzvpJlTNuyTrq10paQq0Pwb8XxznnNoDfuUkGbOBZRaj
         fQ59kqvqVgwd1kSH+uzC7GWgyd973dUyKY8xdLstD97UpjZtFEaMwKSnoYS2zYwh9IwK
         cnZQ==
X-Gm-Message-State: AOAM532eFZGJXbXiu+beOABaRXneVaGNo2KUVh5zcXncYNqIWbdX1yNE
        evPSAeAlfzwxd0+T+YHptF+vSQ==
X-Google-Smtp-Source: ABdhPJxSOUnf+Y2d9rYyIJjPs9Adtvz0LbIvrgOW9Jn7CGX8tZNHOQRDMYT5ouqyEOcTIuWFSRXoJQ==
X-Received: by 2002:aa7:d30e:: with SMTP id p14mr26053468edq.204.1628005512570;
        Tue, 03 Aug 2021 08:45:12 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id de49sm6317367ejc.34.2021.08.03.08.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:45:12 -0700 (PDT)
Date:   Tue, 3 Aug 2021 18:45:11 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net 1/2] net: usb: pegasus: Check the return value of
 get_geristers() and friends;
Message-ID: <YQlkh54HdqQYZenw@carbon>
Mail-Followup-To: Pavel Skripkin <paskripkin@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
 <20210803150317.5325-2-petko.manolov@konsulko.com>
 <eeb03520-f57a-1c78-fe84-0b72edea371f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeb03520-f57a-1c78-fe84-0b72edea371f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-03 18:28:55, Pavel Skripkin wrote:
> On 8/3/21 6:03 PM, Petko Manolov wrote:
> > From: Petko Manolov <petkan@nucleusys.com>
> > 
> > Certain call sites of get_geristers() did not do proper error handling.  This
> > could be a problem as get_geristers() typically return the data via pointer to a
> > buffer.  If an error occured the code is carelessly manipulating the wrong data.
> > 
> > Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> 
> Hi, Petko!
> 
> This patch looks good to me, but I found few small mistakes

Yeah, the patch was never compiled.  Sorry about it.  v2 is coming up.

> > ---
> >   drivers/net/usb/pegasus.c | 102 ++++++++++++++++++++++++++------------
> >   1 file changed, 70 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> > index 9a907182569c..924be11ee72c 100644
> > --- a/drivers/net/usb/pegasus.c
> > +++ b/drivers/net/usb/pegasus.c
> > @@ -132,9 +132,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
> >   static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
> >   			 const void *data)
> >   {
> > -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
> > +	int ret;
> > +
> > +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
> >   				    PEGASUS_REQT_WRITE, 0, indx, data, size,
> >   				    1000, GFP_NOIO);
> > +	if (ret < 0)
> > +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> > +
> > +	return ret;
> >   }
> >   /*
> > @@ -145,10 +151,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
> >   static int set_register(pegasus_t *pegasus, __u16 indx, __u8 data)
> >   {
> >   	void *buf = &data;
> > +	int ret;
> > -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
> > +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
> >   				    PEGASUS_REQT_WRITE, data, indx, buf, 1,
> >   				    1000, GFP_NOIO);
> > +	if (ret < 0)
> > +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> > +
> > +	return ret;
> >   }
> >   static int update_eth_regs_async(pegasus_t *pegasus)
> > @@ -188,10 +199,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
> >   static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
> >   {
> > -	int i;
> > -	__u8 data[4] = { phy, 0, 0, indx };
> > +	int i, ret = -ETIMEDOUT;
> >   	__le16 regdi;
> > -	int ret = -ETIMEDOUT;
> > +	__u8 data[4] = { phy, 0, 0, indx };
> >   	if (cmd & PHY_WRITE) {
> >   		__le16 *t = (__le16 *) & data[1];
> > @@ -211,8 +221,9 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
> >   		goto fail;
> 
> ...
> 
> 	if (i >= REG_TIMEOUT)
> 		goto fail;       <--- ret needs initialization here
> 
> ...

It actually is, i just shuffled the var definitions.

> >   	if (cmd & PHY_READ) {
> >   		ret = get_registers(p, PhyData, 2, &regdi);
> > +		if (ret < 0)
> > +			goto fail;
> >   		*regd = le16_to_cpu(regdi);
> > -		return ret;
> >   	}
> >   	return 0;
> >   fail:
> > @@ -235,9 +246,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
> >   static int mdio_read(struct net_device *dev, int phy_id, int loc)
> >   {
> >   	pegasus_t *pegasus = netdev_priv(dev);
> > +	int ret;
> >   	u16 res;
> > -	read_mii_word(pegasus, phy_id, loc, &res);
> > +	ret = read_mii_word(pegasus, phy_id, loc, &res);
> > +	if (ret < 0)
> > +		return ret;
> > +
> >   	return (int)res;
> >   }
> > @@ -251,10 +266,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
> >   static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
> >   {
> > -	int i;
> > -	__u8 tmp = 0;
> > +	int ret, i;
> >   	__le16 retdatai;
> > -	int ret;
> > +	__u8 tmp = 0;
> >   	set_register(pegasus, EpromCtrl, 0);
> >   	set_register(pegasus, EpromOffset, index);
> > @@ -262,21 +276,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
> >   	for (i = 0; i < REG_TIMEOUT; i++) {
> >   		ret = get_registers(pegasus, EpromCtrl, 1, &tmp);
> > +		if (ret < 0)
> > +			goto fail;
> >   		if (tmp & EPROM_DONE)
> >   			break;
> > -		if (ret == -ESHUTDOWN)
> > -			goto fail;
> >   	}
> > -	if (i >= REG_TIMEOUT)
> > +	if (i >= REG_TIMEOUT) {
> > +		ret = -ETIMEDOUT;
> >   		goto fail;
> > +	}
> >   	ret = get_registers(pegasus, EpromData, 2, &retdatai);
> > +	if (ret < 0)
> > +		goto fail;
> >   	*retdata = le16_to_cpu(retdatai);
> >   	return ret;
> >   fail:
> > -	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> > -	return -ETIMEDOUT;
> > +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> > +	return ret;
> >   }
> >   #ifdef	PEGASUS_WRITE_EEPROM
> > @@ -324,10 +342,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
> >   	return ret;
> >   fail:
> > -	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> > +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> >   	return -ETIMEDOUT;
> >   }
> > -#endif				/* PEGASUS_WRITE_EEPROM */
> > +#endif	/* PEGASUS_WRITE_EEPROM */
> >   static inline int get_node_id(pegasus_t *pegasus, u8 *id)
> >   {
> > @@ -367,19 +385,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
> >   	return;
> >   err:
> >   	eth_hw_addr_random(pegasus->net);
> > -	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
> > +	netif_dbg(pegasus, drv, pegasus->net, "software assigned MAC address.\n");
> >   	return;
> >   }
> >   static inline int reset_mac(pegasus_t *pegasus)
> >   {
> > +	int ret, i;
> >   	__u8 data = 0x8;
> > -	int i;
> >   	set_register(pegasus, EthCtrl1, data);
> >   	for (i = 0; i < REG_TIMEOUT; i++) {
> > -		get_registers(pegasus, EthCtrl1, 1, &data);
> > +		ret = get_registers(pegasus, EthCtrl1, 1, &data);
> > +		if (ret < 0)
> > +			goto fail;
> >   		if (~data & 0x08) {
> >   			if (loopback)
> >   				break;
> > @@ -402,22 +422,29 @@ static inline int reset_mac(pegasus_t *pegasus)
> >   	}
> >   	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_ELCON) {
> >   		__u16 auxmode;
> > -		read_mii_word(pegasus, 3, 0x1b, &auxmode);
> > +		ret = read_mii_word(pegasus, 3, 0x1b, &auxmode);
> > +		if (ret < 0)
> > +			goto fail;
> >   		auxmode |= 4;
> >   		write_mii_word(pegasus, 3, 0x1b, &auxmode);
> >   	}
> >   	return 0;
> > +fail:
> > +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> > +	return ret;
> >   }
> >   static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> >   {
> > -	__u16 linkpart;
> > -	__u8 data[4];
> >   	pegasus_t *pegasus = netdev_priv(dev);
> >   	int ret;
> > +	__u16 linkpart;
> > +	__u8 data[4];
> > -	read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
> > +	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
> > +	if (ret < 0)
> > +		goto fail;
> >   	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
> >   	data[1] = 0;
> >   	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
> > @@ -435,11 +462,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> >   	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
> >   	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
> >   		u16 auxmode;
> > -		read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > +		ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > +		if (ret < 0)
> > +			goto fail;
> >   		auxmode |= 4;
> >   		write_mii_word(pegasus, 0, 0x1b, &auxmode);
> >   	}
> > +	return 0;
> > +fail:
> > +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> >   	return ret;
> >   }
> > @@ -447,9 +479,9 @@ static void read_bulk_callback(struct urb *urb)
> >   {
> >   	pegasus_t *pegasus = urb->context;
> >   	struct net_device *net;
> > +	u8 *buf = urb->transfer_buffer;
> >   	int rx_status, count = urb->actual_length;
> >   	int status = urb->status;
> > -	u8 *buf = urb->transfer_buffer;
> >   	__u16 pkt_len;
> >   	if (!pegasus)
> > @@ -998,8 +1030,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
> >   		data[0] = pegasus->phy;
> >   		fallthrough;
> >   	case SIOCDEVPRIVATE + 1:
> > -		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
> > -		res = 0;
> > +		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
> >   		break;
> >   	case SIOCDEVPRIVATE + 2:
> >   		if (!capable(CAP_NET_ADMIN))
> > @@ -1033,22 +1064,25 @@ static void pegasus_set_multicast(struct net_device *net)
> >   static __u8 mii_phy_probe(pegasus_t *pegasus)
> >   {
> > -	int i;
> > +	int i, ret;
> >   	__u16 tmp;
> >   	for (i = 0; i < 32; i++) {
> > -		read_mii_word(pegasus, i, MII_BMSR, &tmp);
> > +		ret = read_mii_word(pegasus, i, MII_BMSR, &tmp)
> 
> Semicolon missing
> 
> > +		if (ret < 0)
> > +			goto out;
> 
> 
> Should be "goto fail;"			
> 
> >   		if (tmp == 0 || tmp == 0xffff || (tmp & BMSR_MEDIA) == 0)
> >   			continue;
> >   		else
> >   			return i;
> >   	}
> > -
> > +fail:
> >   	return 0xff;
> >   }
> >   static inline void setup_pegasus_II(pegasus_t *pegasus)
> >   {
> > +	int ret;
> >   	__u8 data = 0xa5;
> >   	set_register(pegasus, Reg1d, 0);
> > @@ -1060,7 +1094,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
> >   		set_register(pegasus, Reg7b, 2);
> >   	set_register(pegasus, 0x83, data);
> > -	get_registers(pegasus, 0x83, 1, &data);
> > +	ret = get_registers(pegasus, 0x83, 1, &data);
> > +	if (ret < 0)
> > +		goto fail;
> >   	if (data == 0xa5)
> >   		pegasus->chip = 0x8513;
> > @@ -1075,6 +1111,8 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
> >   		set_register(pegasus, Reg81, 6);
> >   	else
> >   		set_register(pegasus, Reg81, 2);
> 
> There should be "return" before fail label, I guess.
> 
> > +fail:
> > +	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> >   }
> >   static void check_carrier(struct work_struct *work)
> > 
> 
> 
> 
> 
> With regards,
> Pavel Skripkin


thanks,
Petko
