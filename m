Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2367F4F0C4
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUWaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:30:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39515 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFUWaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:30:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so3661017pls.6
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=CZF/JCq1pli4+rkvqNapLbYTcqEDIIkYoGcmgUkZUg4=;
        b=ROF6NCVRWuidcWdeSFFWBGOTQIpKnno0ewfJ9mt0TI5kNvEAWFNBZ6EPOIsPclk2he
         8V/4R5SdQ827uQnbwfcd40g7ft2fHVWk3WkfEtAwtvvt/3MMgGi25pMCvUvd1zIfzZDS
         NkpJ6ei3xGEAoz7zhikdu+kKzH9cBZWjJr0mMMyRTR8WCJrAWZEqxik2n/FiieTjGSGg
         udlwyvOeiscnvIx7vz/vJPm4TEEqqU+m8N0F3jM6Pq65QJFzPLJFc0sUa9RhZCzDj3NZ
         f/UYRpBWnaUKRw/7y1yeh6hn3C/aRDPiwvo8yz/0VEFkSl6/ci9xAsWkdf2oNIGAg+ae
         Ja+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CZF/JCq1pli4+rkvqNapLbYTcqEDIIkYoGcmgUkZUg4=;
        b=rOLMuM37Gb91e1TVQIpt4Hy1oHjeLqfrLau7cAZ4wPC07kSuMBkKSMN7XiKunmOSFL
         qm2EuX0LtAwbE7bkMp1eyU9fyVp5UcxVE7eYwt9yE+30gbUVxN0eebqfioQgFHRqfmnH
         OL3aYPSHNlq84VEX7pTW+0K7S25W68DBWIv5XduPb4UfarPsq4t7t5fFT73uPHWs1e1C
         Cy2u0at/mB810x83l/demZkCuEi8xsEncnuKN+nRKdOa6owe8fqjJBrnxzHB7MJSEdP/
         TQUPUiijPVsahA564G6NpZ/8ATJAVIcUTMrn1cCvrWNCbE9r9+Z67W1muSV5SIAl+3Nf
         Kn0A==
X-Gm-Message-State: APjAAAXT6rjyI8qzuWO6eLfLZ0rkIkosMnhuC2+WXgq23MRo3xXqDo+7
        cXRftsxKkaJESPmm4j121kWER49yiZU=
X-Google-Smtp-Source: APXvYqyzTdI2k8kCfKxM3A1rmysacsBJaPJRd5gfwkg5KZsRuzRGHE+v08lZDQW4/vjbLdljbKzq/w==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr51841769plp.227.1561156223006;
        Fri, 21 Jun 2019 15:30:23 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id d19sm3179839pjs.22.2019.06.21.15.30.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:30:22 -0700 (PDT)
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-14-snelson@pensando.io>
 <20190621023205.GD21796@unicorn.suse.cz>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4588d437-6308-0b6c-50e9-964a877b833f@pensando.io>
Date:   Fri, 21 Jun 2019 15:30:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621023205.GD21796@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 7:32 PM, Michal Kubecek wrote:
> On Thu, Jun 20, 2019 at 01:24:19PM -0700, Shannon Nelson wrote:
>> Add in the basic ethtool callbacks for device information
>> and control.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
> ...
>> +static int ionic_get_link_ksettings(struct net_device *netdev,
>> +				    struct ethtool_link_ksettings *ks)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	int copper_seen = 0;
>> +
>> +	ethtool_link_ksettings_zero_link_mode(ks, supported);
>> +	ethtool_link_ksettings_zero_link_mode(ks, advertising);
>> +
>> +	if (ionic_is_mnic(lif->ionic)) {
>> +		ethtool_link_ksettings_add_link_mode(ks, supported, Backplane);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, Backplane);
>> +	} else {
>> +		ethtool_link_ksettings_add_link_mode(ks, supported, FIBRE);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FIBRE);
>> +
>> +		if (ionic_is_pf(lif->ionic)) {
>> +			ethtool_link_ksettings_add_link_mode(ks, supported,
>> +							     Autoneg);
>> +			ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +							     Autoneg);
>> +		}
>> +	}
>> +
>> +	switch (le16_to_cpu(idev->port_info->status.xcvr.pid)) {
>> +		/* Copper */
>> +	case XCVR_PID_QSFP_100G_CR4:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     100000baseCR4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     100000baseCR4_Full);
>> +		copper_seen++;
>> +		break;
>> +	case XCVR_PID_QSFP_40GBASE_CR4:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     40000baseCR4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     40000baseCR4_Full);
>> +		copper_seen++;
>> +		break;
>> +	case XCVR_PID_SFP_25GBASE_CR_S:
>> +	case XCVR_PID_SFP_25GBASE_CR_L:
>> +	case XCVR_PID_SFP_25GBASE_CR_N:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     25000baseCR_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     25000baseCR_Full);
>> +		copper_seen++;
>> +		break;
>> +	case XCVR_PID_SFP_10GBASE_AOC:
>> +	case XCVR_PID_SFP_10GBASE_CU:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseCR_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     10000baseCR_Full);
>> +		copper_seen++;
>> +		break;
>> +
>> +		/* Fibre */
>> +	case XCVR_PID_QSFP_100G_SR4:
>> +	case XCVR_PID_QSFP_100G_AOC:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     100000baseSR4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     100000baseSR4_Full);
>> +		break;
>> +	case XCVR_PID_QSFP_100G_LR4:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     100000baseLR4_ER4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     100000baseLR4_ER4_Full);
>> +		break;
>> +	case XCVR_PID_QSFP_100G_ER4:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     100000baseLR4_ER4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     100000baseLR4_ER4_Full);
>> +		break;
>> +	case XCVR_PID_QSFP_40GBASE_SR4:
>> +	case XCVR_PID_QSFP_40GBASE_AOC:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     40000baseSR4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     40000baseSR4_Full);
>> +		break;
>> +	case XCVR_PID_QSFP_40GBASE_LR4:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     40000baseLR4_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     40000baseLR4_Full);
>> +		break;
>> +	case XCVR_PID_SFP_25GBASE_SR:
>> +	case XCVR_PID_SFP_25GBASE_AOC:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     25000baseSR_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     25000baseSR_Full);
>> +		break;
>> +	case XCVR_PID_SFP_10GBASE_SR:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseSR_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     10000baseSR_Full);
>> +		break;
>> +	case XCVR_PID_SFP_10GBASE_LR:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseLR_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     10000baseLR_Full);
>> +		break;
>> +	case XCVR_PID_SFP_10GBASE_LRM:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseLRM_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     10000baseLRM_Full);
>> +		break;
>> +	case XCVR_PID_SFP_10GBASE_ER:
>> +		ethtool_link_ksettings_add_link_mode(ks, supported,
>> +						     10000baseER_Full);
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
>> +						     10000baseER_Full);
>> +		break;
>> +	case XCVR_PID_QSFP_100G_ACC:
>> +	case XCVR_PID_QSFP_40GBASE_ER4:
>> +	case XCVR_PID_SFP_25GBASE_LR:
>> +	case XCVR_PID_SFP_25GBASE_ER:
>> +		dev_info(lif->ionic->dev, "no decode bits for xcvr type pid=%d / 0x%x\n",
>> +			 idev->port_info->status.xcvr.pid,
>> +			 idev->port_info->status.xcvr.pid);
>> +		break;
> Maybe you should rather add these modes so that they can be shown and
> set.

Yeah, I was thinking about that.  I'll look at adding them in a separate 
patchset.

>
>> +	case XCVR_PID_UNKNOWN:
>> +		break;
>> +	default:
>> +		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
>> +			 idev->port_info->status.xcvr.pid,
>> +			 idev->port_info->status.xcvr.pid);
>> +		break;
>> +	}
> Up to this point, you always set each bit in both supported and
> advertised modes. Thus you could set the modes in only one of the
> bitmaps and copy it to the other here.

Good idea - that would clean up some of this silliness.

>
>> +
>> +	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
>> +	if (idev->port_info->config.pause_type)
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, Pause);
>> +
>> +	if (idev->port_info->config.fec_type == PORT_FEC_TYPE_FC)
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_BASER);
>> +	else if (idev->port_info->config.fec_type == PORT_FEC_TYPE_RS)
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
>> +	else
>> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
> Is it correct to set these FEC bits only in advertising and not in
> supported?
Hmmm... good catch.
>
>> +static int ionic_set_link_ksettings(struct net_device *netdev,
>> +				    const struct ethtool_link_ksettings *ks)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic *ionic = lif->ionic;
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	u8 fec_type = PORT_FEC_TYPE_NONE;
>> +	u32 req_rs, req_b;
>> +	int err = 0;
>> +
>> +	/* set autoneg */
>> +	if (ks->base.autoneg != idev->port_info->config.an_enable) {
>> +		idev->port_info->config.an_enable = ks->base.autoneg;
> IMHO you should only save the value if the command below succeeds,
> otherwise next time you will be comparing against the value which wasn't
> actually set.
Yes, thanks.
>
>> +		mutex_lock(&ionic->dev_cmd_lock);
>> +		ionic_dev_cmd_port_autoneg(idev, ks->base.autoneg);
>> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +		mutex_unlock(&ionic->dev_cmd_lock);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	/* set speed */
>> +	if (ks->base.speed != le32_to_cpu(idev->port_info->config.speed)) {
>> +		idev->port_info->config.speed = cpu_to_le32(ks->base.speed);
> Same here.
Sure.
>
>> +		mutex_lock(&ionic->dev_cmd_lock);
>> +		ionic_dev_cmd_port_speed(idev, ks->base.speed);
>> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +		mutex_unlock(&ionic->dev_cmd_lock);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	/* set FEC */
>> +	req_rs = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_RS);
>> +	req_b = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_BASER);
>> +	if (req_rs && req_b) {
>> +		netdev_info(netdev, "Only select one FEC mode at a time\n");
>> +		return -EINVAL;
>> +
>> +	} else if (req_b &&
>> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_FC) {
>> +		fec_type = PORT_FEC_TYPE_FC;
>> +	} else if (req_rs &&
>> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_RS) {
>> +		fec_type = PORT_FEC_TYPE_RS;
>> +	} else if (!(req_rs | req_b) &&
>> +		 idev->port_info->config.fec_type != PORT_FEC_TYPE_NONE) {
>> +		fec_type = PORT_FEC_TYPE_NONE;
>> +	}
> AFAICS if userspace requests a mode which is already set, you end up
> with fec_type = PORT_FEC_TYPE_NONE here. This doesn't seem right.
> I assume you would rather want to skip the setting below in such case.

I'll double check that - thanks.
>
>> +
>> +	idev->port_info->config.fec_type = fec_type;
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +	ionic_dev_cmd_port_fec(idev, PORT_FEC_TYPE_NONE);
> Shouldn't the argument be fec_type here?

Ugh... yes.

>
>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
> ...
>> +static int ionic_set_ringparam(struct net_device *netdev,
>> +			       struct ethtool_ringparam *ring)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	bool running;
>> +	int i, j;
>> +
>> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
>> +		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	i = ring->tx_pending & (ring->tx_pending - 1);
>> +	j = ring->rx_pending & (ring->rx_pending - 1);
>> +	if (i || j) {
>> +		netdev_info(netdev, "Descriptor count must be a power of 2\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (ring->tx_pending > IONIC_MAX_TXRX_DESC ||
>> +	    ring->tx_pending < IONIC_MIN_TXRX_DESC ||
>> +	    ring->rx_pending > IONIC_MAX_TXRX_DESC ||
>> +	    ring->rx_pending < IONIC_MIN_TXRX_DESC) {
>> +		netdev_info(netdev, "Descriptors count must be in the range [%d-%d]\n",
>> +			    IONIC_MIN_TXRX_DESC, IONIC_MAX_TXRX_DESC);
>> +		return -EINVAL;
>> +	}
> The upper bounds have been already checked in ethtool_set_ringparam() so
> that the two conditions can never be satisfied here.
>
> ...
>> +static int ionic_set_channels(struct net_device *netdev,
>> +			      struct ethtool_channels *ch)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	bool running;
>> +
>> +	if (!ch->combined_count || ch->other_count ||
>> +	    ch->rx_count || ch->tx_count)
>> +		return -EINVAL;
>> +
>> +	if (ch->combined_count > lif->ionic->ntxqs_per_lif)
>> +		return -EINVAL;
> This has been already checked in ethtool_set_channels().
That's what I get for copying from an existing driver.  I'll check those 
and clean them up.

>
> Michal Kubecek
Thanks!
sln

