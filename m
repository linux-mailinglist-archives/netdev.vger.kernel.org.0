Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42FF1B1248
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDTQvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTQvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:51:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70A9C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:51:21 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x77so2602052pfc.0
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+btvI/SWi1eOz/WmG1edL5d7s4ESP1gCxOZY2DiC1+I=;
        b=gwMijRdwZhARYCtKY2yPiIc/t+sF/KO9NyNsNeiK9XjWF57nZMqw4uGsmbOOsXuNcT
         cL1vptQdgdTsT+qpGYWa5zqTkC5Z7DlXoF1y3WT9L/L+GGV9XN1YWLCk3787JT4XgLfm
         EzrU9FX8IGTd4+u+hXD5VRsRckrnuu9Fdj33MwcqrUdMk7HUcKprdsYQ2eKeMVqoziSQ
         waM9h1H03MWiUDoJDPdfARSiL3bpZUXHXmw2FzUxkHWmMsFaWRSseba0oBh/IgEaRKaC
         IhT3+k4WBiI92ZzZZaRKUelczOoLRFJKEYouIeAya5k8TU2G86Ag8zmf30HA9NLALsgM
         4DHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+btvI/SWi1eOz/WmG1edL5d7s4ESP1gCxOZY2DiC1+I=;
        b=ug6Oi+Lr6zuudmMAB06o08PMcXQGDfUGVmBIatBPMyzbDWwEbXojd9qbOaQ1+vvrBR
         1APE6d1nod/u+5n5FdR9u7gYDf1hw8q4p/zC8w0+69XsztwMY7scjBoPZX1RTElwpN/y
         yrCnpPozitUtMiUMRqvdzLqRYYHmQER/zC/T7djj7/ZuZjo9ff/XaYMAskpcMRV2Hde0
         HFg1DvXPzOFJM0N1z+k7zdmp3SjlORZwskF0kKuYKVwPhXq3LtEf1p8offWH8RBLb0VO
         AWF7V0r89AEriqT+8Pb1/Wgq0EiMQx9coUOwbRidrBL+RXV9Bj7BTMk3wz4bOec8Nz6I
         QiJQ==
X-Gm-Message-State: AGi0Pua8ztwTllaq4pBuAmEgdQAAYxRfyNBebe2iXtNQ/wqPGUJH2JUp
        sTmh6uspoBMDO3Tor63smETtlU3sIibk+w==
X-Google-Smtp-Source: APiQypL2B4JVwNZInKkJsFLhB9hnr3VoC/z/eXffWWzJIhISvruL/SM8uCeE7ejLRrOgyT1ZJilW5A==
X-Received: by 2002:a62:e213:: with SMTP id a19mr17189879pfi.180.1587401481321;
        Mon, 20 Apr 2020 09:51:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z1sm115162pjt.42.2020.04.20.09.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:51:21 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:51:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     roucaries.bastien@gmail.com
Cc:     netdev@vger.kernel.org, sergei.shtylyov@cogentembedded.com
Subject: Re: [V2][PATH 0/6] iproute improve documentation of bridge
Message-ID: <20200420095112.1ea28962@hermes.lan>
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
        <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Apr 2020 01:50:32 +0200
roucaries.bastien@gmail.com wrote:

> Please found a serie improving documentation of bridge device.
> 
> Please review and apply
> 
> I could not understand some options in this page:
> - vlan_tunnel on  ? 
> 
> 
> [PATCH 1/6] Better documentation of mcast_to_unicast option
> [PATCH 2/6] Improve hairpin mode description
> [PATCH 3/6] Document BPDU filter option
> [PATCH 4/6] Better documentation of BDPU guard
> [PATCH 5/6] Document root_block option
> [PATCH 6/6] State of bridge STP port are now case insensitive
> 


Applied all these and fixed some old spelling errors on the man page.
