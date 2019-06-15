Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE8F46DAD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfFOCGN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 22:06:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:06:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E1FA12EB0322;
        Fri, 14 Jun 2019 19:06:12 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:06:11 -0700 (PDT)
Message-Id: <20190614.190611.707961514645513631.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     rspmn@arcor.de, dnlplm@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] qmi_wwan: fix QMAP handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <874l4t8j6n.fsf@miraculix.mork.no>
References: <cover.1560287477.git.rspmn@arcor.de>
        <874l4t8j6n.fsf@miraculix.mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:06:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Thu, 13 Jun 2019 19:54:40 +0200

> Reinhard Speyerer <rspmn@arcor.de> writes:
> 
>> This series addresses the following issues observed when using the
>> QMAP support of the qmi_wwan driver:
> 
> Really nice work!  Thanks.
> 
> Acked-by: Bjørn Mork <bjorn@mork.no>

Series applied.
