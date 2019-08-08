Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654EE868B9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfHHS0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:26:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHS0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:26:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A35D154FA00B;
        Thu,  8 Aug 2019 11:26:37 -0700 (PDT)
Date:   Thu, 08 Aug 2019 11:26:36 -0700 (PDT)
Message-Id: <20190808.112636.698040063448774208.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/2] pull request for net: batman-adv 2019-08-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808130208.2124-1-sw@simonwunderlich.de>
References: <20190808130208.2124-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 11:26:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu,  8 Aug 2019 15:02:06 +0200

> here are some bugfixes which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled.
