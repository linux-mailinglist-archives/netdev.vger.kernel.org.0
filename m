Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB443A7747
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfICWum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:50:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICWum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:50:42 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FB4414B7A8C9;
        Tue,  3 Sep 2019 15:50:39 -0700 (PDT)
Date:   Tue, 03 Sep 2019 15:50:37 -0700 (PDT)
Message-Id: <20190903.155037.530228169649734979.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     bambi.yeh@realtek.com, hayeswang@realtek.com,
        amber.chen@realtek.com, netdev@vger.kernel.org,
        ryankao@realtek.com, jackc@realtek.com, albertk@realtek.com,
        marcochen@google.com, nic_swsd@realtek.com, grundler@chromium.org
Subject: Re: Proposal: r8152 firmware patching framework
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CACeCKadhJz3fdR+0rm+O2E39EbJgmN5NipMT8GRNtorus8myEg@mail.gmail.com>
References: <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
        <BAD4255E2724E442BCB37085A3D9C93AEEA087DF@RTITMBSVM03.realtek.com.tw>
        <CACeCKadhJz3fdR+0rm+O2E39EbJgmN5NipMT8GRNtorus8myEg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Sep 2019 15:50:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 3 Sep 2019 14:32:01 -0700

> I've moved David to the TO list to hopefully get his suggestions and
> guidance about how to design this in a upstream-compatible way.

I am not an expert in this area so please do not solicit my opinion.

Thank you.
