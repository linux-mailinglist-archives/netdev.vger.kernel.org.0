Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20711BF420
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3J1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726502AbgD3J1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 05:27:53 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F189FC035494;
        Thu, 30 Apr 2020 02:27:52 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jU5Tk-0007ai-Hb; Thu, 30 Apr 2020 11:27:36 +0200
Date:   Thu, 30 Apr 2020 11:27:36 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] rtw88: fix spelling mistake "fimrware" ->
 "firmware"
Message-ID: <20200430092736.q7agn7u4hr2nsrov@linutronix.de>
References: <20200424084733.7716-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200424084733.7716-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-24 09:47:33 [+0100], Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are spelling mistakes in two rtw_err error messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
