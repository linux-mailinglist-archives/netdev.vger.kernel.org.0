Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00120F05
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfEPTDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:03:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfEPTDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:03:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58121133E9760;
        Thu, 16 May 2019 12:03:03 -0700 (PDT)
Date:   Thu, 16 May 2019 12:03:01 -0700 (PDT)
Message-Id: <20190516.120301.1049819886106809536.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     jiri@mellanox.com, pablo@netfilter.org, netdev@vger.kernel.org,
        jianbol@mellanox.com
Subject: Re: [PATCH net 0/2] flow_offload: fix CVLAN support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
References: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:03:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 14 May 2019 21:16:08 +0100

> When the flow_offload infrastructure was added, CVLAN matches weren't
>  plumbed through, and flow_rule_match_vlan() was incorrectly called in
>  the mlx5 driver when populating CVLAN match information.  This series
>  adds flow_rule_match_cvlan(), and uses it in the mlx5 code.
> Both patches should also go to 5.1 stable.

Series applied and queued up for -stable, thanks.
