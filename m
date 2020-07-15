Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAACF221181
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGOPsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgGOPsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 11:48:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7469A2065E;
        Wed, 15 Jul 2020 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594828093;
        bh=DytEPzCFC0cofVJ96OBN2N2dqiXbOIjH5qes3BR/x78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TvvkQqp+WWVi2SH86ripOr7Pjwm4HvK1l0VFU4l6GUmjKhv+M50eUovxzBu3NEWSo
         iLTSkAxVw2TWQRHPNiVmVKF4/vrJrVjJf+IvYG3sVhKNc70g5mJm8vmnouKjEiyfoQ
         GifCWMpVqLumO+6z0tVgnFuRX4R86X95eds6DTIw=
Date:   Wed, 15 Jul 2020 08:48:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
Message-ID: <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:
> Drop doubled words in several comments.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.

Would you mind splitting those 5 patches out to a separate series and
sending to him?
