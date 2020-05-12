Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F731CFBB7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgELRNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgELRNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 13:13:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2837B206B8;
        Tue, 12 May 2020 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589303603;
        bh=yavipBAgNxESlUH1+zObCk2h+M4Lu94gvJWKl7+hGw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xftJVv7g95twgvCBOgpW/IXM6So85z/HabnaWZz3hgvYsNbjG5u8Sp9uu1KGt5eJa
         aJS3EL03sRtAjcgdGXSo3ShSOB+9lhQ0QUZIlZFp+NfMQnJJIWyQ1eV/RrQ1sXjD+1
         fSGgllP5nWjizlOWqVeBaf7LjiqlBYqCQ1vE4Oh4=
Date:   Tue, 12 May 2020 10:13:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 00/10] ionic updates
Message-ID: <20200512101321.164ffa20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 17:59:26 -0700 Shannon Nelson wrote:
> This set of patches is a bunch of code cleanup, a little
> documentation, longer tx sg lists, more ethtool stats,
> and a couple more transceiver types.

I wish patch 3 was handled by the core, but no great ideas on that so:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
