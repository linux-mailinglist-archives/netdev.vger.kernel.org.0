Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EE6361F13
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242085AbhDPLrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 07:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240473AbhDPLrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 07:47:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C5F610FC;
        Fri, 16 Apr 2021 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618573601;
        bh=Ls818vfdmxh0kbfURMXnvoqBE1G/Wvr1I49oaH5MzL4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=a0Tm1bdyIVwIXoc3ibleEqxd0G1OHGA2pQQn86dnNgUOVrybfv/1yLhbX9W3P8QbR
         Q1WGmpVM/p0ql57EWh9v+sJNS25Cb9oSHq1qnbgMPl4ZYfd5OYLF/oJFf92rBpJnPq
         2GXEaui3D0PNFarim7GbtiMwDbQVdVrrxhRHFZYU5VJOmdp3blq0/pcFE80Ypsz4cs
         hIgpJB3EDPKWSXIUqotdQhz+cpExtOyW8dIC342fj2DmnCcqMG8AvWs3EQC0erq/id
         m1+3mJ2lTQc/2xI9uonPfq9nE/7MSwparvJHb7t0Os52SJP8H6dhRIptQnNsbeejgb
         kcwY1Oy1yqtJQ==
Date:   Fri, 16 Apr 2021 13:46:37 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Juergen Gross <jgross@suse.com>
cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
In-Reply-To: <70dc383f-6a10-a16b-3972-060cdd8ec2d4@suse.com>
Message-ID: <nycvar.YFH.7.76.2104161344340.18270@cbobk.fhfr.pm>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com> <20210409090909.1767-1-hdanton@sina.com> <20210412032111.1887-1-hdanton@sina.com> <20210412072856.2046-1-hdanton@sina.com> <20210413022129.2203-1-hdanton@sina.com> <20210413032620.2259-1-hdanton@sina.com>
 <20210413071241.2325-1-hdanton@sina.com> <20210413083352.2424-1-hdanton@sina.com> <1cd37014-4b2a-b82c-0cfc-6beffb8d36de@huawei.com> <70dc383f-6a10-a16b-3972-060cdd8ec2d4@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021, Juergen Gross wrote:

> > what Jiri said about "I am still planning to have Yunsheng Lin's
> > (CCing) fix [1] tested in the coming days." is that Juergen has
> > done the test and provide a "Tested-by" tag.
> 
> Correct. And I did this after Jiri asking me to do so.

Exactly, Juergen's setup is the one where this issue is being reproduced 
reliably for us, and Juergen verified that your patch fixes that issue.

Seeing that you now also addressed the STATE_DEACTIVATED issue (which we 
don't have reproducer for though), I think your series should be good to 
go if the STATE_DEACTIVATED fix has been verified independently.

Thanks!

-- 
Jiri Kosina
SUSE Labs

