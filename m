Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955B613D65F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgAPJFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:05:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgAPJFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:05:03 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56DEB15B1BF94;
        Thu, 16 Jan 2020 01:05:01 -0800 (PST)
Date:   Thu, 16 Jan 2020 01:04:59 -0800 (PST)
Message-Id: <20200116.010459.56011403549196185.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-01-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115230437.25033-1-daniel@iogearbox.net>
References: <20200115230437.25033-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 01:05:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 16 Jan 2020 00:04:37 +0100

> The following pull-request contains BPF updates for your *net* tree.

Pulled, thanks Daniel.
