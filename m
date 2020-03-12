Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE5182898
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbgCLFxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:53:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55944 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbgCLFxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:53:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C47414C76FA9;
        Wed, 11 Mar 2020 22:53:48 -0700 (PDT)
Date:   Wed, 11 Mar 2020 22:53:47 -0700 (PDT)
Message-Id: <20200311.225347.1215946857946325610.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com
Subject: Re: [PATCH net] MAINTAINERS: remove Sathya Perla as Emulex NIC
 maintainer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311233702.2179475-1-kuba@kernel.org>
References: <20200311233702.2179475-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 22:53:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 11 Mar 2020 16:37:02 -0700

> Remove Sathya Perla, sathya.perla@broadcom.com is bouncing.
> The driver has 3 more maintainers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks.
