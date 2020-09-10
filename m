Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B14F264859
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIJOuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbgIJOsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:48:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE0B21D81;
        Thu, 10 Sep 2020 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599749320;
        bh=rrvs+f/o8Y4U7NPdlZTvi2xbaVua7DLP46ZHGj4VQYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1RmybbJih6ly35QWuKJBpLxcmtlYZiV0VbHogomazkeOj5NFFI1+NjXXeQHmuILxR
         Rx+FW2jVA1G+ybe0LVnCOaILOc8g59kQW/Lifr4vt/08AiEBmiiJ+TTtjxIbe7WS+B
         8jp8TimRstFPt+6yJa6eKfzaMhOLPJmUUJHhH22o=
Date:   Thu, 10 Sep 2020 07:48:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-09
Message-ID: <20200910074838.72c842aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 17:04:07 -0700 Tony Nguyen wrote:
> This series contains updates to i40e and igc drivers.
> 
> Stefan Assmann changes num_vlans to u16 to fix may be used uninitialized
> error and propagates error in i40_set_vsi_promisc() for i40e.
> 
> Vinicius corrects timestamping latency values for i225 devices and
> accounts for TX timestamping delay for igc.

Hi!

FWIW patch 3 did not make it to the ML, so you'll need to resend.

How are my patches?
