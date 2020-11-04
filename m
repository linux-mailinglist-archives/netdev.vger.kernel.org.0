Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED32A6F63
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbgKDVK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbgKDVK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 16:10:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7142A207BB;
        Wed,  4 Nov 2020 21:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604524226;
        bh=Rfe6EDWmXv/uCD3Oe2IJ6Hr46BwJo6yybbLQbnrvgj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eYF5OCETbgc12pnxkvI258ZvtIwaEb9vFfmaA5wmy5/8Z4FlxvPy5JLbHB3YeJ+og
         t9VEGfrreVXfjHzG0xfAWz0PF4wDb/n94XHmuEP6A1evUsyhSXrV9T35fvVBnW3xBs
         CUJX1lW1MA+FxhEcELXNHSdpp6Z5LnNy/u046+Ik=
Date:   Wed, 4 Nov 2020 13:10:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA and ptp_classify_raw: saving some CPU cycles causes worse
 throughput?
Message-ID: <20201104131025.3f52b939@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104015834.mcn2eoibxf6j3ksw@skbuf>
References: <20201104015834.mcn2eoibxf6j3ksw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 03:58:34 +0200 Vladimir Oltean wrote:
> The only problem?
> Throughput is actually a few Mbps worse, and this is 100% reproducible,
> doesn't appear to be measurement error.

Is there any performance scaling enabled? IOW CPU freq can vary?
