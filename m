Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E946D173913
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgB1Nx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:53:26 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:51459 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgB1NxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:53:20 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 95871CECF9;
        Fri, 28 Feb 2020 15:02:44 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH 02/28] docs: networking: convert 6lowpan.txt to ReST
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <bfa773f25584a3939e0a3e1fc6bc0e91f415cd91.1581002063.git.mchehab+huawei@kernel.org>
Date:   Fri, 28 Feb 2020 14:53:18 +0100
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <08E2C17F-6A9D-441A-AEF0-5E2810A60376@holtmann.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
 <bfa773f25584a3939e0a3e1fc6bc0e91f415cd91.1581002063.git.mchehab+huawei@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

> - add SPDX header;
> - use document title markup;
> - mark code blocks and literals as such;
> - adjust identation, whitespaces and blank lines;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
> .../networking/{6lowpan.txt => 6lowpan.rst}   | 29 ++++++++++---------
> Documentation/networking/index.rst            |  1 +
> 2 files changed, 17 insertions(+), 13 deletions(-)
> rename Documentation/networking/{6lowpan.txt => 6lowpan.rst} (64%)

patch has been applied to bluetooth-next tree.

Regards

Marcel

