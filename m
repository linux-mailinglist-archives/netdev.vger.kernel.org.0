Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB318E57
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfEIQpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:45:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfEIQpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:45:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E304F14D067E4;
        Thu,  9 May 2019 09:45:34 -0700 (PDT)
Date:   Thu, 09 May 2019 09:45:34 -0700 (PDT)
Message-Id: <20190509.094534.198032577179477261.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/2] pull request for net: batman-adv 2019-05-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509132815.3723-1-sw@simonwunderlich.de>
References: <20190509132815.3723-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:45:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu,  9 May 2019 15:28:13 +0200

> here are some bugfixes which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
