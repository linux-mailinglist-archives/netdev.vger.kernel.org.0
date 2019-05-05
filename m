Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6568F14176
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfEERbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:31:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEERbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:31:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A963714DA6474;
        Sun,  5 May 2019 10:31:54 -0700 (PDT)
Date:   Sun, 05 May 2019 10:31:54 -0700 (PDT)
Message-Id: <20190505.103154.823912444487756109.davem@davemloft.net>
To:     laurentiu.tudor@nxp.com
Cc:     netdev@vger.kernel.org, madalin.bucur@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com,
        Joakim.Tjernlund@infinera.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] dpaa_eth: fix SG frame cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503130311.9914-1-laurentiu.tudor@nxp.com>
References: <20190503130311.9914-1-laurentiu.tudor@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:31:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: laurentiu.tudor@nxp.com
Date: Fri,  3 May 2019 16:03:11 +0300

> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> 
> Fix issue with the entry indexing in the sg frame cleanup code being
> off-by-1. This problem showed up when doing some basic iperf tests and
> manifested in traffic coming to a halt.
> 
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Acked-by: Madalin Bucur <madalin.bucur@nxp.com>

Applied and queued up for -stable.
