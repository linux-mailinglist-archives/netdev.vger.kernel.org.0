Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF1266237
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgIKPeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgIKPd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:33:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FAC8206E9;
        Fri, 11 Sep 2020 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599838436;
        bh=YiXNfhjvDnY0G4ItNq/VcETvX2XaKO1hUeBu6bHsXgc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CeF6k0Ul3j6XTLLDLgYROknjdKXeNUfLxG7N1Oa/sCpRXLQ9Meb87eJAxsCO2zYsH
         m633xlE772hKjU1UvNWCnDiTUVW7bl1Qqe6/hHGHRGttsGire8LNLV8XKEKIiHLm5m
         2RE/kUd47M+RnB9GogUb6b+zfCvNRaLmf2+Arr04=
Date:   Fri, 11 Sep 2020 08:33:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH net-next] i40e: allow VMDQs to be used with AF_XDP
 zero-copy
Message-ID: <20200911083354.7e501505@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 14:08:26 +0200 Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> reason, we only allowed main VSIs to be used with zero-copy, but
> there is now reason to not allow VMDQs also.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

The VMQ interfaces that you create through a debugfs command interfaces?

IDK if we should add features to those, or pretend they never existed
in the first place..
