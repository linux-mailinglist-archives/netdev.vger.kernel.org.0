Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4293810E1
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhENTdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231479AbhENTdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8B106145A;
        Fri, 14 May 2021 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621020729;
        bh=yVhrl+vOeADlxlJDwQkNYpNgRByMVHjnVNkcIbPhh0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QhCrTad6G1IrkASyv4crWWfzrEWLl4vqIn+/bCYrOMdwO4aKCfhvS4ja+3Jgl4GIJ
         6KaYKYPWLvj40h1qkuS1fgqSoVGE78woF/hHDbN7QWqUNV1Fy9V/9brBspbHChwRc2
         D7gk/XDq1vQNJOm92Y/ZsuLXfHCuTRM/UiAxEVaS/o6Ea19t6psf7xZsqhP3t6w/5J
         ee6A9OSpi1l2h+b7w5cMVFuCwJuy5J/qWtc5xxIiJwt8alX1KscYp6KURz2tYmchpl
         0QwE+WaeKeCXGNYfcknvym4i80di6F6qFiyr6HBLWWJCvJTgFT10NgfAeXJ7t+aPaj
         6IKmoMQQoy09A==
Date:   Fri, 14 May 2021 12:32:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        bongsu.jeon@samsung.com, andrew@lunn.ch, wanghai38@huawei.com,
        zhengyongjun3@huawei.com, alexs@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Subject: Re: [PATCH] NFC: nci: fix memory leak in nci_allocate_device
Message-ID: <20210514123208.5792246d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514074248.780647-1-mudongliangabcd@gmail.com>
References: <20210514074248.780647-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 15:42:48 +0800 Dongliang Mu wrote:
>  struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev);
>                 void nci_hci_allocate(struct nci_dev *ndev);

This patch does not build.
