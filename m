Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D98F1E4C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbfKFTLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:11:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbfKFTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:11:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C2DE14B8DDB6;
        Wed,  6 Nov 2019 11:11:43 -0800 (PST)
Date:   Wed, 06 Nov 2019 11:11:42 -0800 (PST)
Message-Id: <20191106.111142.2137515356801323066.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] selftests: devlink: undo changes at the end
 of resource_test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105212817.11158-1-jakub.kicinski@netronome.com>
References: <20191105212817.11158-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 11:11:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue,  5 Nov 2019 13:28:17 -0800

> The netdevsim object is reused by all the tests, but the resource
> tests puts it into a broken state (failed reload in a different
> namespace). Make sure it's fixed up at the end of that test
> otherwise subsequent tests fail.
> 
> Fixes: b74c37fd35a2 ("selftests: netdevsim: add tests for devlink reload with resources")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
