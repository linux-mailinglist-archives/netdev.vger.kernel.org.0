Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1454201BB6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391076AbgFST4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390834AbgFST4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:56:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7EFC06174E;
        Fri, 19 Jun 2020 12:56:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81E1E1285606A;
        Fri, 19 Jun 2020 12:56:41 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:56:40 -0700 (PDT)
Message-Id: <20200619.125640.2128434436244521418.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com
Subject: Re: [PATCH 1/2] docs: net: ieee802154: change link to new project
 URL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c8631876-8aea-c56d-105e-6866c74964ce@datenfreihafen.org>
References: <20200616065814.816248-1-stefan@datenfreihafen.org>
        <c8631876-8aea-c56d-105e-6866c74964ce@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 12:56:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Fri, 19 Jun 2020 09:14:22 +0200

> I see you marked both patches here as awaiting upstream in
> patchwork. I am not really sure what to do best now. Am I supposed to
> pick them up myself and send them in my usual ieee802154 pull request?
> 
> Before you had been picking up docs and MAINTAINERS patches
> directly. I am fine with either way. Just want to check what you
> expect.

Please put it into a pull request, thank you.
