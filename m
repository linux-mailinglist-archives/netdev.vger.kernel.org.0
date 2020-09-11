Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39D32669CF
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIKUzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgIKUzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 16:55:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7318206B8;
        Fri, 11 Sep 2020 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599857735;
        bh=84N3IrLlp8f0OviMq0rVBsDTFKRqki+ueFahSbEPzK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ocLsxR706JKtqjZj6UIPhG1eYtnh7K3zsyayQcfoYL/SZgSY5Hu1i2e+A4xAvngEz
         ZYbkO4Sbs6pTDhpMhy8CmjUqHcWub00ddZFvCIModgs/cGzkqWoVMht9n8ylVSrHHw
         yrRNlLDFXFMZsjEgH/72UdWcCgy3491KsvNLCdPg=
Date:   Fri, 11 Sep 2020 13:55:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/8] Add GVE Features.
Message-ID: <20200911135533.5ec11992@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
References: <20200911173851.2149095-1-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 10:38:43 -0700 David Awogbemila wrote:
> Note: Patch 4 in v3 was dropped.
> 
> Patch 4 (patch 5 in v3): Start/stop timer only when report stats is
> 				enabled/disabled.
> Patch 7 (patch 8 in v3): Use netdev_info, not dev_info, to log
> 				device link status.

Acked-by: Jakub Kicinski <kuba@kernel.org>
