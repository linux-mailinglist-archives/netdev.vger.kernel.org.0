Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4561D1CB731
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEHS3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHS3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 14:29:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1354216FD;
        Fri,  8 May 2020 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588962563;
        bh=vIGnp/LZUcw0nI2qzZWnkJVjHfLNC4lt6Owfvnot4Ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DOICiuCsG4c+GwYRo6BHDT8zwZxe7YoXVyW5lIETZ9l1s8os2dq0fpJ7WJ76BWZov
         Jf5JsB8kHpX7DP2K6UBtRcMgmXil1jukb1Vzf1b6x3Aq2RCKA15UZB5g8IN0TyP984
         ggj3dvCXIq+SvCzH+Qv2s9bO8OYAOzYDHPahfIBE=
Date:   Fri, 8 May 2020 11:29:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kelly Littlepage <kelly@onechronos.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        edumazet@google.com, iris@onechronos.com, kuznet@ms2.inr.ac.ru,
        maloney@google.com, netdev@vger.kernel.org, soheil@google.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v3] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Message-ID: <20200508112920.141e722f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508142309.11292-1-kelly@onechronos.com>
References: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
        <20200508142309.11292-1-kelly@onechronos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 14:23:10 +0000 Kelly Littlepage wrote:
> Any review, copying, or distribution of this email (or any 
> attachments thereto) by others is strictly prohibited.

I'm afraid you'll have to do something about this footer if you want
the patch to be applied.. Is sending from a different email an option?

(please make sure to add the review and ack tags you received 
from folks to your commit before reposting)
