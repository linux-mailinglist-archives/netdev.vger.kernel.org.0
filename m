Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759B33B6BA3
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhF2ARl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:17:41 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:34280 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhF2ARk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:17:40 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2021 20:17:40 EDT
Received: (qmail 80833 invoked by uid 89); 29 Jun 2021 00:08:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 29 Jun 2021 00:08:32 -0000
Date:   Mon, 28 Jun 2021 17:08:30 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210629000830.cjhxf4btqoyqqgfj@bsd-mbp.dhcp.thefacebook.com>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
 <20210628233835.GB766@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628233835.GB766@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 04:38:35PM -0700, Richard Cochran wrote:
> On Mon, Jun 28, 2021 at 11:25:33AM -0700, Jonathan Lemon wrote:
> > When creating a PTP device, the configuration block allows
> > creation of an associated PPS device.  However, there isn't
> > any way to associate the two devices after creation.
> > 
> > Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.
> 
> Setting lookup_cookie is harmless, AFAICT, but I wonder about the use
> case.  The doc for pps_lookup_dev() says,
> 
>  * This is a bit of a kludge that is currently used only by the PPS                                                                      
>  * serial line discipline.
> 
> and indeed that is the case.
> 
> The PHC devices are never serial ports, so how does this help?

This is for the ptp_ocp driver, I have an update coming.

The systems I'm using have the OpenCompute time card and 
several nics, all of which publish PTP/PPS devices.

When there are several PPS devices, this patch allows
selecting the correct one.
-- 
Joanthan
