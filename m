Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E00227373
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGUAFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGUAFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:05:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42ACC061794;
        Mon, 20 Jul 2020 17:05:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D68B11E8EC0D;
        Mon, 20 Jul 2020 16:48:29 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:05:13 -0700 (PDT)
Message-Id: <20200720.170513.433342552290622235.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2020-07-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720094009.1807496-1-stefan@datenfreihafen.org>
References: <20200720094009.1807496-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 16:48:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Mon, 20 Jul 2020 11:40:09 +0200

> An update from ieee802154 for your *net* tree.
> 
> A potential memory leak fix for adf7242 from Liu Jian,
> and one more HTTPS link change from Alexander A. Klimov.

Pulled.
