Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94805160062
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBOUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgBOUJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 15:09:20 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-71-202-252-80.hsd1.ca.comcast.net [71.202.252.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 551F320675;
        Sat, 15 Feb 2020 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581797359;
        bh=WrnU7XfWECRF/CKZymfuMIZWVJ3S3RUxCGbaHCZNUrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X6c909bmFmOxlUKAN1VniiVse+LFnx91xbloy7OEJW4GSA/fxhJB6AmlNviJtxObN
         0KdwBU1GHERRvrsd+uK8U64ACFXEXPDel4cQ6ZJkhry7aCiw7RWWT4NYZyUDc+WW34
         8Gx+//J/zjaxMyzPdtr+QPfDY6PIu80ywR3GQlzI=
Date:   Sat, 15 Feb 2020 12:09:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 00/19] bpf: Make BPF and PREEMPT_RT co-exist
Message-ID: <20200215120917.2c21e31f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200214133917.304937432@linutronix.de>
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 14:39:17 +0100 Thomas Gleixner wrote:
>    1) All interrupts, which are not explicitely marked IRQF_NO_THREAD, are

nit: s/explicitely/explicitly/ throughout (incl. code comments)
