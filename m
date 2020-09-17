Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1070C26E4EE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgIQTC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIQTCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 15:02:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA2720853;
        Thu, 17 Sep 2020 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600369365;
        bh=YyWmq+O7vf/xuK7V23zkIBjXsWJcQpjnO+aQbU96mns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mAGKY7VOhEPju0eHc82Tx2j5egFUDCltVhAEGRM+bZYX4xXkqg17iQd4zklkl32MU
         RuL6uYpk6ZesCuhjj1wLJdpB2R518ISQLMWSgsHzxddpkACdqOeyLPntN/MDPvldyi
         2UIanf0Ayb8/y83Q6aosbqRpgAHS3GzT/m+Ng5Xk=
Date:   Thu, 17 Sep 2020 12:02:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] ionic: add DIMLIB to Kconfig
Message-ID: <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917184243.11994-1-snelson@pensando.io>
References: <20200917184243.11994-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 11:42:43 -0700 Shannon Nelson wrote:
> >> ld.lld: error: undefined symbol: net_dim_get_rx_moderation  
>    >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
>    >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a  
> --

This is going to cut off the commit message when patch is applied.

> >> ld.lld: error: undefined symbol: net_dim  
>    >>> referenced by ionic_txrx.c:456 (drivers/net/ethernet/pensando/ionic/ionic_txrx.c:456)
>    >>> net/ethernet/pensando/ionic/ionic_txrx.o:(ionic_dim_update) in archive drivers/built-in.a  
> 
> Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

