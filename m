Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E825159E7F
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgBLBGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:06:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgBLBGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:06:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E20DD1516D613;
        Tue, 11 Feb 2020 17:06:35 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:06:35 -0800 (PST)
Message-Id: <20200211.170635.1835700541257020515.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH] ptp_qoriq: add initialization message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211045053.8088-1-yangbo.lu@nxp.com>
References: <20200211045053.8088-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 17:06:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Tue, 11 Feb 2020 12:50:53 +0800

> It is necessary to print the initialization result.

No, it is not.
