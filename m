Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D666768A
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfGLWd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:33:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfGLWd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:33:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AD6114E01C3A;
        Fri, 12 Jul 2019 15:33:26 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:33:26 -0700 (PDT)
Message-Id: <20190712.153326.1808520705552022128.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] Fix bugs in NFP flower match offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
References: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:33:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Wed, 10 Jul 2019 19:30:28 +0100

> This patchset contains bug fixes for corner cases in the match fields of
> flower offloads. The patches ensure that flows that should not be
> supported are not (incorrectly) offloaded. These include rules that match
> on layer 3 and/or 4 data without specified ethernet or ip protocol fields.

Series applied.
