Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBECA204097
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgFVTiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgFVTiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 15:38:22 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE5F320767;
        Mon, 22 Jun 2020 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592854701;
        bh=DXvjdrGQ3yYXZ1xMpIwoepraEtPiiR6PIBhKLza1dM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HXBkK8BBRowssIsPcViuIc2erjgv1vbRDujwCNEAmaEiPrcKCiJxeoS3KlgTjKCpO
         TjjeL/3iKIxC1go1llmqI7y2NVXGa+FrcEp6/ZbR+R33ZvzDMNZEBJ5EnboqDvHQNn
         rdhKn9NTeuL+RA6oQne/v7bJqM5Yov5ESc4lvhNc=
Date:   Mon, 22 Jun 2020 12:38:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Subject: Re: [PATCH 0/5] Adding Huawei BMA drivers
Message-ID: <20200622123820.3f7d8e3e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200622160311.1533-1-yunaixin03610@163.com>
References: <20200622160311.1533-1-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 00:03:06 +0800 yunaixin03610@163.com wrote:
> From: yunaixin <yunaixin03610@163.com>
> 
> This patch set contains 5 communication drivers for Huawei BMA software.
> The BMA software is a system management software. It supports the status
> monitoring, performance monitoring, and event monitoring of various
> components, including server CPUs, memory, hard disks, NICs, IB cards,
> PCIe cards, RAID controller cards, and optical modules.
> 
> These 5 drivers are used to send/receive message through PCIe channel in
> different ways by BMA software.

Please make sure patches build cleanly with W=1 C=1 flags and recent
version of gcc (preferably gcc-10).

Please address errors which checkpatch points out.

Please do no use static inline in C sources, only headers. Compiler
will know when to inline, anyway.
