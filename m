Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A32A405C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfH3WRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:17:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43090 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbfH3WRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:17:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id u72so12313pgb.10
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2eUvJv1pYLsbWEXE3zbo18Mq1onOR7/X9IXKiWcXcGE=;
        b=UWmuMlAnCtTxVWB53gCttmznb0aPrMG3tZsfd9QgZnRD+0oC3GC50MigAr9faqhixv
         cO2o3s/fu1SpLrLxtmzUrs4UETQskg+LApRbudntB8oDpFciWMuNPrwYcoBQNIuVv4zw
         dHCFJe8GB0/yZVlULcpAZ/nWHHo+5UB/dNvSPlzyd+BwVu+wqrJP8YUb1NqBbypIGIQ+
         vRKRhNpmhpSeoCXrA9i5gLxaEbUkYwBf0pAtle3VIPE9F5i0lLmOh9UGR/DSCOjPivJT
         BO/SZfAWHZsoUIVGLD5Pzkc9Qw2CzZZ3EU7Exyc8Si2RTIb7wBq0BgA26NKJl+p6jJq4
         AjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2eUvJv1pYLsbWEXE3zbo18Mq1onOR7/X9IXKiWcXcGE=;
        b=mvkHG74BSSrmMVyQM+2DvW77r1liDnA4ZogDBo1dkFWxk1VJJ7YwEXWMiRkH/c7Hl/
         +mA+WCYuhoSHAMd1UYT4oyoxjP7kDhJKe8oRv7ZqXr/yw7SJsAc8c/ARmj6y1PQ3i6wp
         QTcpEhnleXp6QU+j4A4G0WKYkOjH0hFRnjwjs0EqcrVHo87HOs6CVDQkuDYagmcA4EJV
         mTyhTND4kLka/C2x5Y2gtuRKd9EJjBrRQy3XYkkb9HR0sP7eAAPvGXsOrixUXj/LQH63
         vYUmOe3yT9Rp3Uu41i38h9Nk5Ujsz+yBAO/bpLlMnlziTIK4SFBBFy1pPxdiFQvfaMb0
         J+bg==
X-Gm-Message-State: APjAAAVF/LGw2hvksq3Nl0dUe4e1AHOBoszA2kn78GPFXd4lNQJZ3N7H
        +/aPW/C4fqGX8ikrw/NuooULJqIFZO0=
X-Google-Smtp-Source: APXvYqyDQHnEpybNeJ0Y5vVlb4NEDG44QW6w6GOVw1vPpn+gvm+vyIKa/KnXy4crsE4nObHVibtoKQ==
X-Received: by 2002:a65:5382:: with SMTP id x2mr14778421pgq.422.1567203424486;
        Fri, 30 Aug 2019 15:17:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n9sm6007802pjq.30.2019.08.30.15.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:17:04 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:16:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 14/19] ionic: Add initial ethtool support
Message-ID: <20190830151641.0aec4a3e@cakuba.netronome.com>
In-Reply-To: <4c140c92-38b7-7c81-2a82-d23df8d16252@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-15-snelson@pensando.io>
        <20190829161029.0676d6f7@cakuba.netronome.com>
        <4c140c92-38b7-7c81-2a82-d23df8d16252@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 14:25:12 -0700, Shannon Nelson wrote:
> On 8/29/19 4:10 PM, Jakub Kicinski wrote:
> > On Thu, 29 Aug 2019 11:27:15 -0700, Shannon Nelson wrote:  
> >> +static int ionic_get_module_eeprom(struct net_device *netdev,
> >> +				   struct ethtool_eeprom *ee,
> >> +				   u8 *data)
> >> +{
> >> +	struct ionic_lif *lif = netdev_priv(netdev);
> >> +	struct ionic_dev *idev = &lif->ionic->idev;
> >> +	struct ionic_xcvr_status *xcvr;
> >> +	char tbuf[sizeof(xcvr->sprom)];
> >> +	int count = 10;
> >> +	u32 len;
> >> +
> >> +	/* The NIC keeps the module prom up-to-date in the DMA space
> >> +	 * so we can simply copy the module bytes into the data buffer.
> >> +	 */
> >> +	xcvr = &idev->port_info->status.xcvr;
> >> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> >> +
> >> +	do {
> >> +		memcpy(data, xcvr->sprom, len);
> >> +		memcpy(tbuf, xcvr->sprom, len);
> >> +
> >> +		/* Let's make sure we got a consistent copy */
> >> +		if (!memcmp(data, tbuf, len))
> >> +			break;
> >> +
> >> +	} while (--count);  
> > Should this return an error if the image was never consistent?  
> 
> Sure, how about -EBUSY?

Or EAGAIN ? Not sure
