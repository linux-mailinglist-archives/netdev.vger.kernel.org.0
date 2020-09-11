Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FE72669D8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgIKVAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgIKVAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 17:00:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DDF206E6;
        Fri, 11 Sep 2020 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599858040;
        bh=7yhmNx+3MX6nfL2hrBDkP2pkNtPrIKZQqJnahOEAX/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0YmErCsLbcKJ1nR9BzQ1c/3RLowChCcALMZoj0Lh5WacNZRRHTsoS2/W0Lef2usV3
         y42K4cS9fYVYeyZQ5nEFXwNMKrRtWUvoI2HbToJJ/a6dpQTE2jGwPcEi4Kg6O5/Bpk
         sLaZ/5gUyyq+r9pzUkUB7ze0hzyZd0/qDZTfIUP0=
Date:   Fri, 11 Sep 2020 14:00:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] sfc: misc cleanups
Message-ID: <20200911140038.5802bae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
References: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 19:43:26 +0100 Edward Cree wrote:
> Clean up a few nits I noticed while working on TXQ stuff.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
