Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E695D250A2D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgHXUlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgHXUlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:41:08 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA550205CB;
        Mon, 24 Aug 2020 20:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598301667;
        bh=hv0FQgsexIJEgwzyyveO6q/B7ODqzymQSE9GH/O8a34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TnMC1C3EducKp59yyGn9H95eHPTw93/1iwecg4+IDwytf0M3MccXnaZYjTzrQkFfY
         2sFwOYD3DLmOEaWAmlK4BJ+OziOxAB8WalKi3hpkRk0EAw8pCwuMm8iL7slQpvPVkn
         D+hzDIrhykJGKr7xqyzrgsVTTdz6J8YeqAy+9yNs=
Date:   Mon, 24 Aug 2020 13:41:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 04/15] iecm: Common module introduction and
 function stubs
Message-ID: <20200824134105.1010fd2f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824173306.3178343-5-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 10:32:55 -0700 Tony Nguyen wrote:
> +static inline bool
> +iecm_tx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget)
> +{
> +	/* stub */
> +}

Still a lot of static inlines throughout. Are they making any
difference? The compiler will inline static functions, anyway.
