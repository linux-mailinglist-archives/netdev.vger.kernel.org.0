Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20C98EEC5
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbfHOO5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbfHOO5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 10:57:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01BD37EBC1;
        Thu, 15 Aug 2019 14:57:00 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC061EA;
        Thu, 15 Aug 2019 14:56:54 +0000 (UTC)
Date:   Thu, 15 Aug 2019 16:56:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     brouer@redhat.com, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] page_pool: remove unnecessary variable init
Message-ID: <20190815165653.508732bd@carbon>
In-Reply-To: <1565872860-63524-1-git-send-email-linyunsheng@huawei.com>
References: <1565872860-63524-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 15 Aug 2019 14:57:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 20:41:00 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> Remove variable initializations in functions that
> are followed by assignments before use
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
