Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB21F3936
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgFILMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgFILMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 07:12:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0CE7207ED;
        Tue,  9 Jun 2020 11:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591701174;
        bh=OdDa6FOuHaEzYzy7yhXy/IuRfvsjZXDtHPm1HnIBno8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lgSKqYnFRv3uB3Y4aOb8f2660QiGhY534hS78U9s6Z4YRKrhQfRRDWPbNwffZzbYa
         wjGTLDiaSuwNPJTelJzjWtrgH6fQrz6e5+Fm+Mr4fkzDbu8jg98IdhhE5245A5dWz7
         gXMhgdR3plUBAbHcEOsygM60HeYdOXs2JRgOtTWA=
Date:   Tue, 9 Jun 2020 13:12:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 4/7] printk: Add pr_debug_level macro over dynamic one
Message-ID: <20200609111252.GB780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-5-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-5-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:46:01PM +0300, Stanimir Varbanov wrote:
> Introduce new pr_debug_level macro over dynamic_debug level one
> to allow dynamic debugging to show only important messages.

What does "important messages" mean???

