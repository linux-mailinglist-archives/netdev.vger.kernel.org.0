Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B5476F7
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfFPV0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:26:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfFPV0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:26:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7061151C3C55;
        Sun, 16 Jun 2019 14:26:33 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:26:33 -0700 (PDT)
Message-Id: <20190616.142633.1299521959503380513.davem@davemloft.net>
To:     jeremy@azazel.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] x25_asy: fixed function name in error message.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190616104332.20315-1-jeremy@azazel.net>
References: <20190616104332.20315-1-jeremy@azazel.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:26:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 16 Jun 2019 11:43:32 +0100

> Replaced incorrect hard-coded function-name in error message with
> __func__.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Applied.
