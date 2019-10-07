Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF942CEC6A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfJGTEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:04:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfJGTEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:04:31 -0400
Received: from localhost (unknown [50.237.170.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55D171477CBA6;
        Mon,  7 Oct 2019 12:04:30 -0700 (PDT)
Date:   Mon, 07 Oct 2019 21:04:29 +0200 (CEST)
Message-Id: <20191007.210429.503454070833457558.davem@davemloft.net>
To:     antonio.borneo@st.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: fix typo of "mechanism" in Kconfig help text
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007154306.95827-1-antonio.borneo@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 12:04:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>
Date: Mon, 7 Oct 2019 17:43:02 +0200

> Fix typo s/mechansim/mechanism/
> 
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>

Applied, thank you.
