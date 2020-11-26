Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF1A2C5471
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbgKZNFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:05:49 -0500
Received: from mout.gmx.net ([212.227.17.21]:60557 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389558AbgKZNFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 08:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1606395936;
        bh=Jcvfeu+eSMGi/ZV556raYsjES8kBmmKpALlhTbe6nzI=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=d5Hj//1lgPBQVNNpmVfOlI4jIXJkWV0WFaDhXIXLNGmuPsmi4st+wfUEiDsYjnAZu
         6zx9wakoxh8YhNR9Swejv5nIaUYUi6EGGyUR0sYgtVV8RFLA9g2mwIKSBwrQztE4yJ
         2FC+uL/l0PEZ4FCbTfGj6gW1HxzyjJXTQOCe4kMw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel ([84.154.209.252]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MxDkm-1kK0zI2Mps-00xfUv; Thu, 26
 Nov 2020 14:05:36 +0100
Date:   Thu, 26 Nov 2020 14:05:34 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        joe@perches.com
Subject: Re: [PATCH net-next v2 2/2] lib8390: Cleanup variables
Message-ID: <20201125222701.GA10510@MX-Linux-Intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:D0hYCTSil35T7kUjg7EaKkGfFAHSg1aq9qNSZtKAdiIAGGAMjQv
 sR/n4up2qr8jVdw6cubE7EoBAHBnG8GPYZC90dFk7qW7V4Oa4c7WIjxhp4bmFA+T6a43Ty9
 eT9rSxvhNvVLiEVdDlg1eyZyYVZbQI7c8T1cS5KsiOySucpfl0kdbDyvbThGgf3bOW4G1aj
 0HISzlmcuFkLqxpfZ/uIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iITHFVQTpRk=:Ithncsp/QaCmb2F87SD8w/
 6J07h9CcBmiT2tdzuL61rrtzGaVCs2pMplv0FUEpH8BOMadZeQA+jP3DLFEnx2yowdKGOZgNj
 +gtYvTaJHr3ZOIHEayyTUbFsWrbGFhJa2WUxN/VLiPBWxVzYBzkhF/bR7nWFFmEJoRpuekDsC
 IXa51WJkI6LpQ88+0HMQIORImckMfqSmAOcnhc/Wj9LCw+0szOuwjms1RvWH4AFzgN9gv3lx/
 bAbhq9/GhYFjoCOpo4BmDgLpgPAYpJyTxSqvnY/w4dMn+wxbqE6uPV8tQaecUs+0oCAkkSbnv
 kq0EfztrvongwGOT875QmM6W+n6TkoHzeAXIDJ+v/vk7TRBA8Bk5+liUnflpX/EdtK6kcXvfg
 /bYCQ5ZHhUHtrQcTEJv7Kj1ZrV5obGLlBiUONslI7eNLZSo75uaIpYcAjR4HJnl3ssCB6MLVk
 MMrWS/R5ZCL6WY+3Pxd6+gqnDgiNkH+pg3iRmpQT0C+pKX8yw2EC6qPqwR/qIFAsQbLhrjsVT
 5LXLMitzGHEJThMnbNocrgmF53gCetjzPiw0ViFa3AH0awywKYGABceMUCk5/qmyQGY+R8h10
 Z3bb4c8PEH2vfywtH6a8moTgpqmNr9zhopO12T9vYTLACxKQUzFc8PfOKkNK6yTp0UjMUkf2Z
 Xiy2ZxrA8brFwhsVGoW9NqH80vtow1YZmMyXm5gPhJUnijPxr+2V9pKonR1vA2NHFGSO2jOgH
 xTkxCuaVic773ALdAeWhVUzVHCy2mOEUCIl388x9ul+SggEjKL+mawtohkYwnxwvszGe/5LSS
 E/Kt4pdwpII0Bw2D5RZT8LMx62rQ8tUy7R8pk8jiy3Jxa8Zquox8W5okl+WK4Z1d8mhLzdlst
 gesWagD1I2ZFvkl1bikg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<20201120120235.1925e713@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

I would indeed like to become the maintainer of this driver,
as I do in fact still have working hardware using this code
(a Realtek 8029AS).
Unfortunately, i am still considering myself too inexperienced in
kernel development to become a maintainer.

So maybe i should at first gather more experience by studying
other nic drivers.

Sorry for bothering.
