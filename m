Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B8836F884
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhD3KdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 06:33:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:57594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhD3Kc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 06:32:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619778729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRDn1eXWi0C3SNbb3dsMrSo7NV9H6pAw/K7T2xmhix0=;
        b=rpf2Ge3xYNKc96PG5Zt87e3sCJ2rQy01JLvIsM8uXF56dQda6yHxpW4No9dd+ErPYINDhZ
        ZeArl1fXyQdh/+oCMS59Rc68qoSHItcVxWHonBSrOyn9lmHF90iZ0hqJ+WTq7cT5cRGCIs
        1e5/mzletz6t2APv3Jg3vuvMnu3MMwc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A0769B28F;
        Fri, 30 Apr 2021 10:32:09 +0000 (UTC)
Message-ID: <61b189cfd64e6d2a185ffc0178265caa693fa735.camel@suse.com>
Subject: Re: [RFC net-next 1/2] usb: class: cdc-wdm: add control type
From:   Oliver Neukum <oneukum@suse.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, kuba@kernel.org,
        bjorn@mork.no
Date:   Fri, 30 Apr 2021 12:32:05 +0200
In-Reply-To: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
References: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 30.04.2021, 12:16 +0200 schrieb Loic Poulain:
> Add type parameter to usb_cdc_wdm_register function in order to
> specify which control protocol the cdc-wdm channel is transporting.
> It will be required for exposing the channel(s) through WWAN framework.

Hi,

that is an interesting framework.
Some issues though.

	Regards
		Oliver

> +/**
> + * enum usb_cdc_wdm_type - CDC WDM endpoint type
> + * @USB_CDC_WDM_UNKNOWN: Unknown type
> + * @USB_CDC_WDM_MBIM: Mobile Broadband Interface Model control
> + * @USB_CDC_WDM_QMI: Qualcomm Modem Interface for modem control
> + * @USB_CDC_WDM_AT: AT commands interface
> + */
> +enum usb_cdc_wdm_type {
> +	USB_CDC_WDM_UNKNOWN,
> +	USB_CDC_WDM_MBIM,
> +	USB_CDC_WDM_QMI,
> +	USB_CDC_WDM_AT
> +};


If this is supposed to integrate CDC-WDM into a larger subsystem, what
use are private types here? If you do this the protocols need to come
from the common framework.

