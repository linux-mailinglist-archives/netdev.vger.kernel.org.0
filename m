Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363D412BB8D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 23:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfL0WIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 17:08:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL0WIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 17:08:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB402154CA4B5;
        Fri, 27 Dec 2019 14:08:04 -0800 (PST)
Date:   Fri, 27 Dec 2019 14:08:02 -0800 (PST)
Message-Id: <20191227.140802.1352896472054942836.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     aroulin@cumulusnetworks.com, netdev@vger.kernel.org,
        dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: Re: [PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226182042.3ca9cd94@hermes.lan>
References: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
        <20191226182042.3ca9cd94@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 14:08:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Thu, 26 Dec 2019 18:20:42 -0800

> You can't change definitions of headers in userspace api
> without breaking compatibility.

These haven't gone into a release yet, that's why I allowed this
change.
