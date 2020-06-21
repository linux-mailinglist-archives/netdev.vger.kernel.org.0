Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE5620278F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgFUAXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbgFUAXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:23:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7F9C061794;
        Sat, 20 Jun 2020 17:23:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF250120ED4AD;
        Sat, 20 Jun 2020 17:22:58 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:22:55 -0700 (PDT)
Message-Id: <20200620.172255.1570205815461958163.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     andrea.mayer@uniroma2.it, dsahern@kernel.org, shrijeet@gmail.com,
        kuba@kernel.org, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        sharpd@cumulusnetworks.com, roopa@cumulusnetworks.com,
        didutt@gmail.com, stephen@networkplumber.org,
        stefano.salsano@uniroma2.it, paolo.lungaroni@cnit.it,
        ahabdels@gmail.com
Subject: Re: [net-next,v1,0/5] Strict mode for VRF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f13c47d2-6b08-8f73-05d2-755a40fba6a8@gmail.com>
References: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
        <f13c47d2-6b08-8f73-05d2-755a40fba6a8@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:22:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Sat, 20 Jun 2020 16:32:53 -0700

> On 6/19/20 3:54 PM, Andrea Mayer wrote:
>> This patch set adds the new "strict mode" functionality to the Virtual
>> Routing and Forwarding infrastructure (VRF). Hereafter we discuss the
>> requirements and the main features of the "strict mode" for VRF.
>> 
> 
> For the set:
> Acked-by: David Ahern <dsahern@gmail.com>

Series applied to net-next, thanks.
