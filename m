Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806C22F1EB9
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390890AbhAKTNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390831AbhAKTNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B549A22AED;
        Mon, 11 Jan 2021 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610392373;
        bh=9W97AebDrZ13JYKlnYc1iSHuo03By8Lo1lkOPNU8T/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MD4wLfzOGsTMX36CmEO6TE4mUBCmNoz/0suChIEHBAfQAACXMbyTMFRBCgdRQQ89d
         gVvxMsJem/yJBjW4FaAowQkx+rd7UC1IuEVBPnkoLLe54SdFkGbgt8S4ExkG93pocm
         EwCdcqB1xnBSv7OZIqaZDHL5aiPMc6Iq8FCoE/QvK3cbArx+ADnIVc5d+/8ue8HpJv
         ZvFK/nxWG0/Eimu+fZJdo0a8/F/PiZWbvelJh4u0qtJ4IQxl/BSLeJsO53qhKZtV4p
         hCRc5eobz7OM7l2Fz4Vnzx8hdJSky2RW+eV+hQ3F2Qrg2O5mqeHmDZkcjCucpPuKUv
         7WtT1VIZe+Bxg==
Date:   Mon, 11 Jan 2021 11:12:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 04/10] net: dsa: felix: reindent struct
 dsa_switch_ops
Message-ID: <20210111111251.07a6efc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111170158.x65oarb4ilw7ytcp@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-5-olteanv@gmail.com>
        <20210109172419.63dcaea9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111170158.x65oarb4ilw7ytcp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:01:58 +0200 Vladimir Oltean wrote:
> On Sat, Jan 09, 2021 at 05:24:19PM -0800, Jakub Kicinski wrote:
> > On Fri,  8 Jan 2021 19:59:44 +0200 Vladimir Oltean wrote:  
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > The devlink function pointer names are super long, and they would break
> > > the alignment. So reindent the existing ops now by adding one tab.  
> >
> > Therefore it'd be tempting to prefix them with dl_ rather than full
> > devlink_  
> 
> Indentation is broken even with devlink_sb_occ_tc_port_bind_get reduced
> to dl_sb_occ_tc_port_bind_get.

Ack, still, shorter is better IMHO.
