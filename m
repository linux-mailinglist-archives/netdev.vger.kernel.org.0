Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3503B14727C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgAWUT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:19:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWUT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:19:28 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 050CA14EAA3FA;
        Thu, 23 Jan 2020 12:19:26 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:19:25 +0100 (CET)
Message-Id: <20200123.211925.435298296234156483.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579702514-11190-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579702514-11190-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:19:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Wed, 22 Jan 2020 16:15:14 +0200

> As the only 10G PHY interface type defined at the moment the code
> was developed was XGMII, although the PHY interface mode used was
> not XGMII, XGMII was used in the code to denote 10G. This patch
> renames the 10G interface mode to remove the ambiguity.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Applied, thanks.
