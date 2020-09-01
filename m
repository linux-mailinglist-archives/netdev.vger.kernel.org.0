Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC681259E47
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgIASmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIASmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:42:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB92C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:42:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AD621362DF03;
        Tue,  1 Sep 2020 11:25:47 -0700 (PDT)
Date:   Tue, 01 Sep 2020 11:42:32 -0700 (PDT)
Message-Id: <20200901.114232.1801810821820650399.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     sbrivio@redhat.com, pshelar@ovn.org, xiyou.wangcong@gmail.com,
        dev@openvswitch.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] net: openvswitch: improve the codes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
References: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:25:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Tue,  1 Sep 2020 20:26:11 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This series patches are not bug fix, just improve codes.

Series applied, thanks.
