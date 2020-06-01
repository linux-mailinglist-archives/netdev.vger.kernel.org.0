Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ABB1EB219
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 01:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgFAXUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 19:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgFAXUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 19:20:04 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D792076B;
        Mon,  1 Jun 2020 23:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591053603;
        bh=LL2OFbA9hmDKUIIU0X+rhKCZsVdGpVK1b35uEP/K+kI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G2/P9cU1t5MXKoGoDztahotV0peBM8lHNo1wh0AI+wapsxMGWRk5DdNjlky2oe43b
         n6XTkRszXzIdiPUaV82nnowW7h9U7A2gPJStsSnvx1XwObO5oP5C5JdTqMORp8UMSF
         MoTwg/XdLL6WcAbBdGmqmZLEM7qq2vDw/1kc1TUo=
Date:   Mon, 1 Jun 2020 16:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset'
 and 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601162001.32a4e388@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200601095838.GK2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200601095838.GK2282@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 11:58:38 +0200 Jiri Pirko wrote:
> > Documentation/networking/devlink/bnxt.rst          |  4 ++
> > .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> > drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> > drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> > drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> > drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> > include/net/devlink.h                              |  8 +++
> > net/core/devlink.c                                 | 10 ++++  
> 
> Could you please cc me to this patchset? use scripts/maintainers to get
> the cc list.
> 
> It is also customary to cc people that replied to the previous patchset
> versions.

+1
