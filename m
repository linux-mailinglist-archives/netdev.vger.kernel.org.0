Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0801717CA46
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCGBXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:23:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgCGBXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 20:23:49 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E1E2067C;
        Sat,  7 Mar 2020 01:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583544229;
        bh=9yMPY5G44+GfhbYYN3t/XN227IJWweJBBXma0sO8iE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJj7gv4+UrxbNCzgsj2DBuw0KbnOY2Y7LvcHGX6NJ5zR7RHp2dh3uDflaPvZ/SYrd
         WRpkXyXGLJPnrO85z5xcPN8eExMDOzMRyNpqhCoUJjGYQVsYktWGc/FHZYIYMe/Bez
         XO2gnuIBV9lglqlheP26XxN7lJx+yykpLLBQSGD8=
Date:   Fri, 6 Mar 2020 17:23:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 0/8] ionic updates
Message-ID: <20200306172347.1e79995a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 17:04:00 -0800 Shannon Nelson wrote:
> This is a set of small updates for the Pensando ionic driver, some
> from internal work, some a result of mailing list discussions.
> 
> v4 - don't register mgmt device netdev
> v3 - changed __attribute__(packed)) to __packed
> v2 - removed print from ionic_init_module()

Acked-by: Jakub Kicinski <kuba@kernel.org>
