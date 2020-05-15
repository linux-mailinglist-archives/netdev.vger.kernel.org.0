Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC481D5670
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgEOQqO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 May 2020 12:46:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:22011 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgEOQqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 12:46:14 -0400
IronPort-SDR: k8ZYS55g+c9VsRMbhsJNEzy1gnSMZHUyW86+45hIcr0lyguTv8e0AiUoLCGC4jNYV3PDuVb/Sd
 CJdqM5i8XlSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 09:46:12 -0700
IronPort-SDR: Lj2PgSML2oY1ITYwVZRnSiMyfRI+artquANUMvJTIH8mOezDPb96FLHy03v7D+aD7vZPv2f3S0
 pHuiFxm2nFvQ==
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="287845247"
Received: from akiranx-mobl.amr.corp.intel.com (HELO localhost) ([10.254.65.74])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 09:46:10 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200515042139.749859-5-jeffrey.t.kirsher@intel.com>
References: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com> <20200515042139.749859-5-jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next v3 4/9] igc: Use netdev log helpers in igc_ethtool.c
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Date:   Fri, 15 May 2020 09:46:09 -0700
Message-ID: <158956116965.37785.11864549120054924700@akiranx-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,

Quoting Jeff Kirsher (2020-05-14 21:21:34)
> From: Andre Guedes <andre.guedes@intel.com>
> 
> In igc_ethtool.c we print log messages using dev_* helpers, generating
> inconsistent output with the rest of the driver. Since this is a network
> device driver, we should preferably use netdev_* helpers because they
> append the interface name to the message, helping making sense the of
> the logs.
> 
> This patch converts all dev_* calls to netdev_*. It also takes this
> opportunity to remove the '\n' character at the end of messages since it
> is automatically added by netdev_* log helpers.

It seems you missed removing the statement about '\n' from the commit message.
It doesn't apply anymore, as mentioned in the cover letter.

The commit message from the other patches in this series needs to be updated as
well.

Thank you,

Andre
