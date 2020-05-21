Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108D41DC5FA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 05:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEUD5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 23:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgEUD5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 23:57:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C30C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 20:57:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FAD712768955;
        Wed, 20 May 2020 20:57:14 -0700 (PDT)
Date:   Wed, 20 May 2020 20:57:13 -0700 (PDT)
Message-Id: <20200520.205713.534806326623688168.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986C8744@ORSMSX112.amr.corp.intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
        <20200520.192828.1242706969153634308.davem@davemloft.net>
        <61CC2BC414934749BD9F5BF3D5D94044986C8744@ORSMSX112.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 20:57:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Thu, 21 May 2020 03:39:26 +0000

> Thanks, have you been able to push you tree to kernel.org yet?

Sorry, it's there now.
