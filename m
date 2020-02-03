Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E70415130E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgBCXW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBCXW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 18:22:28 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03D1F20720;
        Mon,  3 Feb 2020 23:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580772148;
        bh=M8uT3OIpWlr106dtN396rnCU6f5+uzstcSUp8q2TEvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2iItBQaUwKcfL7MSeAiljeAGaXY70QxvZXeKA8f1dqU80csaJCxuoeCnc3tL5QWDU
         x/WKDNA7WjY/CuxWdu3EhmKoy+HTabwOKlOiZnmq22rwa8L9jj7okwKxvK7gZnhQyY
         4H4+v5fOuzDbp1xOtF1RjoZYT3RVy43cCgn7TcrU=
Date:   Mon, 3 Feb 2020 15:22:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes.
Message-ID: <20200203152227.20b0e93c@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
References: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Feb 2020 02:41:34 -0500, Michael Chan wrote:
> 3 patches that fix some issues in the firmware reset logic, starting
> with a small patch to refactor the code that re-enables SRIOV.  The
> last patch fixes a TC queue mapping issue.
> 
> Michael Chan (3):
>   bnxt_en: Refactor logic to re-enable SRIOV after firmware reset
>     detected.
>   bnxt_en: Fix RDMA driver failure with SRIOV after firmware reset.
>   bnxt_en: Fix TC queue mapping.
> 
> Vasundhara Volam (1):
>   bnxt_en: Fix logic that disables Bus Master during firmware reset.

Applied and added to stable queued, thank you!
