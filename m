Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E990302D8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3Te0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:34:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3Te0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:34:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21A1714DA8199;
        Thu, 30 May 2019 12:34:26 -0700 (PDT)
Date:   Thu, 30 May 2019 12:34:25 -0700 (PDT)
Message-Id: <20190530.123425.1339903611009203943.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next 0/2] net: stmmac: selftests: Two fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1559118521.git.joabreu@synopsys.com>
References: <cover.1559118521.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:34:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed, 29 May 2019 10:30:24 +0200

> Two fixes reported by kbuild.

Series applied.
