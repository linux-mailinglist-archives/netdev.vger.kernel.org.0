Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762B2164DF7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSSv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:51:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgBSSv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:51:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21FE315ADF42A;
        Wed, 19 Feb 2020 10:51:26 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:51:25 -0800 (PST)
Message-Id: <20200219.105125.1836568425633084521.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH 0/3] octeontx2-af: Cleanup changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:51:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Wed, 19 Feb 2020 15:21:05 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> These patches cleanup AF driver by removing unnecessary function
> exports and cleanup repititive logic.

Series applied, thanks.
