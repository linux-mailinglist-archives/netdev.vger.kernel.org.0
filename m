Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84713E780E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbfJ1SEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:04:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1SEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:04:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E43FF1481AD0D;
        Mon, 28 Oct 2019 11:04:51 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:04:47 -0700 (PDT)
Message-Id: <20191028.110447.585551933821344446.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     arkadiusz.grubba@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com, alice.michael@intel.com
Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along
 with PF core stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028103047.6d868753@cakuba.hsd1.ca.comcast.net>
References: <20191023204149.4ae25f90@cakuba.hsd1.ca.comcast.net>
        <35C27A066ED4844F952811E08E4D95090D398A32@IRSMSX103.ger.corp.intel.com>
        <20191028103047.6d868753@cakuba.hsd1.ca.comcast.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 11:04:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 28 Oct 2019 10:30:47 -0700

> It's not a matter of preference. I object to abuse of free-form APIs
> for things which have proper, modern interfaces.

+1
