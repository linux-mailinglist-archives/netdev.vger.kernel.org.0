Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A447310836
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEANQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:16:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfEANQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:16:39 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31A2D146D4354;
        Wed,  1 May 2019 06:16:38 -0700 (PDT)
Date:   Wed, 01 May 2019 09:16:36 -0400 (EDT)
Message-Id: <20190501.091636.921976773535468727.davem@davemloft.net>
To:     jan.kiszka@siemens.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baocheng.su@siemens.com, andy.shevchenko@gmail.com
Subject: Re: [PATCH] stmmac: pci: Fix typo in IOT2000 comment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <59169e7b-d58c-8c7e-e644-f8a7c8f60188@siemens.com>
References: <59169e7b-d58c-8c7e-e644-f8a7c8f60188@siemens.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 06:16:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>
Date: Mon, 29 Apr 2019 07:51:44 +0200

> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Applied.
