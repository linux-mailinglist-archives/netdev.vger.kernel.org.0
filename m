Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653EE22A3A6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbgGWAcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGWAcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:32:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1076DC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:32:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8F0711FFCC2A;
        Wed, 22 Jul 2020 17:15:48 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:32:33 -0700 (PDT)
Message-Id: <20200722.173233.132610667256223878.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: Remove the imdio bus on PF probe
 bailout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595421528-14063-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595421528-14063-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:15:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Wed, 22 Jul 2020 15:38:48 +0300

> enetc_imdio_remove() is missing from the enetc_pf_probe()
> bailout path. Not surprisingly because enetc_setup_serdes()
> is registering the imdio bus for internal purposes, and it's
> not obvious that enetc_imdio_remove() currently performs the
> teardown of enetc_setup_serdes().
> To fix this, define enetc_teardown_serdes() to wrap
> enetc_imdio_remove() (improve code maintenance) and call it
> on bailout and remove paths.
> 
> Fixes: 975d183ef0ca ("net: enetc: Initialize SerDes for SGMII and USXGMII protocols")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks.
