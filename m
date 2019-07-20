Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465A16EDC5
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 06:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGTE2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 00:28:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfGTE2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 00:28:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9C6A15313AB9;
        Fri, 19 Jul 2019 21:28:08 -0700 (PDT)
Date:   Fri, 19 Jul 2019 21:28:08 -0700 (PDT)
Message-Id: <20190719.212808.1758131866823848034.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, jakub.kicinski@netronome.com, pshelar@ovn.org
Subject: Re: [PATCH nf,v5 0/4] flow_offload fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719162016.10243-1-pablo@netfilter.org>
References: <20190719162016.10243-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jul 2019 21:28:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 19 Jul 2019 18:20:12 +0200

> The following patchset contains fixes for the flow_offload infrastructure:

Series applied, please fix the build failure reported by Jakub.
