Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8899226E3B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgGTS1O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jul 2020 14:27:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:36590 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGTS1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 14:27:14 -0400
IronPort-SDR: Ixfl6W2yHBfiZ2Qn3XOx/w3ZqpuGz/EGtqZ4259qSAVPiy5VCyHJzRXKh+oFAk9zbg8dcuKGb5
 dy6Tvn9f3TQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="234833582"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="234833582"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 11:27:13 -0700
IronPort-SDR: LciR8i+5hPPn2C8YWR2PgOwnfBO22YUN1SqDrdx49Mw4yHNNjn8BllG42acue01tjujKSmSA1w
 qjV6jaW6K+ig==
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="487336367"
Received: from jrmontoy-mobl.amr.corp.intel.com (HELO localhost) ([10.209.71.203])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 11:27:13 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200720001046.g7y3p7wrua5qz6i2@lion.mk-sys.cz>
References: <20200707234800.39119-1-andre.guedes@intel.com> <20200720001046.g7y3p7wrua5qz6i2@lion.mk-sys.cz>
Subject: Re: [Intel-wired-lan] [PATCH ethtool 0/4] Add support for IGC driver
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
To:     Michal Kubecek <mkubecek@suse.cz>
Date:   Mon, 20 Jul 2020 11:27:12 -0700
Message-ID: <159526963226.8351.8054617544521796564@jrmontoy-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

Quoting Michal Kubecek (2020-07-19 17:10:46)
> On Tue, Jul 07, 2020 at 04:47:56PM -0700, Andre Guedes wrote:
> > Hi all,
> > 
> > This patch series adds support for parsing registers dumped by the IGC driver.
> > For now, the following registers are parsed:
> > 
> >       * Receive Address Low (RAL)
> >       * Receive Address High (RAH)
> >       * Receive Control (RCTL)
> >       * VLAN Priority Queue Filter (VLANPQF)
> >       * EType Queue Filter (ETQF)
> > 
> > More registers should be parsed as we need/enable them.
> > 
> > Cheers,
> > Andre
> 
> Series merged. But please consider making the output consistent with
> other Intel drivers which use lowercase keywords for values (e.g.
> "enabled") and "yes"/"no" for bool values (rather than "True" / "False").

Sure, I'll send a patch aligning this.

- Andre
