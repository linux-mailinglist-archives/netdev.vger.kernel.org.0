Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CF1CFEAC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgELTsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELTsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:48:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B9AC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:48:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 225E51283560D;
        Tue, 12 May 2020 12:48:22 -0700 (PDT)
Date:   Tue, 12 May 2020 12:48:21 -0700 (PDT)
Message-Id: <20200512.124821.904466601209022146.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] sfc: siena_check_caps fixups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
References: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:48:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 12 May 2020 14:23:03 +0100

> Fix a bug and a build warning introduced in a recent refactor.

Series applied, thanks Ed.
