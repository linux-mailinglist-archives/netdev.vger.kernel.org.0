Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5465E1DD30B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgEUQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbgEUQXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 12:23:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA3420748;
        Thu, 21 May 2020 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590078205;
        bh=Ae4Jn1mpqdKTpKLmkJvx38uMoUIkGU2ZsIvdjdM+GiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sgjzzBM4qTW9YV4X8eo2YWLjXnF44UIuGaZkKJJWmLAtWVR0RsbZXLVaMh2/glRVY
         gsxCTGHcPJJGcz7W58zGM4zm4QsLXK20KPSnDBDV4YgnpD3JET+wDS0XRpWiqrYkPs
         5ynTEqK8iOtbpawkGN9G9ENmKBM0wFx+YxMbiOWw=
Date:   Thu, 21 May 2020 09:23:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Andre Guedes <andre.guedes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 03/15] igc: Add support for source address filters in
 core
Message-ID: <20200521092323.70b8c9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200521072758.440264-4-jeffrey.t.kirsher@intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
        <20200521072758.440264-4-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 00:27:46 -0700 Jeff Kirsher wrote:
>  /**
>   * igc_del_mac_filter() - Delete MAC address filter
>   * @adapter: Pointer to adapter where the filter should be deleted from
> + * #type: MAC address filter type (source or destination)

@ here^ otherwise:

drivers/net/ethernet/intel/igc/igc_main.c:2282: warning: Function parameter or member 'type' not described in 'igc_del_mac_filter'

>   * @addr: MAC address
>   *
>   * Return: 0 in case of success, negative errno code otherwise.
>   */
> -int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
> +int igc_del_mac_filter(struct igc_adapter *adapter,
> +		       enum igc_mac_filter_type type, const u8 *addr)
