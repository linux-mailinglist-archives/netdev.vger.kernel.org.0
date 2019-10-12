Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8FD51F2
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfJLTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:07:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45648 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfJLTHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:07:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id y72so8011733pfb.12
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GMcV5YtacOqMMPdQd6o2VXTl1LftD6HlJMBKU/qhzeY=;
        b=NFi+nK492SWC69oRMzB1lgJLcJv7ieZSfpPXuQ4C99xOqpN1OG5I9g+Qr6zX7VynVX
         yEbX23CLP/+S7nfVQ+zTQ4JzIEhlfWAuVpAAZGnO3EPSB2KWYSWq4ZaeuBGNE2itWrR5
         ds+LrLQwLbk0DQg899VroSEwyN9oVQQiVfXmhhJE9XScoM+aZROHsdwtrLegUJeSjrmL
         WxPkym2wkepaZTYtcYrIxHm+4WQz/Bi8yVmq2Wsbrp6BFsHDRYgcYGeG+Qla4fLp4BYU
         ZlY/lW3LEAZI1wMvqESO04c8DFWIEdXOpfo2uNs4mM0sE/RAaMgbDyRZMTt8nwUIIq4H
         4USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GMcV5YtacOqMMPdQd6o2VXTl1LftD6HlJMBKU/qhzeY=;
        b=n91sQoUdJK5aybKaiB6bUXtuOxG3JbuJlStzsAwfonRldCTC5xoXo4w6nOh40gbXDe
         Iu0d5Srt3VdYuue9QGdLfgQWcW6Y2+pEMi+dIkFWg3l69nPjBrc7Sio8ZpJ6V6FpRE3q
         G/fw6JLQX6DA6VOBo2PskN/zw1r+V4UGO0nE64zjrfppHdKWg908NpXddSDvf2TrHJNX
         tJe1kzpjHB9i9NDT9uUW4E9gaglE11LSes8EVWpO6kRshd7LYYplLpM2eR9vQ1dOOvK0
         VKdTi6OiyTvg6TEqTQunetdOhUdf+pm1fg/E1d5TIIpm2FgIZdCV7KTzW/w3/+Hcx5BN
         vhuA==
X-Gm-Message-State: APjAAAWk9du/LWhlBuMFkW/il4AW6QJOwGIBdmGZhseqgsc5hx/6eWHc
        bUAEFXwOI1Ny/F6dGdiJpW0=
X-Google-Smtp-Source: APXvYqwQMSdxjB380iwE5pYmaO4mG1mYFaERJEgTPkmF6D9M10RDZLywu2io+uvGOKq0yLmTlWOtNg==
X-Received: by 2002:a63:734a:: with SMTP id d10mr4086971pgn.334.1570907240215;
        Sat, 12 Oct 2019 12:07:20 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a21sm14970237pfi.0.2019.10.12.12.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:07:19 -0700 (PDT)
Date:   Sat, 12 Oct 2019 12:07:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Message-ID: <20191012190717.GL3165@localhost>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <58f42998778f9fa152174f4bbc175b1b09ed54b8.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58f42998778f9fa152174f4bbc175b1b09ed54b8.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:54AM +0000, Igor Russkikh wrote:
> +static int aq_ethtool_get_ts_info(struct net_device *ndev,
> +				  struct ethtool_ts_info *info)
> +{
> +	struct aq_nic_s *aq_nic = netdev_priv(ndev);
> +
> +	ethtool_op_get_ts_info(ndev, info);
> +
> +	info->so_timestamping |=
> +		SOF_TIMESTAMPING_TX_HARDWARE |
> +		SOF_TIMESTAMPING_RX_HARDWARE |
> +		SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +	info->tx_types =
> +		BIT(HWTSTAMP_TX_OFF) |
> +		BIT(HWTSTAMP_TX_ON);
> +
> +	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
> +
> +	if (aq_nic->aq_ptp)

Shouldn't the test for (aq_nic->aq_ptp) also effect
info->so_timestamping and info->tx_types ?

> +		info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
> +				    BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
> +				    BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
> +
> +	info->phc_index = (aq_nic->aq_ptp) ?
> +		ptp_clock_index(aq_ptp_get_ptp_clock(aq_nic->aq_ptp)) : -1;
> +
> +	return 0;
> +}

Thanks,
Richard
